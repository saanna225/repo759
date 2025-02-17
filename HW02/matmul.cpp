#include "matmul.h"
#include <vector>

using namespace std;

void mmul1(const double* A, const double* B, double* C, const unsigned int n) {
    for ( int i = 0; i < n; i++) {
        for ( int j = 0; j < n; j++) {
            
            for ( int k = 0; k < n; k++) {
                C[i * n + j] += A[i * n + k] * B[k * n + j];// Rows(A) * col(B)
            }
        }
    }
}

void mmul2(const double* A, const double* B, double* C, const unsigned int n) {
    for ( int i = 0; i < n; i++) {
        for ( int k = 0; k < n; k++) {
            for (int j = 0; j < n; j++) {
                C[i * n + j] += A[i * n + k] * B[k * n + j];  
            }
        }
    }
}

void mmul3(const double* A, const double* B, double* C, const unsigned int n) {
    for (int j = 0; j < n; j++) {
        for (int k = 0; k < n; k++) {
            for (int i = 0; i < n; i++) {
                C[i * n + j] += A[i * n + k] * B[k * n + j];
            }
        }
    }
}

void mmul4(const vector<double>& A, const vector<double>& B, double* C, const unsigned int n) {
    for (int i = 0; i < n; i++) {
        for (int j = 0; j < n; j++) {
            for ( int k = 0; k < n; k++) {
                C[i * n + j] += A[i * n + k] * B[k * n + j];
            }
        }
    }
}
