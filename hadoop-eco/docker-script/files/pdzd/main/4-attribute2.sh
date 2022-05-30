#!/usr/bin/env bash

OUT_PATH=/tmps/tmp2_done
CLASSES_PATH=/tmp/attribute2_classes

removeOldFiles() {
  echo "Removing old mapreduce files from HDFS if any exists."
  hdfs dfs -rm -r ${OUT_PATH}
}

compileAttribute2() {
  echo "export HADOOP_CLASSPATH=$(hadoop classpath)" >> ~/.bashrc
  source ~/.bashrc

  mkdir -p /tmp/attribute2_classes
  javac -classpath $HADOOP_CLASSPATH -d /tmp/attribute2_classes /pdzd/main/4-attribute2/Attribute2.java
  jar -cvf Attribute2.jar -C /tmp/attribute2_classes .
}

runAttribute2() {
  yarn jar Attribute2.jar Attribute2 /tmps/tmp2_src.csv ${OUT_PATH} -- | tee -a /tmp/pdzd/logs/attribute2.log
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

runSpark() {
  echo "Producing output file with Spark"
  spark-shell --conf spark.driver.args="/tmps/cars_src.csv ${OUT_PATH}/part-r-00000 /tmps/tmp2.csv" < /pdzd/main/4-attribute2/attribute2b.scala -- | tee -a /tmp/pdzd/logs/attribute2.log
}

removeOldFiles
compileAttribute2
runAttribute2
verifyResults
runSpark
