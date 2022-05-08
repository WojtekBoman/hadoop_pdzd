#!/usr/bin/env bash

RF=$1
CARS_DIR=$2
GEO_DIR=$3

checkDirectoryExists() {
  echo "Looking for existing directories."
  if [[ $(hdfs dfs -ls / | grep cars | wc -l) == 1 || $(hdfs dfs -ls / | grep geo | wc -l) == 1 ]]; then
    cleanDirectories
  fi
}

createCarsWithReplication() {
  echo "Creating cars directory with ${RF} replicas."
  hdfs dfs -mkdir -p /${CARS_DIR}
  hdfs dfs -setrep -w ${RF} /${CARS_DIR}
}

createGeoWithReplication() {
  echo "Creating geo directory with ${RF} replicas."
  hdfs dfs -mkdir -p /${GEO_DIR}
  hdfs dfs -setrep -w ${RF} /${GEO_DIR}
}

cleanDirectories() {
  read -p "Would you like to re-create required directories? (y/N) " -n 1 -r
  if [[ $REPLY =~ ^[Yy]$ ]]; then
    if [[ $(hdfs dfs -ls / | grep ${CARS_DIR} | wc -l) == 1 ]]; then
      echo "Removing cars directory."
      hdfs dfs -rm -r /${CARS_DIR}
    fi

    if [[ $(hdfs dfs -ls / | grep ${GEO_DIR} | wc -l) == 1 ]]; then
      echo "Removing geo directory."
      hdfs dfs -rm -r /${GEO_DIR}
    fi
    echo "Removing existing directories."
  else
    echo "Exiting."
    exit 0
  fi
}

checkDirectoryExists
createCarsWithReplication
createGeoWithReplication
