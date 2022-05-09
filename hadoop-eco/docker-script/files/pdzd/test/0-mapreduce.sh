#!/usr/bin/env bash

OUT_PATH=/cars/out
CLASSES_PATH=/tmp/wordcount_classes

removeOldFiles() {
  echo "Removing old mapreduce files from HDFS if any exists."
  hdfs dfs -rm -r ${OUT_PATH}
}

compileWordCount() {
  echo "export HADOOP_CLASSPATH=$(hadoop classpath)" >> ~/.bashrc
  source ~/.bashrc

  mkdir -p /tmp/wordcount_classes
  javac -classpath $HADOOP_CLASSPATH -d /tmp/wordcount_classes /pdzd/WordCount.java
  jar -cvf WordCount.jar -C /tmp/wordcount_classes .
}

runWordCount() {
  yarn jar WordCount.jar WordCount /cars/test_cars.csv /cars/out
}

verifyResults() {
  echo "Verifying if MapReduce has been run successfully"
  CARS_FC=$(hdfs dfs -ls ${OUT_PATH} | grep "_SUCCESS" | wc -l)
  if [[ ($CARS_FC == 1) ]]; then
    echo "MapReduce has been run successfully and the results are present in ${OUT_PATH}."
  else
    echo "MapReduce has failed."
  fi
}

removeOldFiles
compileWordCount
runWordCount
verifyResults
