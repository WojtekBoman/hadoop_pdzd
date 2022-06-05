#!/usr/bin/env bash

TEST_DIR=test_data
CARS_FILE=cars_10.csv
GEO_FILE=geo.csv
EXPECTED_FILE=expected_result_4.csv

cleanTestDirectory() {
  echo "Removing test directory."
  hdfs dfs -rm -r /${TEST_DIR}
}

putToHDFS() {
  echo "Putting test files to HDFS."
  hdfs dfs -mkdir /${TEST_DIR}
  hdfs dfs -put /pdzd/test/${TEST_DIR}/${CARS_FILE} /${TEST_DIR}
  hdfs dfs -put /pdzd/test/${TEST_DIR}/${GEO_FILE} /${TEST_DIR}
  hdfs dfs -put /pdzd/test/${TEST_DIR}/${EXPECTED_FILE} /${TEST_DIR}
}

runSparkTest() {
  echo "Running test ..."
  spark-shell < /pdzd/test/4-attribute4-test.scala
}

cleanTestDirectory
putToHDFS
runSparkTest

