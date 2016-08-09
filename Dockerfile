FROM uhopper/hadoop:2.7.2
MAINTAINER ra.vitillo@gmail.com

ENV HIVE_VERSION 2.1.0
ENV DOCKERIZE_VERSION v0.2.0
ENV HIVE_HOME /usr/local/hive-dist/apache-hive-${HIVE_VERSION}-bin
ENV HIVE_CONF $HIVE_HOME/conf
ENV PATH $HIVE_HOME/bin:$PATH

RUN apt-get update && apt-get install -y wget postgresql-client libpostgresql-jdbc-java
RUN wget http://apache.mirror.anlx.net/hive/hive-${HIVE_VERSION}/apache-hive-${HIVE_VERSION}-bin.tar.gz && \
    mkdir /usr/local/hive-dist && \
    tar -xf apache-hive-${HIVE_VERSION}-bin.tar.gz -C /usr/local/hive-dist && \
    rm apache-hive-${HIVE_VERSION}-bin.tar.gz && \
    ln -s /usr/share/java/postgresql-jdbc4.jar $HIVE_HOME/lib/postgresql-jdbc4.jar && \
    wget https://github.com/jwilder/dockerize/releases/download/$DOCKERIZE_VERSION/dockerize-linux-amd64-$DOCKERIZE_VERSION.tar.gz && \
    tar -C /usr/local/bin -xzvf dockerize-linux-amd64-$DOCKERIZE_VERSION.tar.gz

ADD resources/entrypoint_hive.sh entrypoint_hive.sh
ADD resources/hive-site.xml.template $HIVE_CONF/hive-site.xml.template
ADD resources/hive-log4j.properties.template $HIVE_CONF/hive-log4j.properties.template
RUN chmod +x entrypoint_hive.sh

ENTRYPOINT ["./entrypoint_hive.sh"]
CMD ["hive --service metastore"]
