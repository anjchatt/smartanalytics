export SPARK_HOME="/usr/iop/4.1.0.0/spark"
export PATH=$PATH:$SPARK_HOME/python
export PATH=$PATH:$SPARK_HOME/python/lib/py4j-0.8.2.1-src.zip

export PYSPARK_SUBMIT_ARGS=" --jars $SPARK_HOME/lib/spark-streaming-kafka-assembly_2.10-1.4.1.jar"
export PYSPARK_PYTHON="python2.7"
spark-submit $PYSPARK_SUBMIT_ARGS stream_tweets.py
