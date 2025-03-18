#include <iostream>
#include <fstream>
#include <cmath>
#include <cstdlib>
#include <chrono>
#include <omp.h>
#include <string>

using namespace std;
using namespace chrono;

// Constants
const double G = 1.0;          // Gravitational constant
const double softening = 0.1;  // Softening length
const double dt = 0.01;        // Time step

// Function to compute acceleration using Newton's law of gravity
void getAcc(int N, double pos[][3], double mass[], double acc[][3], string schedule_type, int num_threads) {
    
    // **Ensure acceleration starts at zero**
    #pragma omp parallel for num_threads(num_threads)
    for (int i = 0; i < N; i++) {
        acc[i][0] = 0.0;
        acc[i][1] = 0.0;
        acc[i][2] = 0.0;
    }

    // **Parallelize force calculation with chosen scheduling**
    if (schedule_type == "static") {
        #pragma omp parallel for schedule(static) num_threads(num_threads)
        for (int i = 0; i < N; i++) {
            for (int j = 0; j < N; j++) {
                if (i != j) {
                    double dx = pos[j][0] - pos[i][0];
                    double dy = pos[j][1] - pos[i][1];
                    double dz = pos[j][2] - pos[i][2];
                    double r2 = dx * dx + dy * dy + dz * dz + softening * softening;
                    double inv_r3 = pow(r2, -1.5);

                    acc[i][0] += G * dx * inv_r3 * mass[j];
                    acc[i][1] += G * dy * inv_r3 * mass[j];
                    acc[i][2] += G * dz * inv_r3 * mass[j];
                }
            }
        }
    } else if (schedule_type == "dynamic") {
        #pragma omp parallel for schedule(dynamic) num_threads(num_threads)
        for (int i = 0; i < N; i++) {
            for (int j = 0; j < N; j++) {
                if (i != j) {
                    double dx = pos[j][0] - pos[i][0];
                    double dy = pos[j][1] - pos[i][1];
                    double dz = pos[j][2] - pos[i][2];
                    double r2 = dx * dx + dy * dy + dz * dz + softening * softening;
                    double inv_r3 = pow(r2, -1.5);

                    acc[i][0] += G * dx * inv_r3 * mass[j];
                    acc[i][1] += G * dy * inv_r3 * mass[j];
                    acc[i][2] += G * dz * inv_r3 * mass[j];
                }
            }
        }
    } else if (schedule_type == "guided") {
        #pragma omp parallel for schedule(guided) num_threads(num_threads)
        for (int i = 0; i < N; i++) {
            for (int j = 0; j < N; j++) {
                if (i != j) {
                    double dx = pos[j][0] - pos[i][0];
                    double dy = pos[j][1] - pos[i][1];
                    double dz = pos[j][2] - pos[i][2];
                    double r2 = dx * dx + dy * dy + dz * dz + softening * softening;
                    double inv_r3 = pow(r2, -1.5);

                    acc[i][0] += G * dx * inv_r3 * mass[j];
                    acc[i][1] += G * dy * inv_r3 * mass[j];
                    acc[i][2] += G * dz * inv_r3 * mass[j];
                }
            }
        }
    } else {
        cerr << "Invalid scheduling type! Use static, dynamic, or guided." << endl;
        exit(1);
    }
}

int main(int argc, char *argv[]) {
    if (argc != 5) {
        cerr << "Usage: " << argv[0] << " <num_particles> <simulation_time> <num_threads> <schedule_type>" << endl;
        return 1;
    }

    // Read input parameters
    int N = stoi(argv[1]);          // Number of particles
    double tEnd = stod(argv[2]);    // Simulation end time
    int num_threads = stoi(argv[3]); // Number of threads
    string schedule_type = argv[4]; // Scheduling type

    // Allocate memory dynamically
    double *mass = new double[N];
    double (*pos)[3] = new double[N][3];
    double (*vel)[3] = new double[N][3];
    double (*acc)[3] = new double[N][3];

    // Initialize random positions and velocities
    srand(42);
    for (int i = 0; i < N; i++) {
        mass[i] = 1.0 + static_cast<double>(rand()) / RAND_MAX;
        pos[i][0] = 2.0 * (rand() / (double)RAND_MAX) - 1.0;
        pos[i][1] = 2.0 * (rand() / (double)RAND_MAX) - 1.0;
        pos[i][2] = 2.0 * (rand() / (double)RAND_MAX) - 1.0;
        vel[i][0] = 0.0;
        vel[i][1] = 0.0;
        vel[i][2] = 0.0;
    }

    // Compute initial acceleration
    getAcc(N, pos, mass, acc, schedule_type, num_threads);

    auto start = high_resolution_clock::now(); // Start timing

    // **Main simulation loop**
    for (double t = 0; t < tEnd; t += dt) {

        // **(1/2) Kick: Update velocity using half of acceleration**
        #pragma omp parallel for num_threads(num_threads)
        for (int i = 0; i < N; i++) {
            vel[i][0] += acc[i][0] * dt / 2.0;
            vel[i][1] += acc[i][1] * dt / 2.0;
            vel[i][2] += acc[i][2] * dt / 2.0;
        }

        // **Drift: Update position using full velocity step**
        #pragma omp parallel for num_threads(num_threads)
        for (int i = 0; i < N; i++) {
            pos[i][0] += vel[i][0] * dt;
            pos[i][1] += vel[i][1] * dt;
            pos[i][2] += vel[i][2] * dt;
        }

        // **Compute new acceleration after drift**
        getAcc(N, pos, mass, acc, schedule_type, num_threads);

        // **(1/2) Kick: Update velocity again using new acceleration**
        #pragma omp parallel for num_threads(num_threads)
        for (int i = 0; i < N; i++) {
            vel[i][0] += acc[i][0] * dt / 2.0;
            vel[i][1] += acc[i][1] * dt / 2.0;
            vel[i][2] += acc[i][2] * dt / 2.0;
        }
    }

    auto end = high_resolution_clock::now(); // Stop timing
    duration<double, std::milli> elapsed = end - start;

    // **Save results to file**
    ofstream results("task3.out", ios::app);
    results << schedule_type << "," << N << "," << tEnd << "," << num_threads << "," << elapsed.count() << "\n";
    results.close();

    cout << "Completed in " << elapsed.count() << " ms using " << num_threads << " threads (" << schedule_type << " scheduling)" << endl;

    // Free allocated memory
    delete[] mass;
    delete[] pos;
    delete[] vel;
    delete[] acc;

    return 0;
}

