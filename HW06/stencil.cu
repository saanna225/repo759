// stencil.cu
#include <cuda_runtime.h>
#include "stencil.cuh"
#include <iostream>
__global__ void stencil_kernel(const float* image, const float* mask, float* output, unsigned int n, unsigned int R) {
    extern __shared__ float shared[];
    float* s_mask = shared;
    float* s_image = &shared[2 * R + 1];

    unsigned int tid = threadIdx.x;
    unsigned int gid = blockIdx.x * blockDim.x + tid;
    unsigned int s_img_idx = tid + R;

    // Load mask into shared memory (done by first 2R+1 threads only)
    if (tid < 2 * R + 1) {
        s_mask[tid] = mask[tid];
    }

    // Load image values including halos
    if (gid < n)
        s_image[s_img_idx] = image[gid];
    else
        s_image[s_img_idx] = 1.0f;

    // Left halo
    if (tid < R) {
        if (gid >= R)
            s_image[s_img_idx - R] = image[gid - R];
        else
            s_image[s_img_idx - R] = 1.0f;
    }

    // Right halo
    if (tid >= blockDim.x - R) {
        if (gid + R < n)
            s_image[s_img_idx + R] = image[gid + R];
        else
            s_image[s_img_idx + R] = 1.0f;
    }

    __syncthreads();

    if (gid < n) {
        float sum = 0.0f;
        for (int j = -R; j <= R; ++j) {
            sum += s_image[s_img_idx + j] * s_mask[j + R];
        }
        output[gid] = sum;
    }
}

void stencil(const float* image, const float* mask, float* output, unsigned int n, unsigned int R, unsigned int threads_per_block) {
    size_t blocks = (n + threads_per_block - 1) / threads_per_block;
    size_t shared_mem_size = ((2 * R + 1 + threads_per_block + 2 * R)) * sizeof(float);
    stencil_kernel<<<blocks, threads_per_block, shared_mem_size>>>(image, mask, output, n, R);

cudaError_t err = cudaGetLastError();
if (err != cudaSuccess) {
    std::cerr << "CUDA Error: " << cudaGetErrorString(err) << std::endl;
}
}
