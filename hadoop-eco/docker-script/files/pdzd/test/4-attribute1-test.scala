val cars = spark.read.option("header",true).csv("hdfs://master:9000/test_data/cars_10.csv").select("msrp","askPrice")
val carsWithPriceDiff = cars.withColumn("priceDiffPerc",(col("msrp")-col("askPrice"))/col("msrp")*100).select("msrp","askPrice","priceDiffPerc")

val expectedResult = spark.read.option("header",true).csv("hdfs://master:9000/test_data/expected_result_1.csv")
val diff = expectedResult.except(carsWithPriceDiff).count!=0
if(diff) println("tmp1 test: FAILED") else println("tmp1 test: SUCCESS")

