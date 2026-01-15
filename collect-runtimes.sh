#!/bin/bash

set -e

if [ $# -gt 3 ]; then
    echo "Usage: $0 <experiment-dir> [start] <count>"
    exit 1
fi

EXPERIMENT_DIR=$1

if [ $# -eq 2 ]; then
    START=1
    COUNT=$2
else
    START=$2
    COUNT=$3
fi

echo "Experiment Directory: $EXPERIMENT_DIR"
echo "Count: $COUNT"

pushd $EXPERIMENT_DIR > /dev/null
kiso check

for i in $(seq $START $COUNT); do
    echo "- Running experiment $i / $COUNT -"
    mkdir output-$i
    time kiso --debug up --output ./output-$i

    time kiso --debug run --output ./output-$i

    kiso --debug down --output ./output-$i
    echo "- Finished running experiment $i / $COUNT -"
done

popd > /dev/null
