from pyspark.sql import SparkSession
from pyspark.sql.functions import col, avg, sum, count, to_timestamp
import time

def main():
    start_time = time.time()
    spark = SparkSession.builder \
        .appName("Spark vs PySpark Comparison with Event Type Mapping") \
        .master("local[4]") \
        .getOrCreate()

    spark.sparkContext.setLogLevel("ERROR")

    data = spark.read.option("header", "true").csv("spark_vs_pyspark_comparison_data_large.csv")
    event_type_mapping = spark.read.option("header", "true").csv("event_type_mapping.csv")

    data = data.withColumn("Timestamp", to_timestamp(col("Timestamp"), "yyyy-MM-dd HH:mm:ss.SSSSSS"))

    joined_data = data.join(event_type_mapping, on="Event Type", how="left")

    agg_data = joined_data.groupBy("Event Type", "Description", "Priority") \
                          .agg(
                              count("ID").alias("Event Count"),
                              sum("Value").alias("Total Value"),
                              avg("Value").alias("Avg Value")
                          )

    filtered_data = joined_data.filter(col("Event Type").isin("click", "purchase"))

    print("Aggregated Data by Event Type:")
    agg_data.show()
    print("Filtered Data for click and purchase events:")
    filtered_data.show()

    spark.stop()

    end_time = time.time()
    elapsed_time = end_time - start_time
    print(f"Time taken to run PySpark program: {elapsed_time:.2f} seconds")

if __name__ == "__main__":
    main()
