#!/usr/bin/env bash

set -e

CACHE_DIR=$HOME/drill/$DRILL_VERSION

if [ ! -d "$CACHE_DIR" ]; then
  wget https://www-eu.apache.org/dist/drill/drill-$DRILL_VERSION/apache-drill-$DRILL_VERSION.tar.gz
  tar xvfz apache-drill-$DRILL_VERSION.tar.gz
  mv apache-drill-$DRILL_VERSION $CACHE_DIR
else
  echo "Apache Drill cached"
fi

cd $CACHE_DIR
screen -d -m bin/drill-embedded
for i in {1..12}; do wget -O- -v http://127.0.0.1:8047/status && break || sleep 5; done
