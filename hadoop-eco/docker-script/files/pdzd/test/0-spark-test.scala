var input = spark.read.textFile("hdfs://master:9000/cars/test_cars.csv")
// Count the number of non blank lines
input.filter(line => line.length()>0).count()
