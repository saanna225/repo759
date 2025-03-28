#!/bin/bash
#SBATCH --job-name=task2
#SBATCH --output=task2.out
#SBATCH --error=task2.err
#SBATCH --ntasks=1
#SBATCH --partition=research
#SBATCH --gpus=1
#SBATCH --time=00:01:00


module load nvidia/cuda/11.8.0

./task2

