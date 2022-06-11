#!/usr/bin/env bash

echo "Creating trg database"
beeline -u jdbc:hive2://master:10000 hive org.apache.hive.jdbc.HiveDriver -f /pdzd/main/6-populate-hive/0-create-database.sql

echo "Importing cars"
#hdfs dfs -cp /tmps/cars_src.csv /tmps/hive_cars.csv
beeline -u jdbc:hive2://master:10000 hive org.apache.hive.jdbc.HiveDriver -f /pdzd/main/6-populate-hive/1-cars.sql

echo "Importing attribute 1"
#hdfs dfs -cp /tmps/tmp1.csv /tmps/hive_tmp1.csv
beeline -u jdbc:hive2://master:10000 hive org.apache.hive.jdbc.HiveDriver -f /pdzd/main/6-populate-hive/2-attribute1.sql

echo "Importing attribute 2"
#hdfs dfs -cp /tmps/tmp2.csv /tmps/hive_tmp2.csv
beeline -u jdbc:hive2://master:10000 hive org.apache.hive.jdbc.HiveDriver -f /pdzd/main/6-populate-hive/2-attribute2.sql

echo "Importing attribute 3"
#hdfs dfs -cp /tmps/tmp3.csv /tmps/hive_tmp3.csv
beeline -u jdbc:hive2://master:10000 hive org.apache.hive.jdbc.HiveDriver -f /pdzd/main/6-populate-hive/2-attribute3.sql

echo "Importing attribute 4"
#hdfs dfs -cp /tmps/tmp4.csv /tmps/hive_tmp4.csv
beeline -u jdbc:hive2://master:10000 hive org.apache.hive.jdbc.HiveDriver -f /pdzd/main/6-populate-hive/2-attribute4.sql

beeline -u jdbc:hive2://master:10000 hive org.apache.hive.jdbc.HiveDriver -f /pdzd/main/6-populate-hive/3-trg.sql
