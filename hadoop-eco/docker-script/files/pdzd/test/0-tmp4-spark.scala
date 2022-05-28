import org.apache.spark.sql.functions.col
import org.apache.spark.sql.catalyst.plans._
import org.apache.hadoop.fs._

val cars = spark.read.option("header",true).csv("hdfs://master:9000/cars/test_cars.csv")
val geo = spark.read.option("header",true).csv("hdfs://master:9000/geo/geo.csv")
val joined = cars.join(geo, cars("vf_PlantCountry")===geo("name"),"inner")
joined.write.format("csv").save("hdfs://master:9000/tmps/tmp4")

val fs = FileSystem.get(sc.hadoopConfiguration)
val file = fs.globStatus(new Path("hdfs://master:9000/tmps/tmp4/part*"))(0).getPath().getName()
fs.rename(new Path("hdfs://master:9000/tmps/tmp4/" + file), new Path("hdfs://master:9000/tmps/tmp4.csv"))
fs.delete(new Path("hdfs://master:9000/tmps/tmp4"), true)
