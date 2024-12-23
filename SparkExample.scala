import org.apache.spark.sql.SparkSession
import org.apache.spark.sql.functions._
import org.apache.spark.sql.expressions.Window

object SparkExample {
  def main(args: Array[String]): Unit = {
    val startTime = System.currentTimeMillis()

    val spark = SparkSession.builder()
      .appName("Spark vs PySpark Comparison with Event Type Mapping")
      .master("local[4]")
      .getOrCreate()

    spark.sparkContext.setLogLevel("ERROR")

    val data = spark.read.option("header", "true").csv("spark_vs_pyspark_comparison_data_large.csv")
    val eventTypeMapping = spark.read.option("header", "true").csv("event_type_mapping.csv")

    val dataWithTimestamp = data.withColumn("Timestamp", to_timestamp(col("Timestamp"), "yyyy-MM-dd HH:mm:ss.SSSSSS"))

    val joinedData = dataWithTimestamp.join(eventTypeMapping, "Event Type")

    val aggData = joinedData.groupBy("Event Type", "Description", "Priority")
      .agg(
        count("ID").alias("Event Count"),
        sum("Value").alias("Total Value"),
        avg("Value").alias("Avg Value")
      )

    val filteredData = joinedData.filter(col("Event Type").isin("click", "purchase"))

    println("Aggregated Data by Event Type:")
    aggData.show()
    println("Filtered Data for click and purchase events:")
    filteredData.show()

    spark.stop()

    val endTime = System.currentTimeMillis()
    val elapsedTime = (endTime - startTime) / 1000.0

    println(f"Time taken to run Spark with Scala program: $elapsedTime%.2f seconds")
  }
}
