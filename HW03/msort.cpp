#include <iostream>
#include <vector>
#include <thread>
#include "msort.h"


void merge(int* arr, int le, int mid, int ri) {
    std::vector<int> temp(ri - le + 1);
    int i = le, j = mid + 1, k = 0;

    while (i <= mid && j <= ri) temp[k++] = (arr[i] <= arr[j]) ? arr[i++] : arr[j++];
    while (i <= mid) temp[k++] = arr[i++];
    while (j <= ri) temp[k++] = arr[j++];

    std::copy(temp.begin(), temp.end(), arr + le);
}
void mergeSort(int* arr, int le, int ri, std::size_t threshold) {
    if (le >= ri) return;

    int mid = le + (ri - le) / 2;

    if ((ri - le) > threshold) {  
        std::thread leftThread(mergeSort, arr, le, mid, threshold);
        mergeSort(arr, mid + 1, ri, threshold);
        leftThread.join();
    }
    else {
        mergeSort(arr, le, mid, threshold);
        mergeSort(arr, mid + 1, ri, threshold);
    }

    merge(arr, le, mid, ri);
}
//main
void msort(int* arr, const std::size_t n, const std::size_t threshold) {
    if (n > 1) mergeSort(arr, 0, n - 1, threshold);
}
