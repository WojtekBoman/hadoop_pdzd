DROP TABLE IF EXISTS trg.trg2;

SET mapred.input.dir.recursive=true;
DROP TABLE IF EXISTS trg.trg2;
CREATE TABLE trg.trg2
(
    vin                  STRING,
    stockNum             STRING,
    firstSeen            DATE,
    lastSeen             DATE,
    msrp                 int,
    askPrice             int,
    mileage              int,
    isNew                boolean,
    brandName            STRING,
    modelName            STRING,
    vf_BasePrice         int,
    vf_BodyClass         STRING,
    vf_FuelTypePrimary   STRING,
    vf_ModelYear         int,
    vf_PlantCountry      STRING,
    vf_EngineModel       STRING,
    vf_TransmissionStyle STRING,
    region               STRING,
    `sub-region`         STRING,
    mileageGroup         smallint,
    modelYearDemandClass STRING,
    priceDiffPerc        double,
    constraint trg2_pk
        primary key (vin) disable novalidate
) ROW FORMAT DELIMITED FIELDS TERMINATED BY ','
    TBLPROPERTIES ("skip.header.line.count" = "1");

LOAD
DATA INPATH '/tmps/trg/*.csv' INTO TABLE trg.trg2;

-- SELECT count(*) FROM trg.trg2;
