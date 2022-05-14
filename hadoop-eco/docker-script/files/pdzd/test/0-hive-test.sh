#!/usr/bin/env bash

beeline -u 'jdbc:hive2://master:10000 hive org.apache.hive.jdbc.HiveDriver' -f /pdzd/test/0-hive-test.sql
