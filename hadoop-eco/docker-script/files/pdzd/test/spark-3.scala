import org.apache.spark.sql.functions.col
import org.apache.spark.sql.DataFrame
import org.apache.hadoop.fs._

def operation_3a(df: DataFrame): DataFrame = {
        val df_selected = df.select(col("firstSeen"),col("lastSeen"),col("modelName"), col("vf_ModelYear")).withColumn("dateDiff",datediff(col("lastSeen"), col("firstSeen")))

        val df_grouped = df_selected.groupBy("modelName", "vf_ModelYear").avg("dateDiff")

        df_selected.join(df_grouped,Seq("modelName", "vf_ModelYear"),"left_outer").select(col("firstSeen"),col("lastSeen"),col("modelName"),col("vf_ModelYear"),col("avg(dateDiff)").alias("averageModelYearSaleTime"))
}

def operation_3b(df: DataFrame): DataFrame = {
        val df_with_diff = df.withColumn("dateDiff",datediff(col("lastSeen"), col("firstSeen"))).withColumn("diff", col("averageModelYearSaleTime") - col("dateDiff"))
        df_with_diff.withColumn("modelYearDemandClass",when($"diff" === 0, "medium")
        .otherwise(when($"diff" > 0, when($"diff" > 50, "very_high").otherwise("high"))
        .otherwise(when($"diff" < -50, "very_low").otherwise("low"))))
        .select(col("firstSeen"),col("lastSeen"),col("modelName"),col("vf_modelYear"),col("modelYearDemandClass"))
}

val df = spark.read.option("header",true).csv("hdfs://master:9000/cars/cars.csv")

val df_1 = operation_3a(df)
val df_2 = operation_3b(df_1)

df_2.coalesce(1).write.mode("overwrite").option("header","true").csv("hdfs://master:9000/tmps/tmp_3.csv")

val fs = FileSystem.get(sc.hadoopConfiguration)
val file = fs.globStatus(new Path("hdfs://master:9000/tmps/tmp_3.csv/part*"))(0).getPath().getName()
fs.rename(new Path("hdfs://master:9000/tmps/tmp3.csv/" + file), new Path("hdfs://master:9000/tmps/tmp_3.csv"))
fs.delete(new Path("hdfs://master:9000/tmps/tmp3/"), true)

