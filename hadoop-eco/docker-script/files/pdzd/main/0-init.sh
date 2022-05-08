#!/usr/bin/env bash

# check if folders exist
checkFolderExists() {
  if [[ $(hdfs dfs -ls / | grep cars | wc -l) == 1 || $(hdfs dfs -ls / | grep geo | wc -l) == 1 ]]
  then echo "exists"
  fi
}
checkFolderExists
# if exists ask to continue

# if continue removasdase all existing folders

# install directories and set replication factor
