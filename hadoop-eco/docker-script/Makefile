.PHONY: clean up down hadoop-start hadoop-stop hive-init hive-start hive-stop e7-init e7-test e7-mapreduce spark-shell spark-start e7-spark

clean:
	docker image rm pdzd/hadoop-eco:latest

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

spark-start:
	docker exec -it master start-master.sh
	docker exec -it master start-history-server.sh

spark-shell:
	docker exec -it master spark-shell

ftp-download:
	docker exec -it master /pdzd/main/1-download_files.sh

e7-init:
	docker exec -it master /pdzd/main/0-init.sh

e7-test:
	docker exec -it master /pdzd/test/0-init-test.sh

e7-mapreduce:
	docker exec -it master /pdzd/test/0-mapreduce.sh

e7-spark:
	docker exec -it master /pdzd/test/0-spark-test.sh

e7-hive:
	docker exec -it master /pdzd/test/0-hive-test.sh

e9-filtering:
	docker exec -it master /pdzd/main/2-filtering.sh

e9-tmp1:
	docker exec -it master spark-shell -i /pdzd/main/4-attribute1.scala

e9-tmp1-test:
	docker exec -it master /pdzd/test/4-attribute1-test.sh

e9-tmp2:
	docker exec -it master /pdzd/main/4-attribute2.sh

e9-tmp3:
	docker exec -it master /pdzd/test/spark-3.sh

e9-tmp4:
	docker exec -it master spark-shell -i /pdzd/main/4-attribute4.scala

e9-tmp2-test:
	docker exec -it master /pdzd/test/4-attribute2-test.sh

e9-tmp4-test:
	docker exec -it master /pdzd/test/4-attribute4-test.sh
3a-test:
	docker exec -it master /pdzd/test/spark-3a-test.sh
3b-test:
	docker exec -it master /pdzd/test/spark-3b-test.sh

e9-hive:
	docker exec -it master /pdzd/main/6-populate-hive.sh
