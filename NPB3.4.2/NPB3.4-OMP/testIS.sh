#!/bin/bash

echo "Running IS benchmark with class C with several different schedulers"

schedulers=(
    "static"
    "monotonic:static"
    "dynamic"
    "monotonic:dynamic"
    "guided"
    "monotonic:guided"
)

chunks=(
    1
    2
    4
    8
    16
    32
    64
    128
    256
    512
    1024
)

for scheduler in "${schedulers[@]}"
do
    echo -e "\nTESTING $scheduler"
    for chunk in "${chunks[@]}"
    do
        echo "chunk size $chunk"

        export OMP_SCHEDULE="$scheduler,$chunk"
        output=$(./bin/is.C.x | grep -E 'Time in seconds|Mop/s total|Mop/s/thread' | awk '{print $NF}')

        time_seconds=$(echo "$output" | awk 'NR==1')
        mop_total=$(echo "$output" | awk 'NR==2')
        mop_thread=$(echo "$output" | awk 'NR==3')

        echo " Time in seconds: $time_seconds"
        echo " Mop/s total: $mop_total"
        echo " Mop/s/thread: $mop_thread"
    done
done

# Make commands
# make IS CLASS=A
# make IS CLASS=B
# make IS CLASS=C

