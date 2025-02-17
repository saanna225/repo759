#!/bin/bash
#SBATCH --job-name=task3_job
#SBATCH --output=task3.out      # Standard output saved here
#SBATCH --error=task3.err       # Errors saved here
#SBATCH --time=00:10:00         # Job time limit
#SBATCH --mem=8G                # Memory allocation
#SBATCH --ntasks=1              # Run as a single task
#SBATCH --partition=instruction # Euler's compute partition

# Load necessary modules (if required)
module load gcc


g++ task3.cpp matmul.cpp -Wall -O3 -std=c++17 -o task3

./task3

