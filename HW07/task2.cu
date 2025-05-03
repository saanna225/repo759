#include <iostream>
#include <random>
#include <cuda.h>
#include "reduce.cuh"

int main(int argc, char* argv[]) {
    if (argc < 3) {
        std::cerr << "Usage: ./reduce <num_elements> <threads_per_block>\n";
        return 1;
    }

    // Timing setup
    cudaEvent_t start_event, stop_event;
    float elapsed_ms = 0.0f;
    cudaEventCreate(&start_event);
    cudaEventCreate(&stop_event);

    // Parse inputs
    int total_elements = std::atoi(argv[1]);
    int threads_per_block = std::atoi(argv[2]);

    // Generate random input values
    std::vector<float> host_input(total_elements);
    std::mt19937_64 rng(std::random_device{}());
    std::uniform_real_distribution<float> dist(-1.0f, 1.0f);
    for (int i = 0; i < total_elements; ++i) {
        host_input[i] = dist(rng);
    }

    // Device pointers
    float *device_input = nullptr;
    float *device_output = nullptr;

    // Allocate and copy input to device
    cudaMalloc(&device_input, total_elements * sizeof(float));
    cudaMemcpy(device_input, host_input.data(), total_elements * sizeof(float), cudaMemcpyHostToDevice);

    // Allocate output buffer (initial size = number of blocks in first launch)
    unsigned int first_pass_blocks = (total_elements + threads_per_block * 2 - 1) / (threads_per_block * 2);
    cudaMalloc(&device_output, first_pass_blocks * sizeof(float));

    // Launch reduction
    cudaEventRecord(start_event);
    reduce(&device_input, &device_output, total_elements, threads_per_block);
    cudaEventRecord(stop_event);
    cudaEventSynchronize(stop_event);

    // Copy final result
    float result_sum = 0.0f;
    cudaMemcpy(&result_sum, device_input, sizeof(float), cudaMemcpyDeviceToHost);
    cudaEventElapsedTime(&elapsed_ms, start_event, stop_event);

    // Output result
    std::cout << "Reduced sum: " << result_sum << "\n";
    std::cout << "Time Elapsed: " << elapsed_ms << " ms\n\n";

    // Cleanup
    cudaFree(device_input);
    cudaFree(device_output);
    return 0;
}
