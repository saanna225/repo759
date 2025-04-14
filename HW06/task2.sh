#!/bin/bash
#SBATCH --job-name=task2
#SBATCH --output=task2.out
#SBATCH --error=task2.err
#SBATCH --partition=instruction
#SBATCH --gres=gpu:1
#SBATCH --time=00:20:00
#SBATCH --mem=8G

module load nvidia/cuda/11.8.0

# Compile
nvcc task2.cu stencil.cu -Xcompiler -O3 -Xcompiler -Wall -Xptxas -O3 -std=c++17 -o task2
rm -rf task2.out
# Output file
echo "#n time_1024 time_288" > task2.out

for ((i=10; i<=29; i++)); do
    n=$((1 << i))  # n = 2^i
    R=128
output_1024=$(./task2 $n $R 1024)
time_1024=$(echo "$output_1024" | grep 'Time:' | awk '{print $2}')
echo "$output_1024" >> debug.log

output_288=$(./task2 $n $R 288)
time_288=$(echo "$output_288" | grep 'Time:' | awk '{print $2}')
echo "$output_288" >> debug.log



echo "$n $time_1024 $time_288" >> task2.out
done

