#include"matmul.h"
#include<omp.h>
#include<vector>
using namespace std;

void mmul(const float* A, const float* B, float* C, const std::size_t n) {
#pragma omp parallel for schedule(static)
    for (int i = 0; i < n; i++) {
        for (int k = 0; k < n; k++) {
            for (int j = 0; j < n; j++) {
                C[i * n + j] += A[i * n + k] * B[k * n + j];
            }
        }
    }
}
   