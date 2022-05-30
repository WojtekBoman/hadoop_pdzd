DROP TABLE IF EXISTS trg.trg;

-- CREATE TABLE trg.trg AS SELECT * FROM cars where dob_year=1990

CREATE TABLE trg.trg
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
-- tmp1
-- tmp2
    mileageGroup smallint,
-- tmp3
-- tmp4
    constraint cars_pk
        primary key (vin) disable novalidate
) ROW FORMAT DELIMITED FIELDS TERMINATED BY ','
    TBLPROPERTIES ("skip.header.line.count" = "1");

--
-- INSERT INTO TABLE trg.trg
-- SELECT * FROM cars;