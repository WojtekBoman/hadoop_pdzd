#!/usr/bin/env bash

mkdir -p /tmp/pdzd/logs
wget --no-passive -P /tmp/pdzd/cars ftp://ftp:ftp@ftpslave/cars/* 2>&1 | tee -a /tmp/pdzd/logs/cars.log
wget --no-passive -P /tmp/pdzd/geo ftp://ftp:ftp@ftpslave/geo/* 2>&1 | tee -a /tmp/pdzd/logs/geo.log


# validation
