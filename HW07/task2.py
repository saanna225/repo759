import matplotlib.pyplot as plt
from matplotlib.ticker import LogFormatter

# Thread-wise dictionary: thread -> list of (N, time)
data = {}

with open("task2.out", "r") as file:
    lines = file.readlines()
    current_thread = None
    current_N = None

    for line in lines:
        line = line.strip()
        if line.startswith("Threads ="):
            current_thread = int(line.split("=")[1].strip())
            data.setdefault(current_thread, [])
        elif line.startswith("Running with N ="):
            current_N = int(line.split("=")[1].strip())
        elif line.startswith("Time Elapsed:"):
            time = float(line.split(":")[1].strip().replace("ms", ""))
            if current_thread is not None and current_N is not None:
                data[current_thread].append((current_N, time))

# Plotting
plt.figure(figsize=(10, 6))

for thread_count in sorted(data.keys()):
    data[thread_count].sort()  # sort by N
    Ns, times = zip(*data[thread_count])
    plt.plot(Ns, times, marker='o', label=f"Threads = {thread_count}")

plt.xscale('log', base=2)
plt.yscale('log')
plt.gca().yaxis.set_major_formatter(LogFormatter(labelOnlyBase=False, base=10.0))
plt.xlabel('Number of Elements (log scale)')
plt.ylabel('Elapsed Time (ms, log scale)')
plt.title('Reduce Function Analysis')
plt.grid(True, which="both", linestyle='--', linewidth=0.5)
plt.legend()
plt.tight_layout()
plt.savefig("task2.pdf")
plt.show()
