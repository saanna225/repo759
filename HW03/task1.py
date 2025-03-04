import os
import matplotlib.pyplot as plt

threads = []
times = []

file_path = os.path.join(os.getcwd(), "task1.out")
print(f"Attempting to open: {file_path}")

try:
    with open(file_path, "r", encoding="utf-8") as f:
        next(f) 
        for line in f:
            values = line.strip().split(",")
            if len(values) == 2:
                threads.append(int(values[0]))
                times.append(float(values[1]))

    #plot
    plt.figure(figsize=(8, 6))
    plt.plot(threads, times, marker='o', linestyle='-', label="Execution Time")
    plt.xlabel("Thread Number")
    plt.ylabel("Time (ms)")
    plt.title("Execution Time vs. Thread Num")
    plt.grid()
    plt.legend()
    plt.savefig("task1.pdf")
    plt.show()

except FileNotFoundError:
    print("Error: task1.out file not found. ")
except Exception as e:
    print(f"An error occurred: {e}")





