import org.apache.hadoop.fs._

val df = spark.read.option("header",true).csv("hdfs://master:9000/tmps/cars_src.csv").withColumn("year", substring(col("lastSeen"), 0, 4))
val mr = spark.read.option("header",false).csv("/tmps/tmp2_done/part-r-00000").toDF("brand","year","maxMileage")
val cars = df.select(col("mileage"),col("brandName"),col("lastSeen"), col("year"))
val joined = cars.join(mr, cars("brandName")===mr("brand") && cars("year")===mr("year"), "inner").withColumn("mileagePercentage", col("mileage")/col("maxMileage"))
val out = joined.withColumn("mileageGroup", when(col("mileagePercentage")<=0.5, 1).when(col("mileagePercentage")<=0.8, 2).when(col("mileagePercentage")<=0.95,3).when(col("mileagePercentage")>0.95, 4).otherwise(0)).select(col("brandName"),col("lastSeen"),col("mileage"),col("mileageGroup"))
out.write.option("header",true).csv("hdfs://master:9000/tmps/tmp2_out")

val fs = FileSystem.get(sc.hadoopConfiguration)
val file = fs.globStatus(new Path("hdfs://master:9000/tmps/tmp2_out/part*"))(0).getPath().getName()
fs.rename(new Path("hdfs://master:9000/tmps/tmp2_out/" + file), new Path("hdfs://master:9000/tmps/tmp2.csv"))
fs.delete(new Path("hdfs://master:9000/tmps/tmp2_tmp"), true)
fs.delete(new Path("hdfs://master:9000/tmps/tmp2_done"), true)
fs.delete(new Path("hdfs://master:9000/tmps/tmp2_out"), true)
fs.delete(new Path("hdfs://master:9000/tmps/tmp2_src.csv"), true)
