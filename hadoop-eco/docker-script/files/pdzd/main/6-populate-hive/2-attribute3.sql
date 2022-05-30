DROP TABLE IF EXISTS trg.model_year_demand_classes;

CREATE TABLE trg.model_year_demand_classes
(
    firstSeen            DATE,
    lastSeen             DATE,
    modelName            STRING,
    vf_modelYear         int,
    modelYearDemandClass STRING
)
ROW FORMAT DELIMITED FIELDS TERMINATED BY ','
    TBLPROPERTIES ("skip.header.line.count" = "1");

LOAD DATA INPATH '/tmps/hive_tmp3.csv' INTO TABLE trg.model_year_demand_classes;
