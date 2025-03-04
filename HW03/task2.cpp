#include <iostream>
#include <vector>
#include <random>
#include <chrono>
#include <omp.h>
#include "convolution.h"

int main(int argc, char* argv[]) {
    if (argc != 3) {
        std::cerr << "Usage: ./task2 <n> <t>" << std::endl;
        return 1;
    }

    std::size_t n = std::stoi(argv[1]); 
    int t = std::stoi(argv[2]); 

    omp_set_num_threads(t); 

    std::vector<float> image(n * n);
    std::vector<float> output(n * n, 0.0f);
    std::vector<float> mask(3 * 3); 

    std::random_device rd;
    std::mt19937 gen(rd());
    std::uniform_real_distribution<float> dist_image(-10.0, 10.0); 
    std::uniform_real_distribution<float> dist_mask(-1.0, 1.0); 

  
    for (std::size_t i = 0; i < n * n; i++) {
        image[i] = dist_image(gen);
    }
    for (std::size_t i = 0; i < 3 * 3; i++) {
        mask[i] = dist_mask(gen);
    }

   
    auto start = std::chrono::high_resolution_clock::now();
    convolve(image.data(), output.data(), n, mask.data(), 3);
    auto stop = std::chrono::high_resolution_clock::now();
    double duration = std::chrono::duration_cast<std::chrono::milliseconds>(stop - start).count();

    std::cout << "First element: " << output[0] << std::endl;
    std::cout << "Last element: " << output[n * n - 1] << std::endl;
    std::cout << "Execution Time: " << duration << " ms" << std::endl;

    return 0;
}
