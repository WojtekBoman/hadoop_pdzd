// init source - duplicate of 2-fitlering, can be used for testing

val df = spark.read.option("header",true).csv("hdfs://master:9000/cars/test_cars.csv")
df.select(col("mileage"),col("brandName"), substring(col("lastSeen"), 0, 4).as("year")).write.csv("hdfs://master:9000/tmps/tmp2_tmp")