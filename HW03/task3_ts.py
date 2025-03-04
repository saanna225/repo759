import numpy as np
import matplotlib.pyplot as plt
import os


file_path = os.path.join(os.getcwd(), "task3_ts_output.txt")
print(f"Attempting to open: {file_path}")


ts_values = []
time_values = []

try:
    with open(file_path, "r", encoding="utf-8") as f:
        for line in f:
            values = line.strip().split(",")
            if len(values) == 2:
                ts = values[0].split("=")[-1]  
                time = values[1].split("=")[-1].split()[0]  
                ts_values.append(int(ts))
                time_values.append(float(time))
except FileNotFoundError:
    print(f"Error: File '{file_path}' not found!")
    exit(1)

#plot
plt.figure(figsize=(8, 6))
plt.plot(ts_values, time_values, marker='o', linestyle='-', color='b', label="Time Taken")
plt.xlabel("Threshold (ts)")
plt.ylabel("Time Taken (ms)")
plt.title("Sorting Time vs. Threshold (Log Scale with Powers of 2)")
plt.xscale("log", base=2)


plt.xticks(ts_values, labels=[str(t) for t in ts_values])
plt.minorticks_on()
plt.grid(True, which="both", linestyle="--", linewidth=0.5)
plt.legend()
plt.savefig("task3_ts.pdf")
print("Plot saved as task3_ts.pdf")
plt.show()



