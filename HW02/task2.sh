#!/bin/bash
#SBATCH --job-name=task2_job
#SBATCH --output=task2_output.txt  # Save output here
#SBATCH --error=task2_error.txt    # Save errors here
#SBATCH --time=00:10:00            # Set time limit
#SBATCH --mem=4G                   # Allocate memory
#SBATCH --ntasks=1                 # Run as a single task
#SBATCH --partition=instruction     # Choose correct Slurm partition

# Load necessary modules (if any)
module load gcc

# Run task2 with parameters
./task2 100 35
