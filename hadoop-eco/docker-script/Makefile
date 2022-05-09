.PHONY: up down start init test

up:
	./compose-up.sh 3.3.0 3 /tmp/hadoop /tmp/hadoop_logs /tmp/hbase_logs /tmp/hive_logs /tmp/sqoop_logs mariadb /tmp/maria

down:
	./compose-down.sh

start:
	./hadoop-start.sh start

init:
	docker exec -it master /pdzd/main/0-init.sh

test:
	docker exec -it master /pdzd/test/0-init-test.sh
