
#include <cuda_runtime.h>
#include "matmul.cuh"
#include<cstdio>

__global__ void matmul_kernel(const float* A, const float* B, float* C, size_t n) {
    int tid = blockIdx.x * blockDim.x + threadIdx.x;
    if (tid >= n * n) return;

    int row = tid / n;
    int col = tid % n;

    float sum = 0.0f;
    for (int k = 0; k < n; ++k) {
        sum += A[row * n + k] * B[k * n + col];
    }
    C[row * n + col] = sum;
}

void matmul(const float* A, const float* B, float* C, size_t n, unsigned int threads_per_block) {
    size_t num_elements = n * n;
    size_t bytes = num_elements * sizeof(float);

    float *d_A, *d_B, *d_C;
    cudaMalloc(&d_A, bytes);
    cudaMalloc(&d_B, bytes);
    cudaMalloc(&d_C, bytes);

    cudaMemcpy(d_A, A, bytes, cudaMemcpyHostToDevice);
    cudaMemcpy(d_B, B, bytes, cudaMemcpyHostToDevice);

    size_t blocks = (num_elements + threads_per_block - 1) / threads_per_block;
    matmul_kernel<<<blocks, threads_per_block>>>(d_A, d_B, d_C, n);
    cudaError_t err = cudaGetLastError();
    if (err != cudaSuccess) {
    printf("CUDA Error: %s\n", cudaGetErrorString(err));
}

    cudaMemcpy(C, d_C, bytes, cudaMemcpyDeviceToHost);

    cudaFree(d_A);
    cudaFree(d_B);
    cudaFree(d_C);
}

