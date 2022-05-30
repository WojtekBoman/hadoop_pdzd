DROP TABLE IF EXISTS trg.mileage_groups;

CREATE TABLE trg.mileage_groups
(
    brandName    STRING,
    lastSeen     DATE,
    mileage      int,
    mileageGroup smallint,
    constraint mileage_groups_pk
        primary key (brandName, lastseen, mileage) disable novalidate
)
ROW FORMAT DELIMITED FIELDS TERMINATED BY ','
    TBLPROPERTIES ("skip.header.line.count" = "1");

LOAD DATA INPATH '/tmps/hive_tmp3.csv' INTO TABLE trg.mileage_groups;
