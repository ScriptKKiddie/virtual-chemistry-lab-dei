#!/bin/bash

DB_NAME1="lab_local"
DB_NAME2="lab_test"
VERSION="v1.0.4"

BACKUP_FILE=$1

# Absolute path to the scripts directory
SCRIPTS_DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )

usage() {
  echo "Usage:"
  echo "$0 <path/to/the/backup/file.tar>"
}

if [ -z $BACKUP_FILE ]; then
  echo "Error: No arguments were passed!!"
  echo "Error: The path to the backup file must be passed."
  usage
  exit 1;
fi

# untar the $BACKUP_FILE file
tar xfvz $BACKUP_FILE
if [ $? -ne 0 ]; then
  echo "Error: Something went wrong while untaring."
  echo "Aborting restore."
  exit 1;
fi

# stop ADS services before restoring..
$SCRIPTS_DIR/stop
# restore from the dump folder
mysqldump $DB_NAME1 < $DB_NAME1
if [ $? -ne 0 ]; then
  echo "Error: Something went wrong while restoring db dump."
  echo "Aborting restore."
  exit 1;
fi
mysqldump $DB_NAME2 < $DB_NAME2
if [ $? -ne 0 ]; then
  echo "Error: Something went wrong while restoring db dump."
  echo "Aborting restore."
  exit 1;
fi
# start back the ADS services
$SCRIPTS_DIR/start

# cleanup
#rm -rf ./dump

echo "Restore successful."
exit 0;
