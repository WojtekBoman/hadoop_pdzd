import org.apache.spark.sql.functions.col
import org.apache.spark.sql.DataFrame
import org.apache.hadoop.fs._

def operation_3b(df: DataFrame): DataFrame = {
        val df_with_diff = df.withColumn("dateDiff",datediff(col("lastSeen"), col("firstSeen"))).withColumn("diff", col("averageModelYearSaleTime") - col("dateDiff"))
        df_with_diff.withColumn("modelYearDemandClass",when($"diff" === 0, "medium")
	.otherwise(when($"diff" > 0, when($"diff" > 50, "very_high").otherwise("high"))
	.otherwise(when($"diff" < -50, "very_low").otherwise("low"))))
	.select(col("firstSeen"),col("lastSeen"),col("modelName"),col("vf_modelYear"),col("modelYearDemandClass"))
}

val columns = Seq("firstSeen","lastSeen","modelName","vf_ModelYear", "averageModelYearSaleTime")
val data = Seq(
("2018-01-01","2019-01-01","Golf","2016", 100), 
("2018-01-01","2018-05-01","Golf","2016", 100),
("2018-01-01","2018-04-11","Golf","2016", 100),
("2018-01-01","2018-03-01","Golf","2016", 100),
("2018-01-01","2018-01-01","Golf","2016", 100),
)

val rdd = spark.sparkContext.parallelize(data)
val df_to_test = spark.createDataFrame(rdd).toDF(columns:_*)

val df_test = operation_3b(df_to_test)

df_test.show()

val test_very_low_count = df_test.filter(df_test("modelYearDemandClass") === "very_low").count() 

val test_low_count = df_test.filter(df_test("modelYearDemandClass") === "low").count()

val test_medium_count = df_test.filter(df_test("modelYearDemandClass") === "medium").count()

val test_high_count = df_test.filter(df_test("modelYearDemandClass") === "high").count()

val test_very_high_count = df_test.filter(df_test("modelYearDemandClass") === "very_high").count()

assert(test_very_low_count == 1)
assert(test_low_count == 1)
assert(test_medium_count == 1)
assert(test_high_count == 1)
assert(test_very_high_count == 1)
