DROP TABLE IF EXISTS trg.price_diffs;

CREATE TABLE trg.price_diffs
(
    msrp          int,
    askPrice      int,
    priceDiffPerc double
)
ROW FORMAT DELIMITED FIELDS TERMINATED BY ','
    TBLPROPERTIES ("skip.header.line.count" = "1");

LOAD DATA INPATH '/tmps/hive_tmp1.csv' INTO TABLE trg.price_diffs;

-- SELECT count(*) FROM trg.price_diffs;
