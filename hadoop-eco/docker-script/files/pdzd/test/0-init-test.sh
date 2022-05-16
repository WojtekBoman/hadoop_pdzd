#!/usr/bin/env bash

RF=4
CARS_DIR=cars
GEO_DIR=geo
TEST_FILE=test_cars.csv

checkEmptyDirectoriesExist() {
  echo "Checking if directories exist and are empty."
  CARS_C=$(hdfs dfs -ls / | grep cars | wc -l)
  GEO_C=$(hdfs dfs -ls / | grep geo | wc -l)

  if [[ ($CARS_C == 1 && $GEO_C == 1) ]]; then
    CARS_FC=$(hdfs dfs -ls /${CARS_DIR} | grep ${TEST_FILE} | wc -l)
    GEO_FC=$(hdfs dfs -ls /${GEO_DIR} | grep ${TEST_FILE} | wc -l)
    if [[ ($CARS_FC == 1 || $GEO_FC == 1) ]]; then
      echo "File already exists."
      exit 1
    else
      echo "Directories exist and are empty."
    fi
  else
    echo "Directories are missing."
    exit 1
  fi
}

downloadTestFile() {
  echo "Downloading test_cars.csv from ftp."
  curl -u ftp:ftp 'ftp://ftpslave/cars/2022_05.csv' -o /tmp/${TEST_FILE}
}

putToHDFS() {
  echo "Putting test_cars.csv to HDFS."
  hdfs dfs -put /tmp/${TEST_FILE} /${CARS_DIR}
  hdfs dfs -put /tmp/${TEST_FILE} /${GEO_DIR}
}

verifyPut() {
  echo "Verifying if test_cars.csv was put correctly."
  CARS_FC=$(hdfs dfs -ls /${CARS_DIR} | grep ${TEST_FILE} | wc -l)
  GEO_FC=$(hdfs dfs -ls /${GEO_DIR} | grep ${TEST_FILE} | wc -l)
  if [[ ($CARS_FC == 1 && $GEO_FC == 1) ]]; then
    echo "Files are in HDFS."
  else
    echo "Directories exist and are empty."
  fi
}

verifyReplication() {
  echo "Verifying if test_cars.csv is correctly replicated."
  CARS_RC=$(hdfs dfs -ls /${CARS_DIR} | grep ${TEST_FILE} | awk -F ' ' '{print $2}')
  GEO_RC=$(hdfs dfs -ls /${GEO_DIR} | grep ${TEST_FILE} | awk -F ' ' '{print $2}')
  if [[ ($CARS_RC == "$RF" && $GEO_RC == "$RF") ]]; then
    echo "Replication is set correctly."
  else
    echo "Replication is not set correctly ($CARS_RC instead of $RF)."
  fi
}

removeTestFiles() {
  echo "Removing test files from HDFS."
  hdfs dfs -rm -r /${CARS_DIR}/${TEST_FILE}
  hdfs dfs -rm -r /${GEO_DIR}/${TEST_FILE}
}

checkEmptyDirectoriesExist
downloadTestFile
putToHDFS
verifyPut
verifyReplication
#removeTestFiles
