#include <cstdio>
#include <cstdlib>
#include <random>
#include <cuda_runtime.h>
#include "vscale.cuh"


int main(int argc, char* argv[]) {
    if (argc != 2) {
        printf("Usage: %s <array size>\n", argv[0]);
        return 1;
    }

  unsigned int n = atoi(argv[1]);

    // Host memory
    float *hA = new float[n];
    float *hB = new float[n];

    // Random number generation
    std::random_device rd;
    std::mt19937 gen(rd());
    std::uniform_real_distribution<float> distA(-10.0f, 10.0f);
    std::uniform_real_distribution<float> distB(0.0f, 1.0f);

    for (int i = 0; i < n; ++i) {
        hA[i] = distA(gen);
        hB[i] = distB(gen);
    }

    // Device memory
    float *dA, *dB;
    cudaMalloc(&dA, n * sizeof(float));
    cudaMalloc(&dB, n * sizeof(float));

    // Copy to device
    cudaMemcpy(dA, hA, n * sizeof(float), cudaMemcpyHostToDevice);
    cudaMemcpy(dB, hB, n * sizeof(float), cudaMemcpyHostToDevice);

    // CUDA events for timing
    cudaEvent_t start, stop;
    cudaEventCreate(&start);
    cudaEventCreate(&stop);
    cudaEventRecord(start);

    // Kernel config
    int blockSize = 16;
    int gridSize = (n + blockSize - 1) / blockSize;
    vscale<<<gridSize, blockSize>>>(dA, dB, n);

    // Timing
    cudaEventRecord(stop);
    cudaEventSynchronize(stop);
    float ms = 0;
    cudaEventElapsedTime(&ms, start, stop);

    // Copy result back
    cudaMemcpy(hB, dB, n * sizeof(float), cudaMemcpyDeviceToHost);

    // Print results
    printf("%.3f\n", ms);         // Time in ms
  //  printf("%.2f\n", hB[0]);      // First element
//    printf("%.2f\n", hB[n - 1]);  // Last element

    // Cleanup
    delete[] hA;
    delete[] hB;
    cudaFree(dA);
    cudaFree(dB);
    cudaEventDestroy(start);
    cudaEventDestroy(stop);

    return 0;
}

