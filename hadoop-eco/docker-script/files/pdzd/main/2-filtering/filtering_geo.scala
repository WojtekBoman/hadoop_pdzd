import org.apache.hadoop.fs._

// args(0) = /geo/geo.csv
// args(1) = /geo/tmp
// args(2) = /tmps/geo_src.csv
val args = sc.getConf.get("spark.driver.args").split("\\s+")
val fs = FileSystem.get(sc.hadoopConfiguration)

fs.delete(new Path("hdfs://master:9000" + args(1)), true)
fs.delete(new Path("hdfs://master:9000" + args(2)), true)

val geo = spark.read.option("header",true).csv("hdfs://master:9000" + args(0))
geo.select(col("name"), col("region"), col("sub-region")).write.option("header",true).csv("hdfs://master:9000/" + args(1))

val file = fs.globStatus(new Path("hdfs://master:9000" + args(1) + "/part*"))(0).getPath().getName()
fs.rename(new Path("hdfs://master:9000" + args(1) + "/" + file), new Path("hdfs://master:9000" + args(2)))
fs.delete(new Path("hdfs://master:9000" + args(1)), true)

