#!/usr/bin/env bash

CARS_DIR=cars
GEO_DIR=geo
TMPS_DIR=tmps

checkDirectoriesExist() {
  echo "Looking for existing directories."
  CARS_C=$(hdfs dfs -ls / | grep cars | wc -l)
  GEO_C=$(hdfs dfs -ls / | grep geo | wc -l)
  TMPS_C=$(hdfs dfs -ls / | grep geo | wc -l)

  if [[ ($CARS_C == 1 || $GEO_C == 1 || $TMPS_C == 1) ]]; then
    read -p "Would you like to re-create required directories? (y/N) " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
      if [[ $CARS_C == 1 ]]; then
        cleanCars
      fi
      if [[ $GEO_C == 1 ]]; then
        cleanGeo
      fi
      if [[ $TMPS_C == 1 ]]; then
        cleanTmps
      fi
    else
      echo "Exiting."
      exit 0
    fi
  fi
}

setFtpCrontab() {
  echo "0 * * * * /pdzd/main/download_files.sh" | tee -a /var/spool/cron/root
}

createCars() {
  echo "Creating cars directory."
  hdfs dfs -mkdir -p /${CARS_DIR}
}

createGeo() {
  echo "Creating geo directory."
  hdfs dfs -mkdir -p /${GEO_DIR}
}

createTmps() {
  echo "Creating tmps directory."
  hdfs dfs -mkdir -p /${TMPS_DIR}
}

cleanCars() {
  echo "Removing cars directory."
  hdfs dfs -rm -r /${CARS_DIR}
}

cleanGeo() {
  echo "Removing geo directory."
  hdfs dfs -rm -r /${GEO_DIR}
}

cleanTmps() {
  echo "Removing tmps directory."
  hdfs dfs -rm -r /${TMPS_DIR}
}

checkDirectoriesExist
createCars
createGeo
createTmps
#setFtpCrontab
