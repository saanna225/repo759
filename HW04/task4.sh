x#!/bin/bash
#SBATCH --job-name=task4         # Job name
#SBATCH --output=task4.out   # Log file (%j = job ID)
#SBATCH --time=02:00:00                # Max run time
#SBATCH --mem=8G                        # Memory allocation
#SBATCH --ntasks=1                      # Single task
#SBATCH --cpus-per-task=8                # Request 8 CPU cores
#SBATCH --partition=research               # Partition to use

# Load necessary modul       # Load GCC with OpenMP support
module load gcc/14.1.1
# Compile the program with OpenMP
g++ task3.cpp -Wall -O3 -std=c++17 -o task3 -fopenmp

# Create a results file and add a header
echo "ScheduleType,Particles,SimulationTime,Threads,ExecutionTime(ms)" > task4.out

# Loop over different scheduling policies, simulation times, and thread counts
for schedule in static dynamic guided; do
    for sim_time in 100 200 300; do
        for threads in 1 2 4 6 8; do
            echo "Running task3 with $schedule scheduling, $sim_time sec simulation, $threads threads..."
            ./task3 100 $sim_time $threads $schedule >> task4.out
        done
    done
done

echo "Job Completed! Results saved to task4 output"

