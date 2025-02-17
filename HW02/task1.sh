#!/usr/bin/env bash
#SBATCH --time=00:30:00                  # Max runtime 
#SBATCH --mem=4G                  # Memory allocation
#SBATCH --ntasks=1                # Number of tasks
#SBATCH --partition=instruction 
#SBATCH --job-name=task1_scaling         # Job name
#SBATCH --output=task1.out          # Standard output file
#SBATCH --error=task1.err


if [ "$1" = "compile" ]; then
  g++ scan.cpp task1.cpp -Wall -O3 -o task1
elif [ "$1" = "run" ]; then
   echo "n ,time(ms)" > task1.out
  for i in {10..30}; do
    n=$((2 ** i))
    echo "Running with n = 2^$i = $n"
    runtime =$(./task1 $n |grep "how fast is scan function" |awk '{print $5}')
    echo "$n.$runtime">>task1.out
  done
elif [ "$1" = "plot" ]; then
  python task1_plot.py
elif [ "$1" = "clean" ]; then
  rm -f task1 task1.err task1.out task1.pdf
else
  echo "./task1.sh [compile | run | plot | clean]"
fi
