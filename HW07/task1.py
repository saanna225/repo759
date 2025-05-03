import matplotlib.pyplot as plt

matrix_sizes = []
int_times = []
float_times = []
double_times = []

with open("task1.out", 'r') as f:
    lines = [line.strip() for line in f if line.strip()]

i = 0
while i < len(lines):
    if lines[i].startswith("Running with N ="):
        try:
            n = int(lines[i].split('=')[1].strip())
            matrix_sizes.append(n)

            int_time = float(lines[i + 3])
            float_time = float(lines[i + 6])
            double_time = float(lines[i + 9])

            int_times.append(int_time)
            float_times.append(float_time)
            double_times.append(double_time)

            i += 10  # Skip to the next block
        except (IndexError, ValueError):
            break
    else:
        i += 1

plt.figure(figsize=(10, 6))
plt.plot(matrix_sizes, int_times, 'o-', label='int')
plt.plot(matrix_sizes, float_times, 's-', label='float')
plt.plot(matrix_sizes, double_times, '^-', label='double')

plt.xlabel("Matrix Size (N)")
plt.ylabel("Execution Time (ms)")
plt.title("Execution Time vs Matrix Size")
plt.grid(True)
plt.legend()
plt.savefig("task1.pdf")
plt.show()
