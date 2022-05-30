import org.apache.hadoop.fs._
import org.apache.spark.sql.SaveMode

// args(0) = /tmps/cars_src.csv
// args(1) = /tmps/tmp2_done/part-r-00000
// args(2) = /tmps/tmp2.csv
val args = sc.getConf.get("spark.driver.args").split("\\s+")

val df = spark.read.option("header",true).csv("hdfs://master:9000" + args(0)).withColumn("year", substring(col("lastSeen"), 0, 4))
val mr = spark.read.option("header",false).csv("hdfs://master:9000" + args(1)).toDF("brand","year","maxMileage")
val cars = df.select(col("mileage"),col("brandName"),col("lastSeen"), col("year"))
val joined = cars.join(mr, cars("brandName")===mr("brand") && cars("year")===mr("year"), "inner").withColumn("mileagePercentage", col("mileage")/col("maxMileage"))
val out = joined.withColumn("mileageGroup", when(col("mileagePercentage")<=0.5, 1).when(col("mileagePercentage")<=0.8, 2).when(col("mileagePercentage")<=0.95,3).when(col("mileagePercentage")>0.95, 4).otherwise(0)).select(col("brandName"),col("lastSeen"),col("mileage"),col("mileageGroup"))
out.write.option("header",true).option("emptyValue",null).csv("hdfs://master:9000/tmps/tmp2_out")

val fs = FileSystem.get(sc.hadoopConfiguration)
val file = fs.globStatus(new Path("hdfs://master:9000/tmps/tmp2_out/part*"))(0).getPath().getName()
fs.rename(new Path("hdfs://master:9000/tmps/tmp2_out/" + file), new Path("hdfs://master:9000" + args(2)))

out.write
  .format("jdbc")
  .option("url","jdbc:mysql://mariadb:3306/trg?useSSL=false&characterEncoding=UTF-8")
  .option("dbtable","mileage_groups")
  .option("user","root")
  .option("password","mariadb")
  .mode(SaveMode.Overwrite)
  .save()

fs.delete(new Path("hdfs://master:9000/tmps/tmp2_tmp"), true)
fs.delete(new Path("hdfs://master:9000/tmps/tmp2_done"), true)
fs.delete(new Path("hdfs://master:9000/tmps/tmp2_out"), true)

//fs.delete(new Path("hdfs://master:9000/tmps/tmp2_src.csv"), true)
