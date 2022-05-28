val df = spark.read.option("header",true).csv("hdfs://master:9000/cars/test_cars.csv").withColumn("year", substring(col("lastSeen"), 0, 4))
val df2 = spark.read.option("header",false).csv("/tmps/tmp2_done/part-r-00000").toDF("brand","year","maxMileage")
val cars = df.select(col("mileage"),col("brandName"),col("lastSeen"), col("year"))
cars.join(df2, cars("brandName")===df2("brand") && cars("year")===df2("year"), "inner").show()
// with column "mileageGroup"
