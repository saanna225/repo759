#include <cstdio>

__device__ int factorial(int n) {
  int res = 1;
  for (int i = 2; i <= n; ++i)
    res *= i;
  return res;
}

__global__ void compute_factorials() {
  int tid = threadIdx.x; // Only 1 block, so no need for blockIdx
  int num = tid + 1;     // Number range: 1 to 8
  int fact = factorial(num);
  printf("%d!=%d\n", num, fact);
}

int main() {
  compute_factorials<<<1, 8>>>();
  cudaDeviceSynchronize(); // Ensure all printf results are flushed
  return 0;
}
