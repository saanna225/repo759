#include <iostream>
#include <random>
#include <cuda.h>
#include "matmul.cuh"
__global__ void warmup() {}

int main(int argc, char* argv[]) {
    if (argc != 3) {
        std::cerr << "Usage: ./main_alt <matrix_dim> <block_dim>\n";
        return EXIT_FAILURE;
    }

    int n = std::atoi(argv[1]);
    int block_dim = std::atoi(argv[2]);
    size_t total = static_cast<size_t>(n) * n;

    std::mt19937 rng(std::random_device{}());

    // Host matrices
    int* hA_i = new int[total], *hB_i = new int[total], *hC_i = new int[total];
    float* hA_f = new float[total], *hB_f = new float[total], *hC_f = new float[total];
    double* hA_d = new double[total], *hB_d = new double[total], *hC_d = new double[total];

    initialize_matrix(hA_i, total, rng);
    initialize_matrix(hB_i, total, rng);
    initialize_matrix(hA_f, total, rng);
    initialize_matrix(hB_f, total, rng);
    initialize_matrix(hA_d, total, rng);
    initialize_matrix(hB_d, total, rng);

    // Device matrices
    int *dA_i, *dB_i, *dC_i;
    float *dA_f, *dB_f, *dC_f;
    double *dA_d, *dB_d, *dC_d;

    allocate_and_copy(dA_i, dB_i, dC_i, hA_i, hB_i, total);
    allocate_and_copy(dA_f, dB_f, dC_f, hA_f, hB_f, total);
    allocate_and_copy(dA_d, dB_d, dC_d, hA_d, hB_d, total);

    warmup<<<1,1>>>();

    cudaEvent_t start, stop;
    cudaEventCreate(&start);
    cudaEventCreate(&stop);

    float t_i = 0, t_f = 0, t_d = 0;

    cudaEventRecord(start);
    matmul_1(dA_i, dB_i, dC_i, n, block_dim);
    cudaEventRecord(stop);
    cudaEventSynchronize(stop);
    copy_output(hC_i, dC_i, total);
    cudaEventElapsedTime(&t_i, start, stop);

    cudaEventRecord(start);
    matmul_2(dA_f, dB_f, dC_f, n, block_dim);
    cudaEventRecord(stop);
    cudaEventSynchronize(stop);
    copy_output(hC_f, dC_f, total);
    cudaEventElapsedTime(&t_f, start, stop);

    cudaEventRecord(start);
    matmul_3(dA_d, dB_d, dC_d, n, block_dim);
    cudaEventRecord(stop);
    cudaEventSynchronize(stop);
    copy_output(hC_d, dC_d, total);
    cudaEventElapsedTime(&t_d, start, stop);

    std::cout << "INT    : " << hC_i[0] << " " << hC_i[total - 1] << " | Time: " << t_i << " ms\n";
    std::cout << "FLOAT  : " << hC_f[0] << " " << hC_f[total - 1] << " | Time: " << t_f << " ms\n";
    std::cout << "DOUBLE : " << hC_d[0] << " " << hC_d[total - 1] << " | Time: " << t_d << " ms\n";

    free_device_memory(dA_i, dB_i, dC_i);
    free_device_memory(dA_f, dB_f, dC_f);
    free_device_memory(dA_d, dB_d, dC_d);

    delete[] hA_i; delete[] hB_i; delete[] hC_i;
    delete[] hA_f; delete[] hB_f; delete[] hC_f;
    delete[] hA_d; delete[] hB_d; delete[] hC_d;

    return 0;
}

