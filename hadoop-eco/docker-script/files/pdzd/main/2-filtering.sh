#!/usr/bin/env bash

sourcesFromCars() {
  echo "Creating sources from cars data."
  spark-shell --conf spark.driver.args="/cars/2022_05.csv /cars/tmp /tmps/cars_src.csv /cars/tmp1_tmp /tmps/tmp1_src.csv /cars/tmp2_tmp /tmps/tmp2_src.csv /cars/tmp3_tmp /tmps/tmp3_src.csv /cars/tmp4_tmp /tmps/tmp4_src.csv" < /pdzd/main/2-filtering/filtering_cars.scala
}

sourcesFromGeo() {
  echo "Creating sources from geo data."
  spark-shell --conf spark.driver.args="/geo/geo.csv /geo/tmp /tmps/geo_src.csv" < /pdzd/main/2-filtering/filtering_geo.scala
}

sourcesFromCars
sourcesFromGeo
