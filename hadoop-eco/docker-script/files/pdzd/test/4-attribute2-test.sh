#!/usr/bin/env bash

TEST_DIR=test_data
CARS_FILE=cars.csv
EXPECTED_FILE=expected_result_2.csv
OUT_PATH=/tmps/test2_done
CLASSES_PATH=/tmp/attribute2_classes

removeOldFiles() {
  echo "Removing old mapreduce files from HDFS if any exists."
  hdfs dfs -rm -r ${OUT_PATH}
}

cleanTestDirectory() {
  echo "Removing test directory."
  hdfs dfs -rm -r /pdzd/test/${TEST_DIR}
}

putToHDFS() {
  echo "Putting test files to HDFS."
  hdfs dfs -mkdir -p /pdzd/test/${TEST_DIR}
  hdfs dfs -put -f /pdzd/test/${TEST_DIR}/${CARS_FILE} /pdzd/test/${TEST_DIR}/${CARS_FILE}
  hdfs dfs -put -f /pdzd/test/${TEST_DIR}/${EXPECTED_FILE} /pdzd/test/${TEST_DIR}/${EXPECTED_FILE}
}

compileMapReduce() {
  echo "export HADOOP_CLASSPATH=$(hadoop classpath)" >> ~/.bashrc
  source ~/.bashrc

  mkdir -p /tmp/attribute2_classes
  javac -classpath $HADOOP_CLASSPATH -d /tmp/attribute2_classes /pdzd/main/4-attribute2/Attribute2.java
  jar -cvf Attribute2.jar -C /tmp/attribute2_classes .
}

runMapReduce() {
  yarn jar Attribute2.jar Attribute2 /tmps/tmp2_src.csv ${OUT_PATH}
}

verifyMapReduce() {
  echo "Verifying MapReduce has been run successfully"
  CARS_FC=$(hdfs dfs -ls ${OUT_PATH} | grep "_SUCCESS" | wc -l)
  if [[ ($CARS_FC == 1) ]]; then
    echo "MapReduce has been run successfully and the results are present in ${OUT_PATH}."
  else
    echo "MapReduce has failed."
  fi
}

runSpark() {
  echo "Producing output file with Spark"
  spark-shell --conf spark.driver.args="/pdzd/test/${TEST_DIR}/${CARS_FILE} ${OUT_PATH}/part-r-00000 /pdzd/test/${TEST_DIR}/tmp2.csv" < /pdzd/main/4-attribute2/attribute2b.scala
}

verifyResult() {
  echo "Verifying attribute2 output"
  spark-shell --conf spark.driver.args="/pdzd/test/${TEST_DIR}/tmp2.csv /pdzd/test/${TEST_DIR}/${EXPECTED_FILE}" < /pdzd/test/4-attribute2-test.scala
}

removeOldFiles
cleanTestDirectory
putToHDFS
compileMapReduce
runMapReduce
verifyMapReduce
runSpark
verifyResult
