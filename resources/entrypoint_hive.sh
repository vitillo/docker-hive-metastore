#!/bin/bash

sh -c ./entrypoint.sh

dockerize -template $HIVE_CONF/hive-site.xml.template:$HIVE_CONF/hive-site.xml \
          -wait tcp://$DB_URI:5432 \
          -timeout 30s

pushd $HIVE_HOME/scripts/metastore/upgrade/postgres/
PGPASSWORD=$DB_PASSWORD psql -h $DB_URI -U $DB_USER -d metastore -f hive-schema-${HIVE_VERSION}.postgres.sql
popd

exec $@
