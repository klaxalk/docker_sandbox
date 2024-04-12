#!/bin/bash

echo "$0: starting"

SCRIPT_PATH=`dirname "$0"`
SCRIPT_PATH=`( cd "$SCRIPT_PATH" && pwd )`

DATA_DIR=/local/data
WORK_DIR=/local/work

cd $WORK_DIR

echo "$0: finished"
