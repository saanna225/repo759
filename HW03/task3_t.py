import numpy as np
import matplotlib.pyplot as plt
import os
file_path = os.path.join(os.getcwd(), "task3_t_output.txt")
print(f"Attempting to open: {file_path}")

threads = []
times = []

try:
    with open(file_path, "r", encoding="utf-8") as f:
        for line in f:
            values = line.strip().split(",")
            if len(values) == 2:
                t = values[0].split("=")[-1]  
                time = values[1].split("=")[-1].split()[0]  
                threads.append(int(t))
                times.append(float(time))
except FileNotFoundError:
    print(f"Error: File '{file_path}' not found!")
    exit(1)
#plot
plt.figure(figsize=(8, 6))
plt.plot(threads, times, marker='o', linestyle='-', color='b', label="Time Taken")
plt.xlabel("Number of Threads (t)")
plt.ylabel("Time Taken (ms)")
plt.title("Sorting Time vs. Threads (Linear-Linear Scale)")

plt.grid(True, linestyle="--", linewidth=0.5)
plt.legend()
plt.savefig("task3_t.pdf")
print("Plot saved as task3_t.pdf")
plt.show()
