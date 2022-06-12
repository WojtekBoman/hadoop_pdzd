import org.apache.hadoop.fs._

val fs = FileSystem.get(sc.hadoopConfiguration)
fs.delete(new Path("hdfs://master:9000/tmps/trg"), true)

val cars = spark.read.option("header",true).csv("hdfs://master:9000/cars/tmp/")
var tmp1 = spark.read.option("header",true).csv("hdfs://master:9000/tmps/tmp1/").toDF("msrp1","askPrice1","priceDiffPerc")
val tmp2 = spark.read.option("header",true).csv("hdfs://master:9000/tmps/tmp2_out/").toDF("brandName2","lastSeen2","mileage2","mileageGroup")
val tmp3 = spark.read.option("header",true).csv("hdfs://master:9000/tmps/tmp3/").toDF("firstSeen3","lastSeen3","modelName3","vf_modelYear3","modelYearDemandClass")
val tmp4 = spark.read.option("header",true).csv("hdfs://master:9000/tmps/tmp4/").toDF("vf_PlantCountry4","region","sub-region")

// join

cars.join(tmp1, cars("msrp") === tmp1("msrp1") && cars("askPrice") === tmp1("askPrice1"), "left" ).join(tmp2, cars("brandName") === tmp2("brandName2") && cars("lastSeen") === tmp2("lastSeen2") && cars("mileage") === tmp2("mileage2"), "left" ).join(tmp3, cars("firstSeen") === tmp3("firstSeen3") && cars("lastSeen") === tmp3("lastSeen3") && cars("modelName") === tmp3("modelName3") && cars("vf_ModelYear") === tmp3("vf_ModelYear3"), "left" ).join(tmp4, cars("vf_PlantCountry") === tmp4("vf_PlantCountry4"), "left" ).drop("msrp1","askPrice1","brandName2","lastSeen2","mileage2","firstSeen3","lastSeen3","modelName3","vf_modelYear3","vf_PlantCountry4").write.option("header",true).option("emptyValue",null).csv("hdfs://master:9000/tmps/trg")
