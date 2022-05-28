import org.apache.spark.sql.functions.col

val df = spark.read.option("header",true).csv("hdfs://master:9000/cars/test_cars.csv")

df.coalesce(1).write.mode("overwrite").option("header", "true").csv("hdfs://master:9000/cars/test_cars_3.csv")

df.select(col("firstSeen"),col("lastSeen")).show()

val df2 = df.withColumn("dateDiff",datediff(col("lastSeen"), col("firstSeen"))).groupBy("brandName", "modelName", "vf_ModelYear").avg("dateDiff")

df2.coalesce(1).write.mode("overwrite").option("header", "true").csv("hdfs://master:9000/cars/test_cars_2.csv")
