DROP TABLE IF EXISTS trg.trg;

-- CREATE TABLE trg.trg AS SELECT * FROM cars where dob_year=1990
--
-- CREATE TABLE trg.trg
-- (
--     vin                STRING,
--     stockNum           STRING,
--     firstSeen          DATE,
--     lastSeen           DATE,
--     msrp               int,
--     askPrice           int,
--     mileage            int,
--     isNew              boolean,
--     brandName          STRING,
--     modelName          STRING,
--     vf_BasePrice       int,
--     vf_BodyClass       STRING,
--     vf_FuelTypePrimary STRING,
--     vf_ModelYear       int,
--     vf_PlantCountry    STRING,
--     vf_EngineModel     STRING,
-- -- tmp1
-- -- tmp2
--     mileageGroup smallint,
-- -- tmp3
-- -- tmp4
--     constraint cars_pk
--         primary key (vin) disable novalidate
-- ) ROW FORMAT DELIMITED FIELDS TERMINATED BY ','
--     TBLPROPERTIES ("skip.header.line.count" = "1");

-- INSERT INTO TABLE trg.trg
CREATE TABLE trg.trg AS
SELECT c.*, cr.region, cr.`sub-region`, mg.mileagegroup, mydc.modelyeardemandclass, pd.pricediffperc
FROM trg.cars c LEFT JOIN trg.price_diffs pd ON pd.msrp=c.msrp AND pd.askPrice=c.askPrice
LEFT JOIN trg.mileage_groups mg ON mg.lastSeen=c.lastSeen AND mg.mileage=c.mileage AND mg.brandName=c.brandName
LEFT JOIN trg.model_year_demand_classes mydc ON mydc.firstSeen=c.firstSeen AND mydc.lastSeen=c.lastSeen AND mydc.modelName=c.modelName AND mydc.vf_ModelYear=c.vf_ModelYear
LEFT JOIN trg.country_regions cr ON cr.vf_PlantCountry=c.vf_PlantCountry LIMIT 10;
