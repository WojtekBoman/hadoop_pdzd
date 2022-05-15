#!/bin/bash

CARS_DIR=/tmp/pdzd/cars
GEO_DIR=/tmp/pdzd/geo
 
validateCsvFiles() {
   echo  "Validating downloaded csv files in "$1" directory."

   for file in $1/*;do
	result=$(python3 validate_csv.py $file)
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
	result=$(python3 validate_cars.py $file)
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
	$(hdfs dfs -put $file /cars/)
    done 
}

uploadingGeoFilesToHdfs(){
   echo "Creating geo directory"
   $(hdfs dfs -mkdir -p /geo/)
   echo "Uploading geo files"
   for file in $GEO_DIR/*;do
       $(hdfs dfs -put $file /geo/)
   done
}

 
if validateCsvFiles $CARS_DIR && validateCsvFiles $GEO_DIR; then
   if validateCarsFiles && validateFreeSpace; then
	uploadCarsFilesToHdfs
        uploadGeoFilesToHdfs
   fi
else echo "Error with uploading data to hdfs"
fi
