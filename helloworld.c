#include <omp.h>
#include <stdio.h>
#include <stdlib.h>

#define ARRAY_SIZE 1000000

int main() {
    // printing the sheculer and threads
    const char *schedule_type = getenv("OMP_SCHEDULE");
    if (schedule_type != NULL) {
        printf("Using scheduling type: %s\n", schedule_type);
    } else {
        printf("OMP_SCHEDULE environment variable not set.\n");
    }

    const char *num_threads_str = getenv("OMP_NUM_THREADS");
    int num_threads;
    if (num_threads_str != NULL) {
        num_threads = atoi(num_threads_str);
    } else {
        // Default to the maximum available threads if OMP_NUM_THREADS is not set
        num_threads = omp_get_max_threads();
    }
    printf("Number of threads: %d\n", num_threads);
    
    // Setting simple OMP hello world code
    #pragma omp parallel for schedule(runtime)
    for (int i = 0; i < num_threads * 2; i++) {
        int thread_id = omp_get_thread_num();
        printf("Hello from thread %d\n", thread_id);
    }
    
    // now something that can better show of the schedules. Crearing array and summing elements in it
    int i, sum = 0;
    int array[ARRAY_SIZE];

    for (i = 0; i < ARRAY_SIZE; i++) {
        array[i] = i + 1;
    }

    double start_time = omp_get_wtime(); 

    #pragma omp parallel for schedule(runtime) reduction(+:sum)
    for (i = 0; i < ARRAY_SIZE; i++) {
        // printf("%d\n", array[i]);
        sum += array[i];
    }

    double end_time = omp_get_wtime();
    double elapsed_time = end_time - start_time;

    printf("Sum %d\n", sum);
    printf("Elapsed time: %f seconds\n\n", elapsed_time);

    return 0;
}
