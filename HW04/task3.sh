#!/bin/bash
#SBATCH --job-name=task3         # Job name
#SBATCH --output=task3.out  # Log file (%j = job ID)
#SBATCH --time=02:00:00                # Max run time
#SBATCH --mem=8G                        # Memory allocation
#SBATCH --ntasks=1                      # Single task
#SBATCH --cpus-per-task=8                # Request 8 CPU cores for OpenMP
#SBATCH --partition=research        # Partition to use

# Load necessary modul           # Load GCC with OpenMP support

# Compile the program with OpenMP
g++ task3.cpp -Wall -O3 -std=c++17 -o task3 -fopenmp

# Create a results file and add a header
echo "Scheduletype,Particles,SimulationTime,Threads,ExecutionTime(ms)" > task3.out

# Loop over different simulation times and thread counts
for schedule in static guided dynamic; do
   for threads in 1 2 4 5 6 8; do
     echo "Running task3 with 104 particles, $sim_time sec simulation, $threads threads..."
    ./task3 104 150 $threads $schedule >> task3.out
      
  done
done

echo "Job Completed! Results saved to task3_out"

