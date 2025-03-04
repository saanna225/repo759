#include <iostream>
#include <vector>
#include <random>
#include <chrono>
#include <omp.h>
#include "matmul.h"

int main(int argc, char* argv[]) {
    if (argc != 3) {
        std::cerr << "Usage: ./task1 <n> <t>" << std::endl;
        return 1;
    }

    std::size_t n = std::stoi(argv[1]);
    int t = std::stoi(argv[2]);

    omp_set_num_threads(t);  

    std::vector<float> A(n * n), B(n * n), C(n * n, 0.0);

    std::random_device rd;
    std::mt19937 gen(rd());
    std::uniform_real_distribution<float> dist(-1.0, 1.0);

    for (std::size_t i = 0; i < n * n; i++) {
        A[i] = dist(gen);
        B[i] = dist(gen);
    }

    auto start = std::chrono::high_resolution_clock::now();
    mmul(A.data(), B.data(), C.data(), n);
    auto stop = std::chrono::high_resolution_clock::now();

    double duration = std::chrono::duration_cast<std::chrono::milliseconds>(stop - start).count();

    std::cout << "Execution Time: " << duration << " ms" << std::endl;

    return 0;
}







