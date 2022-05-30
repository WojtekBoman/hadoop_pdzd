// args(0) = /pdzd/test/${TEST_DIR}/tmp2.csv
// args(1) = /pdzd/test/${TEST_DIR}/${EXPECTED_FILE}
val args = sc.getConf.get("spark.driver.args").split("\\s+")

val result = spark.read.option("header",true).csv("hdfs://master:9000"+args(0))
val expectedResult = spark.read.option("header",true).csv("hdfs://master:9000"+args(1))
val diff = result.except(expectedResult).count!=0
if(diff) println("tmp1 test: FAILED") else println("tmp1 test: SUCCESS")
