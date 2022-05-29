#!/usr/bin/env bash

TEST_DIR=test_data
SRC_FILE=cars_src.csv
EXPECTED_FILE=expected_result.csv

cleanTestDirectory() {
  echo "Removing test directory."
  hdfs dfs -rm -r /${TEST_DIR}
}

putToHDFS() {
  echo "Putting test files to HDFS."
  hdfs dfs -mkdir /${TEST_DIR}
  hdfs dfs -put /pdzd/test/${TEST_DIR}/${SRC_FILE} /${TEST_DIR}
  hdfs dfs -put /pdzd/test/${TEST_DIR}/${EXPECTED_FILE} /${TEST_DIR}
}

runSparkTest() {
  echo "Running test ..."
  spark-shell < /pdzd/test/4-attribute1-test.scala
}

cleanTestDirectory
putToHDFS
runSparkTest

