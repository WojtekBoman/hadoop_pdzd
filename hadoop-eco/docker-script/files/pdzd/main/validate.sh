#!/bin/bash

validateCsvFiles() {
   echo  "Validating downloaded csv files in "$1" directory."

   for file in $1/*;do
	if [ "${file: -4}" != ".csv" ];then
		echo  "Found file with invalid extension "$file
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
		echo "Invalid car csv"
		return 1
	fi
   done

   return 0
}

uploadFilesToHdfs(){
	echo "Upload"
}

CARS_DIR="/tmp/pdzd/cars"
GEO_DIR="/tmp/pdzd/geo"

if validateCsvFiles $CARS_DIR && validateCsvFiles $GEO_DIR; then
   if validateCarsFiles; then
	uploadFilesToHdfs
   fi
else echo "Invalid"
fi
