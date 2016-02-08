import org.apache.spark.ml.feature.PCA
import org.apache.spark.mllib.linalg.{Vector, Vectors}
import org.apache.spark.rdd.RDD
import org.apache.spark.sql._
import org.apache.spark.sql.Row
import org.apache.spark.sql.types._
import org.apache.spark.mllib.linalg.VectorUDT
import org.alitouka.spark.dbscan.spatial.Point 
import org.alitouka.spark.dbscan.{Dbscan, DbscanSettings}
import org.alitouka.spark.dbscan.spatial.rdd.PartitioningSettings
import org.apache.spark.sql.functions._

//Read source file from HDFS
var df = sqlContext.read.format("com.databricks.spark.csv").option("header","true").load("hdfs://vmk0007.analytics.ibmcloud.com:9000/poc-data/source/transaction/transaction1000000.csv")
//There is already "category" column in the file
df = df.drop("category")

val struct_features = StructType(
	StructField("features",new VectorUDT(),false) ::
	StructField("source",df.schema,false) :: Nil)

// Create features vector from and place original content in inner structure
df = sqlContext.createDataFrame(df.map(r => Row(Vectors.dense(r.toSeq.map(s => s match {case st: String => st.toDouble case _ => throw new ClassCastException }).toArray),r)),struct_features)

// PCA
val pca = new PCA().setK(10).setInputCol("features").setOutputCol("pca_features")
val pcaModel = pca.fit(df)
df = pcaModel.transform(df)

// current DBSCAN implementation don't respect "IDs" of any kind, so we'll merge results by hashcode
var addHash = udf {c:Vector => new Point(c.toArray).hashCode}
df = df.withColumn("hash",addHash(col("pca_features")))

// convert features vectors to DBSCAN internal representation
val pointRdd = df.select("pca_features").rdd.map {
	case Row(pca_features: Vector) => new Point(pca_features.toArray)
}

//DBSCAN
val clusteringSettings = new DbscanSettings().withEpsilon(11).withNumberOfPoints(10)
val partitioningSettings = new PartitioningSettings(numberOfPointsInBox = 30000)
val dbscanModel = Dbscan.train(pointRdd, clusteringSettings, partitioningSettings)

//Get results out of DBSCAN and find "original" points by hash
case class ClusterPoint(clusterId:Long, hash:Int)
val clusterPoints = dbscanModel.allPoints.map(p => ClusterPoint(clusterId=p.clusterId,hash=p.hashCode())).toDF()
val result = df.join(clusterPoints, "hash").dropDuplicates(Seq("hash")).drop("hash")

//Add clusterId to source data
val targetSchema = df.schema("source").dataType match {case s: StructType => s.add(StructField("clusterId",LongType,false)) case _ => throw new ClassCastException }
val resultOut = sqlContext.createDataFrame(result.select("source","clusterId").map(r => Row.fromSeq(r.getStruct(0).toSeq :+ r.getLong(1))),targetSchema).coalesce(1)

//write out results
resultOut.write.format("json").save("results.json")
