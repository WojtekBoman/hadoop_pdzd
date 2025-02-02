import org.apache.spark.sql.functions.col
import org.apache.hadoop.fs._

val cars = spark.read.option("header",true).csv("hdfs://master:9000/cars/tmp").select("msrp","askPrice")
val carsWithPriceDiff = cars.withColumn("priceDiffPerc",(col("msrp")-col("askPrice"))/col("msrp")*100).select("msrp","askPrice","priceDiffPerc")
carsWithPriceDiff.distinct().write.option("header",true).csv("hdfs://master:9000/tmps/tmp1")

//val fs = FileSystem.get(sc.hadoopConfiguration)
//val file = fs.globStatus(new Path("hdfs://master:9000/tmps/tmp1/part*"))(0).getPath().getName()
//fs.rename(new Path("hdfs://master:9000/tmps/tmp1/" + file), new Path("hdfs://master:9000/tmps/tmp1.csv"))
//fs.delete(new Path("hdfs://master:9000/tmps/tmp1"), true)
System.exit(0)
