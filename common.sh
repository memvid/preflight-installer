#!/bin/bash
# Common helper functions for install.sh

# Colors for output
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Print success message
print_success() {
    echo -e "${GREEN}✔${NC} $1"
}

# Print error message
print_error() {
    echo -e "${RED}✖${NC} $1"
}

# Print info message
print_info() {
    echo -e "${BLUE}→${NC} $1"
}

# Print warning message
print_warning() {
    echo -e "${YELLOW}⚠${NC} $1"
}
