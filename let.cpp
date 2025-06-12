#include <iostream>
#include <cstdlib>
#include <ctime>

int main() {
    // Seed the random number generator
    srand(time(0));
    
    // Number of letters to print
    int numLetters = 10;
    
    // Generate and print random letters
    for (int i = 0; i < numLetters; i++) {
        // Generate random number between 0 and 25, add to 'a' (97 in ASCII)
        char randomLetter = 'a' + (rand() % 26);
        std::cout << randomLetter << " ";
    }
    
    std::cout << std::endl;
    return 0;
}
