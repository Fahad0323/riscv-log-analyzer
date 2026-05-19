#!/bin/bash

echo " RISC-V Environment Setup Check"

# 1. Check grep
if command -v grep > /dev/null; then
    echo "grep: OK"
else
    echo "grep: MISSING"
fi

# 2. Check awk
if command -v awk > /dev/null; then
    echo "awk: OK"
else
    echo "awk: MISSING"
fi

# 3. Check sed
if command -v sed > /dev/null; then
    echo "sed: OK"
else
    echo "sed: MISSING"
fi

echo "Environment Check Completed!"
