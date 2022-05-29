import org.apache.spark.sql.functions.col
import org.apache.spark.sql.DataFrame
import spark.implicits._
import org.scalatest.Assertions._

def operation_3a(df: DataFrame): DataFrame = {
        val df_selected = df.select(col("firstSeen"),col("lastSeen"),col("modelName"), col("vf_ModelYear")).withColumn("dateDiff",datediff(col("lastSeen"), col("firstSeen")))

        val df_grouped = df_selected.groupBy("modelName", "vf_ModelYear").avg("dateDiff")

        df_selected.join(df_grouped,Seq("modelName", "vf_ModelYear"),"left_outer").select(col("firstSeen"),col("lastSeen"),col("modelName"),col("vf_ModelYear"),col("avg(dateDiff)").alias("averageModelYearSaleTime"))
}

val columns = Seq("firstSeen","lastSeen","modelName","vf_ModelYear")
val data = Seq(
("2018-01-01","2018-01-05","Golf","2016"), ("2018-01-01","2018-01-08","Golf","2016"),
("2018-05-01","2018-05-03","Golf","2014"), ("2018-05-01","2018-05-09","Golf","2014"),
("2018-07-01","2018-07-07","Civic","2014"), ("2018-07-01","2018-07-11","Civic","2014")
)

val rdd = spark.sparkContext.parallelize(data)
val df_to_test = spark.createDataFrame(rdd).toDF(columns:_*)
df_to_test.show()
val df_test = operation_3a(df_to_test)
df_test.show()

val size_1 = df_test.filter(df_test("modelName") === "Golf" && df_test("vf_ModelYear") === "2016" && df_test("averageModelYearSaleTime") === 5.5).count()

val size_2 = df_test.filter(df_test("modelName") === "Golf" && df_test("vf_ModelYear") === "2014" && df_test("averageModelYearSaleTime") === 5.0).count()

val size_3 = df_test.filter(df_test("modelName") === "Civic" && df_test("vf_ModelYear") === "2014" && df_test("averageModelYearSaleTime") === 8.0).count()

assert(size_1 == 2)
assert(size_2 == 2)
assert(size_3 == 2)
