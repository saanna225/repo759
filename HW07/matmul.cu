#include "matmul.cuh"
#include <cuda.h>
#include <cuda_runtime.h>
#include <iostream>
#include <cstdio>
#include <cmath>

// Integer Matrix Multiplication
__global__ void matmul_1_kernel(const int *A, const int *B, int *C, unsigned int n) {
    extern __shared__ int shared[];
    int* tileA = shared;
    int* tileB = &shared[blockDim.x * blockDim.x];

    int tx = threadIdx.x;
    int ty = threadIdx.y;
    int row = blockIdx.y * blockDim.y + ty;
    int col = blockIdx.x * blockDim.x + tx;

    int sum = 0;

    for (int m = 0; m < (int)n; m += blockDim.x) {
        tileA[ty * blockDim.x + tx] = (row < n && m + tx < n) ? A[row * n + m + tx] : 0;
        tileB[ty * blockDim.x + tx] = (col < n && m + ty < n) ? B[(m + tx) * n + col] : 0;

        __syncthreads();

        for (int k = 0; k < blockDim.x; ++k) {
            sum += tileA[ty * blockDim.x + k] * tileB[k * blockDim.x + tx];
        }

        __syncthreads();
    }

    if (row < n && col < n) {
        C[row * n + col] = sum;
    }
}

__host__ void matmul_1(const int *A, const int *B, int *C, unsigned int n, unsigned int block_dim) {
    dim3 block(block_dim, block_dim);
    dim3 grid((n + block_dim - 1) / block_dim, (n + block_dim - 1) / block_dim);
    size_t shared_mem = 2 * block_dim * block_dim * sizeof(int);
    matmul_1_kernel<<<grid, block, shared_mem>>>(A, B, C, n);
}

// Float Matrix Multiplication
// ===========================
__global__ void matmul_2_kernel(const float *A, const float *B, float *C, unsigned int n) {
    extern __shared__ float shared[];
    float* tileA = shared;
    float* tileB = &shared[blockDim.x * blockDim.x];

    int tx = threadIdx.x;
    int ty = threadIdx.y;
    int row = blockIdx.y * blockDim.y + ty;
    int col = blockIdx.x * blockDim.x + tx;

    float sum = 0.0f;

    for (int m = 0; m < (int)n; m += blockDim.x) {
        tileA[ty * blockDim.x + tx] = (row < n && m + tx < n) ? A[row * n + m + tx] : 0.0f;
        tileB[ty * blockDim.x + tx] = (col < n && m + ty < n) ? B[(m + tx) * n + col] : 0.0f;

        __syncthreads();

        for (int k = 0; k < blockDim.x; ++k) {
            sum += tileA[ty * blockDim.x + k] * tileB[k * blockDim.x + tx];
        }

        __syncthreads();
    }

    if (row < n && col < n) {
        C[row * n + col] = sum;
    }
}

__host__ void matmul_2(const float *A, const float *B, float *C, unsigned int n, unsigned int block_dim) {
    dim3 block(block_dim, block_dim);
    dim3 grid((n + block_dim - 1) / block_dim, (n + block_dim - 1) / block_dim);
    size_t shared_mem = 2 * block_dim * block_dim * sizeof(float);
    matmul_2_kernel<<<grid, block, shared_mem>>>(A, B, C, n);
}


// Double Matrix Multiplication

__global__ void matmul_3_kernel(const double *A, const double *B, double *C, unsigned int n) {
    extern __shared__ double shared[];
    double* tileA = shared;
    double* tileB = &shared[blockDim.x * blockDim.x];

    int tx = threadIdx.x;
    int ty = threadIdx.y;
    int row = blockIdx.y * blockDim.y + ty;
    int col = blockIdx.x * blockDim.x + tx;

    double sum = 0.0;

    for (int m = 0; m < (int)n; m += blockDim.x) {
        tileA[ty * blockDim.x + tx] = (row < n && m + tx < n) ? A[row * n + m + tx] : 0.0;
        tileB[ty * blockDim.x + tx] = (col < n && m + ty < n) ? B[(m + tx) * n + col] : 0.0;

        __syncthreads();

        for (int k = 0; k < blockDim.x; ++k) {
            sum += tileA[ty * blockDim.x + k] * tileB[k * blockDim.x + tx];
        }

        __syncthreads();
    }

    if (row < n && col < n) {
        C[row * n + col] = sum;
    }
}

__host__ void matmul_3(const double *A, const double *B, double *C, unsigned int n, unsigned int block_dim) {
    dim3 block(block_dim, block_dim);
    dim3 grid((n + block_dim - 1) / block_dim, (n + block_dim - 1) / block_dim);
    size_t shared_mem = 2 * block_dim * block_dim * sizeof(double);
    matmul_3_kernel<<<grid, block, shared_mem>>>(A, B, C, n);
    cudaError_t err = cudaGetLastError();
    if (err != cudaSuccess) {
    std::cerr << "CUDA Error in matmul_3_kernel: " << cudaGetErrorString(err) << std::endl;
    return;  
}
   
 }

