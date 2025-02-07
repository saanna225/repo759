#!/bin/env zsh
#SBATCH --job-name=FirstSlurm
#SBATCH --error=FirstSlurm.err
#SBATCH --output=FirstSlurm.out
#SBATCH -p instruction
#SBATCH --time 00:01:00
#SBATCH --cpus-per-task=2
#SBATCH --ntasks=1



# Print the hostname of the compute node
cd $SLURM_SUBMIT_DIR
hostname
