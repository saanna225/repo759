#!/bin/bash
#SBATCH --job-name=task1_job
#SBATCH --output=task1.out   # Save output to task1.out
#SBATCH --error=task1.err    # Save errors (if any)
#SBATCH --time=00:10:00      # Max runtime
#SBATCH --mem=4G             # Allocate memory
#SBATCH --ntasks=1           # Run as a single task
#SBATCH --cpus-per-task=20   # Request 20 CPU cores (same as -c 20)
#SBATCH --partition=instruction  # Choose the correct Slurm partition

module load gcc
g++ task1.cpp matmul.cpp -Wall -03 -std=c++17 -o task1 -fopenmp

echo "Threads,Time(ms)" > task1.out  

for t in {1..20}; do
    echo "Running task1 with t = $t"
   ./task1 1024 $t >> task1.out  
done

