#include <iostream>
#include <cstdlib>
#include <ctime>
#include <chrono>
#include "scan.h"

using namespace std;
using namespace chrono;

int main(int argc, char* argv[]) {
    if (argc != 2) {
        cerr << "Usage: ./task1 n" << endl;
        return 1;
    }

    int n = atoi(argv[1]);  // Read `n` from command line
    if (n <= 0) {
        cerr << "Error: n must be a positive integer." << endl;
        return 1;
    }

    // Allocate memory for array
    int* arr = new int[n];

    // Initialize random seed
    srand(time(0));

    // Generate random numbers between -1.0 and 1.0
    for (int i = 0; i < n; i++) {
        arr[i] = (int(rand()) / RAND_MAX) * 4.0f - 1.0f;
    }

    // Measure time before calling scan
    auto start = high_resolution_clock::now();

    // Perform inclusive scan
    scan(arr, n);

    // Measure time after calling scan
    auto stop = high_resolution_clock::now();
    auto duration = duration_cast<milliseconds>(stop - start);

    // Print results
    cout << duration.count() << endl;
    cout << arr[0] << endl;
    cout << arr[n - 1] << endl;

    // Free memory
    delete[] arr;

    return 0;
}


