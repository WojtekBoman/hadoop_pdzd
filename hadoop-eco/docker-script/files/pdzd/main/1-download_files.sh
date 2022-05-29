#!/usr/bin/env bash

mkdir -p /tmp/pdzd/logs
rm -f /tmp/pdzd/cars/*
rm -f /tmp/pdzd/geo/*

CAR_FILE=$(curl --list-only ftp://ftp:ftp@ftpslave/cars/ | sort | tail -n 1)
wget --no-passive -P /tmp/pdzd/cars ftp://ftp:ftp@ftpslave/cars/${CAR_FILE} 2>&1 | tee -a /tmp/pdzd/logs/cars.log
wget --no-passive -P /tmp/pdzd/geo ftp://ftp:ftp@ftpslave/geo/geo.csv 2>&1 | tee -a /tmp/pdzd/logs/geo.log

# validation
CARS_DIR=/tmp/pdzd/cars
GEO_DIR=/tmp/pdzd/geo

validateCsvFiles() {
   echo  "Validating downloaded csv files in "$1" directory."

   for file in $1/*;do
        result=$(python3 /pdzd/main/validate_csv.py $file)
        if [ "$result" != "0" ];then
                echo  "Found file with invalid format "$file
                return 1
        fi
   done

   return 0
}

validateCarsFiles() {
   echo "Validating cars files."

   for file in "/tmp/pdzd/cars"/*;do
        result=$(python3 /pdzd/main/validate_cars.py $file)
        if [ "$result" != "0" ];then
                echo "Invalid cars csv"
                return 1
        fi
   done

   return 0
}

validateFreeSpace() {
   echo "Validating free space on hdfs"

   dataSize=$(du -s "/tmp/pdzd" | awk '{print $1}')
   freeSpace=$(hdfs dfs -df | grep -vE '^Filesystem' | awk '{ print $4 }')
   if [ $dataSize -gt $freeSpace ]; then
       echo "Required space: "$dataSize", free space: "$freeSpace
       return 1
   fi

   return 0
}

uploadCarsFilesToHdfs(){
    echo "Creating cars directory"
    $(hdfs dfs -mkdir -p /cars/)
    echo "Uploading cars files"
    for file in $CARS_DIR/*;do
        $(hdfs dfs -put -f $file /cars/cars.csv)
    done
}

uploadGeoFilesToHdfs(){
   echo "Creating geo directory"
   $(hdfs dfs -mkdir -p /geo/)
   echo "Uploading geo files"
   for file in $GEO_DIR/*;do
       $(hdfs dfs -put -f $file /geo/geo.csv)
   done
}


if validateCsvFiles $CARS_DIR && validateCsvFiles $GEO_DIR; then
   if validateFreeSpace; then
        uploadCarsFilesToHdfs
        uploadGeoFilesToHdfs
   fi
else echo "Error with uploading data to hdfs"
fi
