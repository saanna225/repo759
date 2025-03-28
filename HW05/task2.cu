#include <cstdio>
#include <random>
#include <cuda_runtime.h>

__global__ void compute(int* dA, int a) {
    int tid = threadIdx.x + blockIdx.x * blockDim.x;
    int x = threadIdx.x;
    int y = blockIdx.x;

    dA[tid] = a * x + y;
}

int main() {
    const int N = 16;
    int *dA, hA[N];

    // Generate a random integer 'a' between 1 and 10 (inclusive)
    std::random_device rd;
    std::mt19937 gen(rd());
    std::uniform_int_distribution<> dist(1, 10);
    int a = dist(gen);

    // Print random a
    printf("Random a = %d\n", a);

    // Allocate memory on the device
    cudaMalloc((void**)&dA, N * sizeof(int));

    // Launch kernel: 2 blocks of 8 threads = 16 total threads
    compute<<<2, 8>>>(dA, a);

    // Wait for GPU to finish
    cudaDeviceSynchronize();

    // Copy result back to host
    cudaMemcpy(hA, dA, N * sizeof(int), cudaMemcpyDeviceToHost);

    // Print the result from the host
    for (int i = 0; i < N; ++i) {
        printf("%d ", hA[i]);
    }
    printf("\n");

    // Free device memory
    cudaFree(dA);

    return 0;
}

