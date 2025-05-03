#include "reduce.cuh"
#include <cuda.h>
#include <cuda_runtime.h>
#include <iostream>
#include <cmath>

// CUDA kernel for reduction using first-add during global load
__global__ void reduce_kernel(float *data_in, float *data_out, unsigned int total_elems) {
    extern __shared__ float shared_block[];
    unsigned int tid = threadIdx.x;
    unsigned int global_idx = blockIdx.x * (blockDim.x * 2) + tid;

    // Load elements into shared memory with partial reduction if valid
    if (global_idx + blockDim.x < total_elems) {
        shared_block[tid] = data_in[global_idx] + data_in[global_idx + blockDim.x];
    } else if (global_idx < total_elems) {
        shared_block[tid] = data_in[global_idx];
    } else {
        shared_block[tid] = 0.0f;
    }

    __syncthreads();

    // In-place reduction in shared memory
    for (unsigned int stride = blockDim.x / 2; stride > 0; stride >>= 1) {
        if (tid < stride) {
            shared_block[tid] += shared_block[tid + stride];
        }
        __syncthreads();
    }

    // Write block's result to global memory
    if (tid == 0) {
        data_out[blockIdx.x] = shared_block[0];
    }
}

// Host function that repeatedly invokes the reduction kernel until one value remains
__host__ void reduce(float **input, float **output, unsigned int N, unsigned int threads_per_block) {
    unsigned int current_size = N;

    while (current_size > 1) {
        // Calculate how many blocks are needed for the current size
        unsigned int block_count = (current_size + threads_per_block * 2 - 1) / (threads_per_block * 2);

        // Launch kernel with dynamic shared memory
        reduce_kernel<<<block_count, threads_per_block, threads_per_block * sizeof(float)>>>(*input, *output, current_size);

        // Synchronize to ensure kernel completion before next iteration
        cudaDeviceSynchronize();

        // Swap input and output for next pass
        *input = *output;
        current_size = block_count;

        // Uncomment to debug intermediate result:
        // float temp_sum;
        // cudaMemcpy(&temp_sum, *input, sizeof(float), cudaMemcpyDeviceToHost);
        // printf("Partial sum: %f\n", temp_sum);
    }

    // Final result is now stored at output[0]
    *input = *output;
}

