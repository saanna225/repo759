#!/bin/bash
#SBATCH --job-name=Task6
#SBACTH --output=task6.err
#SBATCH --output=task6.out
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=2

# Print the hostname of the machine
hostname
