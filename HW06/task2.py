import matplotlib.pyplot as plt
import numpy as np
data = np.loadtxt("task2.out", skiprows=1)

n = data[:, 0]
time_1024 = data[:, 1]
time_288 = data[:, 2]

plt.figure(figsize=(10, 6))
plt.plot(n, time_1024, 'o-', label='1024 threads/block')
plt.plot(n, time_288, 's--', label='288 threads/block')

plt.xscale("log", base=2)
plt.yscale("log")
plt.xlabel("i/p size (n)")
plt.ylabel("Execution Time (ms)")
plt.title("CUDA Scaling")
plt.grid(True, which="both", linestyle="--", alpha=0.5)
plt.legend()
plt.tight_layout()
plt.savefig("task2.pdf")
plt.show()
