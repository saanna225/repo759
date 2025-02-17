#include "convolution.h"
#include <iostream>
#include <cstdlib>
#include <chrono>
#include <random>

using namespace std;
using namespace chrono;

int main(int argc, char* argv[]) {
    
    if (argc != 3) {
        cerr << "Usage: ./task2 <n> <m>" << endl;
        return 1;
    }

    
    size_t n = atol(argv[1]); 
    size_t m = atol(argv[2]); 

   
    if (m % 2 == 0) {
        cerr << "m must be odd and <=n" << endl;
        return 1;
    }

    random_device rd;
    mt19937_64 generator(rd());
    uniform_real_distribution<float> dist(-10.0, 10.0); // Range [-10, 10]

    // dynamic mem allocn
    float* image = new float[n * n];
    float* mask = new float[m * m];
    float* output = new float[n * n];

    for (size_t i = 0; i < n * n; i++) {
        image[i] = dist(generator);
    }

    for (size_t i = 0; i < m * m; i++) {
        mask[i] = dist(generator);
    }

    // convolution time
    auto start = high_resolution_clock::now();
    convolve(image, output, n, mask, m);
    auto end = high_resolution_clock::now();
    auto duration = duration_cast<milliseconds>(end - start);
   
    cout << "First Output Element: " << output[0] << endl;
    cout << "Last Output Element: " << output[n * n - 1] << endl;
    cout << "Execution Time: " << duration.count() << " ms" << endl;

    // Deallocating
    delete[] image;
    delete[] mask;
    delete[] output;

    return 0;
}
