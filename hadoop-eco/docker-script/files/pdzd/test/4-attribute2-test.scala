val result = spark.read.option("header",true).csv("hdfs://master:9000/pdzd/test/test_data/tmp2.csv")
result.show()
val expectedResult = spark.read.option("header",true).csv("hdfs://master:9000/pdzd/test/test_data/expected_result_2.csv")
expectedResult.show()
val diff = result.unionAll(expectedResult).except(result.intersect(expectedResult))
if(diff.count!=0) {
  println("tmp2 test: FAILED")
  diff.show()
} else {
  println("tmp2 test: SUCCESS")
}
