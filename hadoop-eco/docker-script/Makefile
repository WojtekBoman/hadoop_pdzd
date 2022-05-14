.PHONY: up down hadoop-start hadoop-stop hive-init hive-start hive-stop e7-init e7-test e7-mapreduce

up:
	./compose-up.sh 3.3.0 3 /tmp/hadoop /tmp/hadoop_logs /tmp/hbase_logs /tmp/hive_logs /tmp/sqoop_logs mariadb /tmp/maria

down:
	./compose-down.sh

hadoop-start:
	./hadoop-start.sh start

hadoop-stop:
	./hadoop-stop.sh

hive-init:
	./hive-start.sh all

hive-start:
	./hive-start.sh

hive-stop:
	./hive-stop.sh

ftp-download:
	docker exec -it master /pdzd/main/download_files.sh

e7-init:
	docker exec -it master /pdzd/main/0-init.sh

e7-test:
	docker exec -it master /pdzd/test/0-init-test.sh
	
e7-mapreduce:
	docker exec -it master /pdzd/test/0-mapreduce.sh
