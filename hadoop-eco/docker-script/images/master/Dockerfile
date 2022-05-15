FROM hjben/hadoop-eco:3.3.0

ENV HADOOP_CONF_DIR=$HADOOP_HOME/etc/hadoop
ENV SPARK_HOME=$HADOOP_HOME/spark
ENV LD_LIBRARY_PATH=$HADOOP_HOME/lib/native:$LD_LIBRARY_PATH
ENV PATH=$SPARK_HOME/bin:$SPARK_HOME/sbin:$PATH

RUN dnf -y --disablerepo '*' --enablerepo=extras swap centos-linux-repos centos-stream-repos && \
    dnf distro-sync -y && \
    dnf install -y epel-release && \
    dnf install -y nano python3 supervisor && \
    dnf clean all && \
    wget https://dlcdn.apache.org/spark/spark-3.1.3/spark-3.1.3-bin-hadoop3.2.tgz -O /tmp/spark.tgz && \
    tar zvxf /tmp/spark.tgz -C $HADOOP_HOME && \
    mv $HADOOP_HOME/spark-3.1.3-bin-hadoop3.2 $HADOOP_HOME/spark && \
    chown -R hdfs:hdfs $HADOOP_HOME/spark && \
    rm -f /tmp/spark.tgz && \
    mv $SPARK_HOME/conf/spark-defaults.conf.template $SPARK_HOME/conf/spark-defaults.conf && \
    echo "spark.master yarn" >> $SPARK_HOME/conf/spark-defaults.conf && \
    echo "spark.eventLog.enabled true" >> $SPARK_HOME/conf/spark-defaults.conf && \
    echo "spark.eventLog.dir hdfs://master:9000/spark-logs" >> $SPARK_HOME/conf/spark-defaults.conf && \
    echo "spark.history.provider org.apache.spark.deploy.history.FsHistoryProvider" >> $SPARK_HOME/conf/spark-defaults.conf && \
    echo "spark.history.fs.logDirectory hdfs://master:9000/spark-logs" >> $SPARK_HOME/conf/spark-defaults.conf && \
    echo "spark.history.fs.update.interval 10s" >> $SPARK_HOME/conf/spark-defaults.conf && \
    echo "spark.history.ui.port 18080" >> $SPARK_HOME/conf/spark-defaults.conf && \
    pip3 install pandas

# hdfs dfs -mkdir /spark-logs is executed during hive init
