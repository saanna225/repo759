#!/bin/bash
#SBATCH --job-name=task2
#SBATCH --output=task2.out 
#SBATCH --time=01:00:00
#SBATCH --mem=4G
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=8
#SBATCH --partition=interactive


# Compile
g++ task2.cpp -Wall -O3 -std=c++17 -o task2


echo "Particles,SimulationTime,ExecutionTime(ms)" > task2.out

# Run simulations and save structured data
./task2 100 100.0 >> task2.out
./task2 200 110.0 >> task2.out
./task2 500 100.0 >> task2.out
./task2 700 140.0 >> task2.out

echo "Job Completed! Results saved to task2.out"

