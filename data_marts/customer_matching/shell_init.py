# Configure the necessary Spark environment
import os
import sys

spark_home = os.environ.get('SPARK_HOME', None)
sys.path.insert(0, spark_home + "/python")

# Add the py4j to the path.
# You may need to change the version number to match your install
sys.path.insert(0, os.path.join(spark_home, 'python/lib/py4j-0.8.2.1-src.zip'))

# Initialize PySpark to predefine the SparkContext variable 'sc'
pyspark_submit_args = os.environ.get("PYSPARK_SUBMIT_ARGS", "")

pyspark_submit_args += (" --jars " + os.environ.get("SPARK_HOME", "") + 
    "/lib/spark-streaming-kafka-assembly_2.10-1.4.1.jar" + 
    " --driver-class-path /usr/share/java/postgresql-9.4.1208.jre6.jar")
    
# + 
#    " --packages com.databricks:spark-csv_2.10:1.3.0")

if not "pyspark-shell" in pyspark_submit_args:
    pyspark_submit_args += " pyspark-shell"

os.environ["PYSPARK_SUBMIT_ARGS"] = pyspark_submit_args
os.environ["PYSPARK_PYTHON"] = 'python2.7'

execfile(os.path.join(spark_home, 'python/pyspark/shell.py'))
