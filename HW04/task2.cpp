#include <cstddef>
#include <iostream>
#include <fstream>  
#include <cmath>
#include <cstdlib>  
#include <ctime>   
#include <chrono>
#include <random>

using std::chrono::high_resolution_clock;
using std::chrono::duration;

// Constants
const double G = 1.0;          // Gravitational constant
const double softening = 0.1;  // Softening length
const double dt = 0.01;        // Time step
const double board_size = 4.0; // Size of the board

// Function to calculate acceleration due to gravity
void getAcc(const double pos[][3], const double mass[], double acc[][3], int N) {
    for (int i = 0; i < N; i++) {
        acc[i][0] = 0.0;
        acc[i][1] = 0.0;
        acc[i][2] = 0.0;
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
}

// Function to save positions to a CSV file
void savePositionsToCSV(const double pos[][3], int N, int step, const std::string& filename) {
    std::ofstream file;
    file.open(filename, std::ios_base::app);

    if (file.is_open()) {
        file << step << ",[";
        for (int i = 0; i < N; i++) {
            if (i != N - 1)
                file << "[" << pos[i][0] << "," << pos[i][1] << "," << pos[i][2] << "],";
            else
                file << "[" << pos[i][0] << "," << pos[i][1] << "," << pos[i][2] << "]";
        }
        file << "]\n";
        file.close();
    }
    else {
        std::cerr << "Unable to open file!" << std::endl;
    }
}

int main(int argc, char* argv[]) {
    high_resolution_clock::time_point start = high_resolution_clock::now();

    if (argc != 3) {
        std::cerr << "Usage: " << argv[0] << " <number_of_particles> <simulation_end_time>" << std::endl;
        return 1;
    }

    int N = std::stoi(argv[1]);
    double tEnd = std::stod(argv[2]);

    std::string filename = "positions.csv";
    std::ofstream file;
    file.open(filename, std::ofstream::out | std::ofstream::trunc);
    file.close();

    double* mass = new double[N];
    double(*pos)[3] = new double[N][3];
    double(*vel)[3] = new double[N][3];
    double(*acc)[3] = new double[N][3];

    std::mt19937 generator(std::random_device{}());
    std::uniform_real_distribution<double> uniform_dist(0.0, 1.0);
    std::normal_distribution<double> normal_dist(0.0, 1.0);

    double t = 0.0;

    for (int i = 0; i < N; i++) {
        mass[i] = uniform_dist(generator);
        pos[i][0] = normal_dist(generator);
        pos[i][1] = normal_dist(generator);
        pos[i][2] = normal_dist(generator);
        vel[i][0] = normal_dist(generator);
        vel[i][1] = normal_dist(generator);
        vel[i][2] = normal_dist(generator);
    }

    double velCM[3] = { 0.0, 0.0, 0.0 };
    double totalMass = 0.0;
    for (int i = 0; i < N; i++) {
        velCM[0] += vel[i][0] * mass[i];
        velCM[1] += vel[i][1] * mass[i];
        velCM[2] += vel[i][2] * mass[i];
        totalMass += mass[i];
    }

    velCM[0] /= totalMass;
    velCM[1] /= totalMass;
    velCM[2] /= totalMass;

    for (int i = 0; i < N; i++) {
        vel[i][0] -= velCM[0];
        vel[i][1] -= velCM[1];
        vel[i][2] -= velCM[2];
    }

    getAcc(pos, mass, acc, N);
    int Nt = int(tEnd / dt);

    for (int step = 0; step < Nt; step++) {
        // (1/2) kick: Update velocity by half-step using current acceleration
        for (int i = 0; i < N; i++) {
            vel[i][0] += acc[i][0] * dt / 2.0;
            vel[i][1] += acc[i][1] * dt / 2.0;
            vel[i][2] += acc[i][2] * dt / 2.0;
        }

        // Drift: Update position using velocity
        for (int i = 0; i < N; i++) {
            pos[i][0] += vel[i][0] * dt;
            pos[i][1] += vel[i][1] * dt;
            pos[i][2] += vel[i][2] * dt;
        }

        // Ensure particles stay within the board limits
        for (int i = 0; i < N; i++) {
            if (pos[i][0] > board_size) pos[i][0] = board_size;
            if (pos[i][0] < -board_size) pos[i][0] = -board_size;
            if (pos[i][1] > board_size) pos[i][1] = board_size;
            if (pos[i][1] < -board_size) pos[i][1] = -board_size;
            if (pos[i][2] > board_size) pos[i][2] = board_size;
            if (pos[i][2] < -board_size) pos[i][2] = -board_size;
        }

        
        getAcc(pos, mass, acc, N);

        // (1/2) kick
        for (int i = 0; i < N; i++) {
            vel[i][0] += acc[i][0] * dt / 2.0;
            vel[i][1] += acc[i][1] * dt / 2.0;
            vel[i][2] += acc[i][2] * dt / 2.0;
        }
        t += dt;

        savePositionsToCSV(pos, N, step, filename);
    }

    delete[] mass;
    delete[] pos;
    delete[] vel;
    delete[] acc;

    high_resolution_clock::time_point end = high_resolution_clock::now();
    duration<double, std::milli> duration_sec = std::chrono::duration_cast<duration<double, std::milli>>(end - start);
    std::cout << "Simulation completed in " << duration_sec.count() << " ms.\n";

    return 0;
}
