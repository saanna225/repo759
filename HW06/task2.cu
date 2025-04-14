#include <iostream>
#include <random>
#include <cuda_runtime.h>
#include "stencil.cuh"
#include <cstdio>
void fill_random(float* array, int length) {
    std::mt19937 gen(19937);
    std::uniform_real_distribution<float> dist(-1.0f, 1.0f);
    for (int i = 0; i < length; ++i) {
        array[i] = dist(gen);
    }
}

int main(int argc, char** argv) {
    if (argc != 4) {
        std::cerr << "Usage: ./task2 n R threads_per_block\n";
        return 1;
    }

    unsigned int n = std::stoi(argv[1]);
    unsigned int R = std::stoi(argv[2]);
    unsigned int threads_per_block = std::stoi(argv[3]);

    size_t image_size = n * sizeof(float);
    size_t output_size = n * sizeof(float);
    size_t mask_size = (2 * R + 1) * sizeof(float);

    float* image = new float[n];
    float* output = new float[n];
    float* mask = new float[2 * R + 1];

    fill_random(image, n);
    fill_random(mask, 2 * R + 1);

    float *d_image, *d_mask, *d_output;
    cudaMalloc(&d_image, image_size);
    cudaMalloc(&d_mask, mask_size);
    cudaMalloc(&d_output, output_size);

    cudaMemcpy(d_image, image, image_size, cudaMemcpyHostToDevice);
    cudaMemcpy(d_mask, mask, mask_size, cudaMemcpyHostToDevice);

    cudaEvent_t start, stop;
    cudaEventCreate(&start);
    cudaEventCreate(&stop);
    cudaEventRecord(start);

    stencil(d_image, d_mask, d_output, n, R, threads_per_block);

    cudaEventRecord(stop);
    cudaEventSynchronize(stop);

    cudaMemcpy(output, d_output, output_size, cudaMemcpyDeviceToHost);

    float milliseconds = 0;
    cudaEventElapsedTime(&milliseconds, start, stop);

    std::cout << output[n - 1] << std::endl;
    std::cout <<"Time: "<< milliseconds << std::endl;

    delete[] image;
    delete[] output;
    delete[] mask;
    cudaFree(d_image);
    cudaFree(d_mask);
    cudaFree(d_output);
    cudaEventDestroy(start);
    cudaEventDestroy(stop);

    return 0;
}

