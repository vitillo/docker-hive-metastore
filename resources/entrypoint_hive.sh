#!/bin/bash

sh -c ./entrypoint.sh

dockerize -template $HIVE_CONF/hive-site.xml.template:$HIVE_CONF/hive-site.xml \
	  -template $HIVE_CONF/hive-log4j.properties.template:$HIVE_CONF/hive-log4j.properties \
          -wait tcp://$DB_URI:5432 \
          -timeout 300s

schematool -dbType postgres -initSchema

exec $@
