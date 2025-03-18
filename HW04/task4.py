import pandas as pd
import matplotlib.pyplot as plt

# Load results from task3.out
data = []
with open("task3.out", "r") as file:
    next(file)
    for line in file:
        parts = line.strip().split(",")
        if len(parts) == 5:
            schedule, particles, sim_time, threads, exec_time = parts
            data.append([schedule, int(threads), float(exec_time)])

# Convert data into a DataFrame
df = pd.DataFrame(data, columns=["ScheduleType", "Threads", "ExecutionTime"])

# Set color map for different scheduling types
colors = {"static": "purple", "dynamic": "cyan", "guided": "chocolate"}

# Plot for each scheduling policy
plt.figure(figsize=(10, 6))
for schedule in ["static", "dynamic", "guided"]:
    subset = df[df["ScheduleType"] == schedule]
    plt.plot(subset["Threads"], subset["ExecutionTime"], marker='o', linestyle='-', label=schedule, color=colors[schedule])

# Formatting
plt.xlabel("Number of Threads")
plt.ylabel("Execution Time (ms)")
plt.title("Execution Time vs. Number of Threads")
plt.legend()
plt.grid(True)

# Save the plot
plt.savefig("task4.pdf")
plt.show()
