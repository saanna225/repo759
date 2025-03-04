#!/bin/bash
#SBATCH --job-name=task3
#SBATCH --output=task3.out
#SBATCH --partition=instruction
#SBATCH --cpus-per-task=20
#SBATCH --time=00:30:00

# Compile task3
g++ task3.cpp msort.cpp -Wall -O3 -std=c++17 -o task3 -fopenmp

N=1000000  # Array size (10^6)
T=8        # Fixed thread count for ts experiment
TS_FILE="task3_ts_output.txt"
T_FILE="task3_t_output.txt"

rm -f $TS_FILE $T_FILE  # Clear old files

echo "Running task3 for ts values..."
for i in {1..10}; do
    ts=$((2**i))
    time_taken=$(./task3 $N $T $ts | awk '/Time taken/ {print $3}')
    echo "$ts,$time_taken" | tee -a $TS_FILE
done

[ ! -s "$TS_FILE" ] && { echo "Error: ts output empty!"; exit 1; }

BEST_TS=$(awk -F, 'NR==1 || $2 < min {min=$2; best=$1} END {print best}' $TS_FILE)
echo "Best ts: $BEST_TS"

echo "Running task3 for t values..."
for t in {1..20}; do
    time_taken=$(./task3 $N $t $BEST_TS | awk '/Time taken/ {print $3}')
    echo "$t,$time_taken" | tee -a $T_FILE
done

[ ! -s "$T_FILE" ] && { echo "Error: t output empty!"; exit 1; }

echo "Done! Results saved to $TS_FILE and $T_FILE."

