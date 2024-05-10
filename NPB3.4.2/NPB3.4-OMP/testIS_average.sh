#!/bin/bash

# echo "Running IS benchmark with class C with several different schedulers"

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
        sum_time=0
        sum_mop_total=0
        sum_mop_thread=0
        count=20 

        for ((i=1; i<=$count; i++))
        do
            output=$(./bin/is.C.x | grep -E 'Time in seconds|Mop/s total|Mop/s/thread' | awk '{print $NF}')
            time_seconds=$(echo "$output" | awk 'NR==1')
            mop_total=$(echo "$output" | awk 'NR==2')
            mop_thread=$(echo "$output" | awk 'NR==3')

            sum_time=$(echo "$sum_time + $time_seconds" | bc)
            sum_mop_total=$(echo "$sum_mop_total + $mop_total" | bc)
            sum_mop_thread=$(echo "$sum_mop_thread + $mop_thread" | bc)
        done

        avg_time=$(echo "scale=2; $sum_time / $count" | bc)
        avg_mop_total=$(echo "scale=2; $sum_mop_total / $count" | bc)
        avg_mop_thread=$(echo "scale=2; $sum_mop_thread / $count" | bc)

        echo " Average Time in seconds: $avg_time"
        echo " Average Mop/s total: $avg_mop_total"
        echo " Average Mop/s/thread: $avg_mop_thread"
    done
done
