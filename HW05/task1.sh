#!/bin/bash
#SBATCH --job-name=task1
#SBATCH --output=task1.out
#SBATCH --error=task1.err
#SBATCH --partition=research
#SBATCH --ntasks=1
#SBATCH --gpus-per-task=1
#SBATCH --time=00:01:00

module load nvidia/cuda/11.8.0
./task1
