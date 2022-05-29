import org.apache.spark.sql.functions.col
import org.apache.spark.sql.catalyst.plans._
import org.apache.hadoop.fs._
import org.apache.spark.sql.functions.upper

val cars = spark.read.option("header",true).csv("hdfs://master:9000/tmps/cars_src.csv")
val geo = spark.read.option("header",true).csv("hdfs://master:9000//tmps/geo_src.csv")
.withColumnRenamed("name", "vf_PlantCountry")
.withColumn("vf_PlantCountry",upper(col("vf_PlantCountry")))
.withColumn("vf_PlantCountry", regexp_replace(col("vf_PlantCountry"), "UNITED STATES", "UNITED STATES (USA)"))

val joined = cars.join(geo, Seq("vf_PlantCountry"),"left_outer")
joined.write.format("csv").save("hdfs://master:9000/tmps/tmp4")

val fs = FileSystem.get(sc.hadoopConfiguration)
val file = fs.globStatus(new Path("hdfs://master:9000/tmps/tmp4/part*"))(0).getPath().getName()
fs.rename(new Path("hdfs://master:9000/tmps/tmp4/" + file), new Path("hdfs://master:9000/tmps/tmp4.csv"))
fs.delete(new Path("hdfs://master:9000/tmps/tmp4"), true)

System.exit(0)
