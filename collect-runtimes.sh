#!/bin/bash

set -e

if [ $# -ne 2 ]; then
    echo "Usage: $0 <experiment-dir> <count>"
    exit 1
fi

EXPERIMENT_DIR=$1
COUNT=$2

echo "Experiment Directory: $EXPERIMENT_DIR"
echo "Count: $COUNT"

pushd $EXPERIMENT_DIR > /dev/null
kiso check

for i in $(seq 1 $COUNT); do
    echo "Running experiment $i / $COUNT"
    mkdir output-$i
    time kiso --debug up --output ./output-$i > ./output-$i/kiso.log 2>&1

    kiso --debug down --output ./output-$i
    echo "Finished running experiment $i / $COUNT"
done

popd > /dev/null
