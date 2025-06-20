#!/bin/bash

# Define the Greek alphabet
greek_alphabet=(Alpha Beta Gamma Delta Epsilon Zeta Eta Theta Iota Kappa Lambda Mu Nu Xi Omicron Pi Rho Sigma Tau Upsilon Phi Chi Psi Omega)

# Output the Greek alphabet
echo "Greek Alphabet:"
for i in "${!greek_alphabet[@]}"; do
  echo "$((i + 1)). ${greek_alphabet[i]}"
done

