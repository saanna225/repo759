#include <iostream>
#include <random>
#include <cuda_runtime.h>
#include "matmul.cuh"

void fill_random(float* mat, size_t n) {
    std::mt19937 rng(19937);
    std::uniform_real_distribution<float> dist(-1.0f, 1.0f);
    for (size_t i = 0; i < n * n; ++i) {
        mat[i] = dist(rng);
    }
}

int main(int argc, char** argv) {
    if (argc != 3) {
        std::cerr << "Usage: ./task1 n threads_per_block\n";
        return 1;
    }

    size_t n = std::stoi(argv[1]);
    unsigned int threads_per_block = std::stoi(argv[2]);

    size_t num_elements = n * n;
    float *A = new float[num_elements];
    float *B = new float[num_elements];
    float *C = new float[num_elements];

    fill_random(A, n);
    fill_random(B, n);

    cudaEvent_t start, stop;
    cudaEventCreate(&start);
    cudaEventCreate(&stop);

    cudaEventRecord(start);
    matmul(A, B, C, n, threads_per_block);
    cudaEventRecord(stop);
    cudaEventSynchronize(stop);

    float milliseconds = 0;
    cudaEventElapsedTime(&milliseconds, start, stop);

    std::cout << C[num_elements - 1] << std::endl;
    std::cout << milliseconds << std::endl;

    delete[] A;
    delete[] B;
    delete[] C;

    cudaEventDestroy(start);
    cudaEventDestroy(stop);

    return 0;
}

