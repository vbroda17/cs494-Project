#!/bin/bash

echo "Compiling helloworld.c"
gcc -o helloworld helloworld.c -fopenmp

# echo "setting num threads"
# export OMP_NUM_THREADS=8

thread_counts=(2 4 8)
for count in "${thread_counts[@]}"
do
    echo "Setting threads to $count"
    export OMP_NUM_THREADS=$count

    # setting out file outputs
    folder="outputs"
    output="$folder/output_$count.txt"


    echo "Setting OMP_SCHEDULE to static"
    export OMP_SCHEDULE="static, 2"
    echo "Running program..."
    ./helloworld > $output
    echo -e "\n"

    echo "Setting OMP_SCHEDULE to dynamic"
    export OMP_SCHEDULE="dynamic, 2"
    echo "Running program..."
    ./helloworld >> $output
    echo -e "\n"

    echo "Setting OMP_SCHEDULE to guided"
    export OMP_SCHEDULE="guided"
    echo "Running program..."
    ./helloworld >> $output
    echo -e "\n"

    echo "Setting OMP_SCHEDULE to auto"
    export OMP_SCHEDULE="auto"
    echo "Running program..."
    ./helloworld >> $output
    echo -e "\n"


done
