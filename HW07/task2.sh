#!/usr/bin/env zsh
#SBATCH -p instruction
#SBATCH -J reduce
#SBATCH -o task2.out
#SBATCH -e task2.err
#SBATCH --gres=gpu:1
#SBATCH -c 1
#SBATCH --time=0-00:10:00

cd $SLURM_SUBMIT_DIR

# Load necessary modules
module load gcc/11.3.0
module load nvidia/cuda/11.8.0

# Compile once
nvcc task2.cu reduce.cu -Xcompiler -O3 -Xcompiler -Wall -Xptxas -O3 -std=c++17 -o task2

# Thread configurations to test
for threads in 256 512 1024; do
    echo "Threads = $threads" >> task2.out
    for i in {10..30}; do
        N=$((2**i))
        echo "Running with N = $N" >> task2.out
        ./task2 $N $threads >> task2.out
        echo "" >> task2.out
    done
    echo "" >> task2.out
done
