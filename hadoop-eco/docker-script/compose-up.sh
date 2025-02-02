#!/bin/bash

hadoop_version=$1
slaves=$2
hdfs_path=$3
hadoop_log_path=$4
hbase_log_path=$5
hive_log_path=$6
sqoop_log_path=$7
maria_root_password=$8
maria_data_path=$9

if [ -z $maria_data_path ]
then
  echo "Some parameter value is empty. Usage: compose-up.sh <hadoop_version> <(The # of) slaves [integer]> <hdfs_path> <hadoop_log_path> <hbase_log_path> <hive_log_path> <sqoop_log_path> <mariaDB_root_password> <mariaDB_data_path>"
  exit 1
fi

if [[ ! $slaves =~ ^-?[0-9]+$ ]]
then
  echo "The # of slaves is not integer."
  exit 1
elif [[ $slaves -le 1 ]]
then
  slaves=1
elif [[ $slaves -gt 5 ]]
then
  slaves=5
fi

echo "Set docker-compose.yml file."

for slave in $(seq 1 $slaves)
do
  workers+=slave$slave
  if [[ ! $slave -eq $slaves ]]
  then
    workers+='
'
  fi
done

cat << EOF > workers
master
$workers
EOF

cat << EOF > regionservers
$workers
EOF

for slave in $(seq 1 $slaves)
do
  ip_addr+='      - "'slave$slave':10.0.3.'$(($slave + 3))'"
'
done

for slave in $(seq 1 $slaves)
do
  slave_service+='  'slave$slave':
    image: hjben/hbase:1.6.0-hadoop'$hadoop_version'
    hostname: 'slave$slave'
    container_name: 'slave$slave'
    privileged: true
    ports:
      - '$((16029 + $slave))':16030
    volumes:
      - /sys/fs/cgroup:/sys/fs/cgroup
      - '$hbase_log_path'/slave'$slave':/usr/local/hbase/logs
      - ./files/pdzd:/pdzd
      - ../hbase/conf/hbase-site.xml:/usr/local/hbase/conf/hbase-site.xml
      - ../../hadoop/conf/hdfs-site.xml:/usr/local/hadoop-3.3.0/etc/hadoop/hdfs-site.xml
    networks:
      hadoop-cluster:
        ipv4_address: 10.0.3.'$(($slave + 3))'
    extra_hosts:
      - "mariadb:10.0.3.2"
      - "master:10.0.3.3"
      - "ftpslave:10.0.3.7"
'$ip_addr
  if [[ ! $slave -eq $slaves ]]
  then
    slave_service+='
'
  fi
done

cat << EOF > docker-compose.yml
version: "3"
services:
  ftp:
    image: fauria/vsftpd
    hostname: ftpslave
    container_name: ftpslave
    privileged: true
    ports:
      - "20:20"
      - "21:21"
      - "21100-21110:21100-21110"
    environment:
      FTP_USER: ftp
      FTP_PASS: ftp
    volumes:
      - ./files:/home/vsftpd
    networks:
      hadoop-cluster:
       ipv4_address: 10.0.3.7
    extra_hosts:
      - "mariadb:10.0.3.2"
      - "master:10.0.3.3"
      - "ftpslave:10.0.3.7"
  mariadb:
    image: mysql:5.7.38
    command: --default-authentication-plugin=mysql_native_password
    restart: always
    environment:
      MYSQL_ROOT_PASSWORD: mariadb
#    image: hjben/mariadb:10.5
    hostname: mariadb
    container_name: mariadb
    privileged: true
    ports:
      - 3306:3306
    volumes:
      - ../../mariadb/conf/init-hive.sql:/docker-entrypoint-initdb.d/init-hive.sql
#      - /sys/fs/cgroup:/sys/fs/cgroup
#      - ../../mariadb/conf/server.cnf:/etc/my.cnf.d/server.cnf
#      - $maria_data_path:/var/lib/mysql
#    environment:
#      MARIADB_ROOT_PASSWORD: $maria_root_password
    networks:
      hadoop-cluster:
        ipv4_address: 10.0.3.2
    extra_hosts:
      - "mariadb:10.0.3.2"
      - "master:10.0.3.3"
      - "ftpslave:10.0.3.7"
$ip_addr
  master:
    build:
      context: ./images/master
      dockerfile: Dockerfile
    image: pdzd/hadoop-eco
    hostname: master
    container_name: master
    privileged: true
    ports:
      - 4040:4040
      - 8088:8088
      - 9870:9870
      - 8042:8042
      - 10000:10000
      - 10002:10002
      - 18080:18080
      - 16010:16010
      - 50070:50070
    volumes:
      - /sys/fs/cgroup:/sys/fs/cgroup
      - $hdfs_path:/data/hadoop
      - $hadoop_log_path:/usr/local/hadoop/logs
      - $hbase_log_path/master:/usr/local/hbase/logs
      - $hive_log_path:/usr/local/hive/logs
      - $sqoop_log_path:/usr/local/sqoop/logs
      - ./files/pdzd:/pdzd
      - ../hbase/conf/hbase-site.xml:/usr/local/hbase-1.6.0/conf/hbase-site.xml
      - ../../hadoop/conf/hdfs-site.xml:/usr/local/hadoop-3.3.0/etc/hadoop/hdfs-site.xml
    networks:
      hadoop-cluster:
        ipv4_address: 10.0.3.3
    extra_hosts:
      - "mariadb:10.0.3.2"
      - "master:10.0.3.3"
      - "ftpslave:10.0.3.7"
$ip_addr
$slave_service
networks:
 hadoop-cluster:
  ipam:
   driver: default
   config:
   - subnet: 10.0.3.0/24
EOF
echo "Done."

echo "Docker-compose container run."
# echo "Remove old containers."
# docker-compose down --remove-orphans
# sleep 1

echo "Create new containers."
docker-compose up -d
sleep 1

docker cp ./workers master:/usr/local/hadoop/etc/hadoop/workers
docker cp ./regionservers master:/usr/local/hbase/conf/regionservers
for slave in $(seq 1 $slaves)
do
  docker cp ./workers slave$slave:/usr/local/hadoop/etc/hadoop/workers
  docker cp ./regionservers slave$slave:/usr/local/hbase/conf/regionservers
done

cat << EOF > init-hive.sql
create database hive;
create user hive@'%' identified by 'hive';
grant all privileges on hive.* to hive@'%';
EOF

docker cp init-hive.sql mariadb:/sh/
docker exec -it mariadb bash -c "chmod 755 /sh/init-hive.sql"

rm -f workers
rm -f regionservers
rm -f init-hive.sql
echo "Done."
