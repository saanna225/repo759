#include <iostream>
#include <vector>
#include <chrono>
#include <random>
#include "matmul.h"

using namespace std;
using namespace chrono;


void randMatrix(double* matrix, unsigned int n) {
    random_device rd;
    mt19937_64 generator(rd());
    uniform_real_distribution<double> dist(-1.0, 1.0);

    for ( int i = 0; i < n * n; i++) {
        matrix[i] = dist(generator);
    }
}

int main() {
    const int n = 1024; //size for (1000x1000)
    cout << n << endl; 
    
    double* A = new double[n * n];
    double* B = new double[n * n];
    double* C = new double[n * n];

    randMatrix(A, n);
    randMatrix(B, n);

   
    for (int i = 0; i < 3; i++) {
        for (int j = 0; j < n * n; j++) {
            C[j] = 0.0;
        }

        auto start = high_resolution_clock::now();
        if (i == 0) mmul1(A, B, C, n);
        else if (i == 1) mmul2(A, B, C, n);
        else if (i == 2) mmul3(A, B, C, n);
        auto end = high_resolution_clock::now();

        // Calculating time 
        auto duration = duration_cast<milliseconds>(end - start);

        cout << duration.count() << endl;
        cout << C[n * n - 1] << endl;
    }
    vector<double> A_vec(A, A + n * n);
    vector<double> B_vec(B, B + n * n);
    vector<double> C_vec(n * n, 0.0);  

    auto start = high_resolution_clock::now();
    mmul4(A_vec, B_vec, C_vec.data(), n);
    auto end = high_resolution_clock::now();

    auto duration = duration_cast<milliseconds>(end - start);
    cout << duration.count() << endl;
    cout << C_vec[n * n - 1] << endl;

    // Free memory
    delete[] A;
    delete[] B;
    delete[] C;

    return 0;
}
