SET mapred.input.dir.recursive=true;
DROP TABLE IF EXISTS trg.cars;
CREATE TABLE trg.cars
(
    vin                STRING,
    stockNum           STRING,
    firstSeen          DATE,
    lastSeen           DATE,
    msrp               int,
    askPrice           int,
    mileage            int,
    isNew              boolean,
    brandName          STRING,
    modelName          STRING,
    vf_BasePrice       int,
    vf_BodyClass       STRING,
    vf_FuelTypePrimary STRING,
    vf_ModelYear       int,
    vf_PlantCountry    STRING,
    vf_EngineModel     STRING,
    constraint cars_pk
        primary key (vin) disable novalidate
) ROW FORMAT DELIMITED FIELDS TERMINATED BY ','
    TBLPROPERTIES ("skip.header.line.count" = "1");

LOAD
    DATA INPATH '/cars/tmp/*.csv' INTO TABLE trg.cars;

-- SELECT count(*) FROM trg.cars;
