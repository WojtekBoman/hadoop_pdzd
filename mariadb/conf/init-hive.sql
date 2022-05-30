create database hive;
create user hive@'%' identified by 'hive';
grant all privileges on hive.* to hive@'%';

CREATE DATABASE trg;
CREATE TABLE trg.mileage_groups (brandName varchar(255), lastSeen DATE, mileage int, mileageGroup smallint);
