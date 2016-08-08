#!/bin/bash

sh -c ./entrypoint.sh

dockerize -template $HIVE_CONF/hive-site.xml.template:$HIVE_CONF/hive-site.xml \
          -wait tcp://$DB_URI:5432 \
          -timeout 30s

schematool -dbType postgres -initSchema

exec $@
