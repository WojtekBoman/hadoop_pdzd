#!/usr/bin/env bash

RF=$1
CARS_DIR=cars
GEO_DIR=geo

checkDirectoryExists() {
  echo "Looking for existing directories."
  CARS_C=$(hdfs dfs -ls / | grep cars | wc -l)
  GEO_C=$(hdfs dfs -ls / | grep geo | wc -l)

  if [[ ($CARS_C == 1 || $GEO_C == 1) ]]; then
    read -p "Would you like to re-create required directories? (y/N) " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
      if [[ $CARS_C == 1 ]]; then
        cleanCars
      fi
      if [[ $GEO_C == 1 ]]; then
        cleanGeo
      fi
    else
      echo "Exiting."
      exit 0
    fi
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

cleanCars() {
  echo "Removing cars directory."
  hdfs dfs -rm -r /${CARS_DIR}
}

cleanGeo() {
  echo "Removing geo directory."
  hdfs dfs -rm -r /${GEO_DIR}
}
checkDirectoryExists
createCarsWithReplication
createGeoWithReplication
