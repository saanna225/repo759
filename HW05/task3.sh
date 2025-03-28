#!/bin/bash
#SBATCH --job-name=task3
#SBATCH --output=timing.log
#SBATCH --error=timing.err
#SBATCH --ntasks=1
#SBATCH --partition=research
#SBATCH --gpus=1
#SBATCH --time=00:10:00


module load nvidia/cuda/11.8.0

for ((i=10; i<=29; i++)); do
    n=$((2**i))
    echo -n "$n " >> output16.txt
    ./task3 $n >> output16.txt
done

