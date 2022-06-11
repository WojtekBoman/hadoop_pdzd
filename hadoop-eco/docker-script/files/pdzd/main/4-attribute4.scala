import org.apache.spark.sql.functions.col
import org.apache.spark.sql.catalyst.plans._
import org.apache.hadoop.fs._
import org.apache.spark.sql.functions.upper
import org.apache.spark.sql.functions.row_number
import org.apache.spark.sql.expressions.Window

val cars = spark.read.option("header",true).csv("hdfs://master:9000/cars/tmp")
val geo = spark.read.option("header",true).csv("hdfs://master:9000//tmps/geo_src.csv").withColumnRenamed("name","vf_PlantCountry").withColumn("vf_PlantCountry",upper(col("vf_PlantCountry"))).withColumn("vf_PlantCountry", regexp_replace(col("vf_PlantCountry"), "UNITED STATES", "UNITED STATES (USA)"))

val w = Window.partitionBy($"vf_PlantCountry").orderBy($"vf_PlantCountry")
val joined =  cars.join(geo, Seq("vf_PlantCountry"),"left_outer").select("vf_PlantCountry","region","sub-region").withColumn("row", row_number.over(w)).where($"row" === 1).drop("row")
joined.repartition(1).write.option("header",true).csv("hdfs://master:9000/tmps/tmp4")

//val fs = FileSystem.get(sc.hadoopConfiguration)
//val file = fs.globStatus(new Path("hdfs://master:9000/tmps/tmp4/part*"))(0).getPath().getName()
//fs.rename(new Path("hdfs://master:9000/tmps/tmp4/" + file), new Path("hdfs://master:9000/tmps/tmp4.csv"))
//fs.delete(new Path("hdfs://master:9000/tmps/tmp4"), true)

System.exit(0)
