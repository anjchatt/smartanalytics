package org.apache.spark.mllib.api.python

import org.alitouka.spark.dbscan.spatial.Point
import org.alitouka.spark.dbscan.spatial.rdd.PartitioningSettings
import org.alitouka.spark.dbscan.{Dbscan, DbscanSettings}
import org.apache.spark.mllib.linalg.Vector
import org.apache.spark.sql.functions._
import org.apache.spark.sql.types.{IntegerType, LongType, StructField, StructType}
import org.apache.spark.sql.{Row, _}

class PythonDbscanAPI extends Serializable {

  def train(dataset: DataFrame, sourceColumn: String, targetColumn: String, epsilon: Int, numOfPoints: Int, pointsInBox: Int = 30000) = {
    val clusteringSettings = new DbscanSettings().withEpsilon(epsilon).withNumberOfPoints(numOfPoints)
    val partitioningSettings = new PartitioningSettings(numberOfPointsInBox = 30000)

    // current DBSCAN implementation don't respect "IDs" of any kind, so we'll merge results by hashcode
    val addHash = udf { c: Vector => new Point(c.toArray).hashCode }
    val df = dataset.withColumn("hash", addHash(col(sourceColumn)))

    // convert features vectors to DBSCAN internal representation
    val pointRdd = df.select(sourceColumn).rdd.map {
      case Row(pca_features: Vector) => new Point(pca_features)
    }

    val dbscanModel = Dbscan.train(pointRdd, clusteringSettings, partitioningSettings)

    //Get results out of DBSCAN and find "original" points by hash
    val struct = StructType(
      StructField("clusterId", LongType, nullable = false) ::
        StructField("hash", IntegerType, nullable = false) :: Nil)

    val clusterPoints = dbscanModel.allPoints.map(p => Row(p.clusterId, p.hashCode()))
    val dfR = dataset.sqlContext.createDataFrame(clusterPoints, struct)
    dfR.withColumnRenamed("tempClusterId", targetColumn).join(df, "hash")
    //.dropDuplicates(Seq("hash")).drop("hash")
  }
}
