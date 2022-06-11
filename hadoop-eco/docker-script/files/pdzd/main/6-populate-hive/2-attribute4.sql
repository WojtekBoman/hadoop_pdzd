DROP TABLE IF EXISTS trg.country_regions;

CREATE TABLE trg.country_regions
(
    vf_PlantCountry STRING,
    region          STRING,
    `sub-region`    STRING
)
ROW FORMAT DELIMITED FIELDS TERMINATED BY ','
    TBLPROPERTIES ("skip.header.line.count" = "1");

LOAD DATA INPATH '/tmps/tmp4/*.csv' INTO TABLE trg.country_regions;
