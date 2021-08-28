#!/usr/bin/env bash
cd /hive-config
sed '9c RIG_ID=1101053' rig.config
sed '12c RIG_PASSWD="n3wktuvof8d"' rig.config
sed '15c WORKER_NAME="2"' rig.config
sed '18c FARM_ID=62644' rig.config
