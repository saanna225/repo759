#!/bin/bash
#SBATCH --job-name=task1
#SBATCH --output=task1.out
#SBATCH --error=task1.err
#SBATCH --partition=research
#SBATCH --gres=gpu:1
#SBATCH --time=00:10:00
#SBATCH --mem=4G

module load nvidia/cuda/11.8.0

nvcc task1.cu matmul.cu -Xcompiler -O3 -Xcompiler -Wall -Xptxas -O3 -std=c++17 -o task1

rm -rf task1.out
# Output file for timing data
 echo "#n time_1024 time_288" > task1.out

for ((i=5; i<=14; i++)); do
    n=$((2 ** i))

    # Run with threads_per_block = 1024
    time_1024=$(./task1 $n 1024 | tail -n 1)
  echo "Running for n = $n" >> debug.log
./task1 $n 1024 >> debug.log
./task1 $n 288 >> debug.log


    # Run with threads_per_block = 256
    time_288=$(./task1 $n 288 | tail -n 1)

    echo "$n $time_1024 $time_288" >> task1.out
done

