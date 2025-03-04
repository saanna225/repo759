#include "convolution.h"
#include <vector>


using namespace std;

void convolve(const float* image, float* output, std::size_t n, const float* mask, std::size_t m)
{
    int offset = m / 2;

    //  result matrix
    for (int i = 0; i < n * n; i++) {
        output[i] = 0.0f;
    }

    // Convolution matrix
    for (int x = 0; x < n; x++) {
        for (int y = 0; y < n; y++) {
            float sum = 0.0f;

            for (int i = 0; i < m; i++) {
                for (int j = 0; j < m; j++) {
                    int img_x = x + i - offset;
                    int img_y = y + j - offset;

                    
                    if (img_x >= 0 && img_x < n && img_y >= 0 && img_y < n) {
                        sum += mask[i * m + j] * image[img_x * n + img_y];
                    }
                }
            }

            output[x * n + y] = sum;
        }
    }
}
