#include <iostream>
#include <vector>
#include <random>
#include <chrono>
#include <omp.h>
#include "msort.h"

int main(int argc, char* argv[]) {
    if (argc != 4) {
        std::cerr << "Usage: ./task3 <n> <t> <ts>" << std::endl;
        return 1;
    }
    std::size_t n = std::atoi(argv[1]);
    std::size_t t = std::atoi(argv[2]);
    std::size_t ts = std::atoi(argv[3]);

    std::random_device rd;
    std::mt19937 gen(rd());
    std::uniform_int_distribution<int> dist(-1000, 1000);

    std::vector<int> arr(n);
    for (std::size_t i = 0; i < n; ++i) {
        arr[i] = dist(gen);
    }
    auto start_time = std::chrono::high_resolution_clock::now();

    msort(arr.data(), n, ts);

    auto end_time = std::chrono::high_resolution_clock::now();
    std::chrono::duration<double, std::milli> elapsed_time = end_time - start_time;
    std::cout << "First element: " << arr.front() << std::endl;
    std::cout << "Last element: " << arr.back() << std::endl;
    std::cout << "Time taken: " << elapsed_time.count() << " ms" << std::endl;

    return 0;
}