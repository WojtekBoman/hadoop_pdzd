import org.apache.hadoop.fs._

// args(0) = /cars/cars.csv
// args(1) = /cars/tmp
// args(2) = /tmps/cars_src.csv
// args(3) = /cars/tmp1_tmp
// args(4) = /tmps/tmp1_src.csv
// args(5) = /cars/tmp2_tmp
// args(6) = /tmps/tmp2_src.csv
// args(7) = /cars/tmp3_tmp
// args(8) = /tmps/tmp3_src.csv
// args(9) = /cars/tmp4_tmp
// args(10) = /tmps/tmp4_src.csv
val args = sc.getConf.get("spark.driver.args").split("\\s+")
val fs = FileSystem.get(sc.hadoopConfiguration)


// cars_src
fs.delete(new Path("hdfs://master:9000" + args(1)), true)
fs.delete(new Path("hdfs://master:9000" + args(2)), true)

val cars = spark.read.option("header",true).csv("hdfs://master:9000" + args(0))
cars.select(col("vin"), col("stockNum"), col("firstSeen"), col("lastSeen"), col("msrp"), col("askPrice"), col("mileage"),
  col("isNew"), col("brandName"), col("modelName"), col("vf_BasePrice"), col("vf_BodyClass"), col("vf_FuelTypePrimary"),
  col("vf_ModelYear"), col("vf_PlantCountry"), col("vf_EngineModel"), col("vf_TransmissionStyle") ).distinct().write.option("header",true).option("emptyValue",null).csv("hdfs://master:9000/" + args(1))

//val file = fs.globStatus(new Path("hdfs://master:9000" + args(1) + "/part*"))(0).getPath().getName()
//fs.rename(new Path("hdfs://master:9000" + args(1) + "/" + file), new Path("hdfs://master:9000" + args(2)))
//fs.delete(new Path("hdfs://master:9000" + args(1)), true)

// tmp1_src

// tmp2_src
fs.delete(new Path("hdfs://master:9000" + args(5)), true)
fs.delete(new Path("hdfs://master:9000" + args(6)), true)

// no header for map-reduce
cars.select(col("mileage"),col("brandName"), substring(col("lastSeen"), 0, 4).as("year")).write.option("header",false).option("emptyValue",null).csv("hdfs://master:9000/" + args(5))

val file2 = fs.globStatus(new Path("hdfs://master:9000" + args(5) + "/part*"))(0).getPath().getName()
fs.rename(new Path("hdfs://master:9000" + args(5) + "/" + file2), new Path("hdfs://master:9000" + args(6)))
fs.delete(new Path("hdfs://master:9000" + args(5)), true)

// tmp3_src


// tmp4_src
