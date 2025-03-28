import matplotlib.pyplot as plt
import numpy as np

def load_data(filename):
    data = np.loadtxt(filename)
    return data[:, 0], data[:, 1]  # n, time

# Load both datasets
n_512, t_512 = load_data("output.txt")
n_16, t_16 = load_data("output16.txt")

# Plot setup
plt.figure(figsize=(9, 5))
plt.plot(n_512, t_512, 'o-', label='512 threads in use')
plt.plot(n_16, t_16, 'd-', label='16 threads in use')

# Axis setup
plt.xscale("log", base=2)
plt.xlabel("n (input size)")
plt.ylabel("Execution Time (ms)")
plt.title("CUDA scaling")
plt.grid(True, which="both", linestyle='--', alpha=0.5)
plt.legend()
plt.tight_layout()

# Save and show
plt.savefig("task3.pdf")
plt.show()

