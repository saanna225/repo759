#include <iostream>

int main(int argc, char* argv[]) {
    int N;
    std::cout << "Enter N: ";
    std::cin >> N;

    for (int i = 0; i <= N; i++)
        std::cout << i << " ";
    std::cout << "\n";

    for (int i = N; i >= 0; i--)
        std::cout << i << " ";
    std::cout << "\n";
    
    std::cin.get(); 
    return 0;
}


