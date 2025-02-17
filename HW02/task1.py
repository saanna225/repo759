import matplotlib.pyplot as plt
from matplotlib.backends.backend_pdf import PdfPages

xticks = []
times = []

with open("task1.out") as f:
    for line in f:
        if "Running with n" in line:
            parts = line.split("=") #taking n value from lines
            if len(parts) >= 2:
                n_value = int(parts[-1].strip())  
                xticks.append(n_value)
        else:
            try:
                times.append(float(line.strip()))  
            except ValueError:
                pass  


if len(xticks) > len(times):
    xticks = xticks[:len(times)] 

with PdfPages("task1.pdf") as pdf:
    plt.plot(xticks, times, "o")
    plt.xlabel("Array Size (n)")
    plt.ylabel("Time (milliseconds)")
    plt.title("Scaling Analysis of scan funcn Plot")
    plt.xscale("log") 
    plt.grid(True, which="both", linestyle="--")
    pdf.savefig()

print("Plot saved as task1.pdf")
