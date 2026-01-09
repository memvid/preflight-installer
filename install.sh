#!/bin/bash
# Memvid Installer for macOS and Linux
# v1 - System package managers only, install-if-missing

set -e

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

# Detect OS
detect_os() {
    if [[ "$OSTYPE" == "darwin"* ]]; then
        OS="macos"
        PKG_MANAGER="brew"
    elif [[ -f /etc/os-release ]]; then
        . /etc/os-release
        if [[ "$ID" == "ubuntu" ]] || [[ "$ID" == "debian" ]]; then
            OS="linux"
            PKG_MANAGER="apt"
        else
            print_error "Unsupported Linux distribution: $ID"
            print_info "v1 supports Ubuntu and Debian only"
            exit 1
        fi
    else
        print_error "Unable to detect operating system"
        exit 1
    fi
    
    print_info "Detected OS: $OS"
}

# Check if command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Check for git
check_git() {
    if command_exists git; then
        GIT_VERSION=$(git --version | cut -d' ' -f3)
        print_success "git already installed (version $GIT_VERSION)"
        return 0
    else
        print_error "git not found"
        return 1
    fi
}

# Check for node
check_node() {
    if command_exists node; then
        NODE_VERSION=$(node --version)
        print_success "node already installed ($NODE_VERSION)"
        
        # Check if it's LTS (rough check - version should be even major version)
        MAJOR_VERSION=$(echo "$NODE_VERSION" | cut -d'v' -f2 | cut -d'.' -f1)
        if [ "$((MAJOR_VERSION % 2))" -eq 0 ]; then
            print_info "Node version appears to be LTS-compatible"
        fi
        
        # Check for npm
        if command_exists npm; then
            NPM_VERSION=$(npm --version)
            print_success "npm already installed (version $NPM_VERSION)"
            return 0
        else
            print_error "npm not found (should come with node)"
            return 1
        fi
    else
        print_error "node not found"
        return 1
    fi
}

# Install git
install_git() {
    print_info "Installing git using $PKG_MANAGER..."
    
    if [[ "$OS" == "macos" ]]; then
        brew install git
    elif [[ "$OS" == "linux" ]]; then
        sudo apt-get update
        sudo apt-get install -y git
    fi
    
    if command_exists git; then
        print_success "git installed successfully"
    else
        print_error "git installation failed"
        exit 1
    fi
}

# Install node (LTS)
install_node() {
    print_info "Installing node (LTS) using $PKG_MANAGER..."
    
    if [[ "$OS" == "macos" ]]; then
        brew install node@lts
        # Add to PATH if needed
        if ! command_exists node; then
            print_info "Adding node to PATH..."
            echo 'export PATH="/opt/homebrew/opt/node@lts/bin:$PATH"' >> ~/.zshrc
            export PATH="/opt/homebrew/opt/node@lts/bin:$PATH"
        fi
    elif [[ "$OS" == "linux" ]]; then
        # Install Node.js LTS from NodeSource
        curl -fsSL https://deb.nodesource.com/setup_lts.x | sudo -E bash -
        sudo apt-get install -y nodejs
    fi
    
    if command_exists node && command_exists npm; then
        NODE_VERSION=$(node --version)
        NPM_VERSION=$(npm --version)
        print_success "node installed successfully ($NODE_VERSION)"
        print_success "npm installed successfully (version $NPM_VERSION)"
    else
        print_error "node installation failed"
        exit 1
    fi
}

# Install missing tools
install_missing() {
    NEEDS_GIT=false
    NEEDS_NODE=false
    
    if ! check_git; then
        NEEDS_GIT=true
    fi
    
    if ! check_node; then
        NEEDS_NODE=true
    fi
    
    if [[ "$NEEDS_GIT" == false ]] && [[ "$NEEDS_NODE" == false ]]; then
        print_info "All dependencies are already installed"
        return 0
    fi
    
    # Show what will be installed
    echo ""
    print_warning "The following tools will be installed:"
    [[ "$NEEDS_GIT" == true ]] && echo "  - git"
    [[ "$NEEDS_NODE" == true ]] && echo "  - node (LTS)"
    echo ""
    
    # Ask for confirmation
    read -p "Continue? [Y/n] " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]] && [[ ! $REPLY == "" ]]; then
        print_info "Installation cancelled"
        exit 0
    fi
    
    # Install missing tools
    [[ "$NEEDS_GIT" == true ]] && install_git
    [[ "$NEEDS_NODE" == true ]] && install_node
}

# Install memvid
install_memvid() {
    print_info "Installing memvid globally..."
    
    if npm install -g memvid-cli@latest; then
        print_success "memvid installed successfully"
    else
        print_error "memvid installation failed"
        exit 1
    fi
}

# Verify installation
verify() {
    print_info "Verifying installation..."
    
    if command_exists memvid; then
        MEMVID_VERSION=$(memvid --version 2>/dev/null || echo "unknown")
        print_success "memvid is installed and accessible"
        print_info "Version: $MEMVID_VERSION"
        echo ""
        print_success "Installation complete! You can now use 'memvid' command."
    else
        print_error "memvid verification failed"
        print_info "The installation may have completed, but 'memvid' command is not in PATH"
        print_info "Please check your npm global bin directory and add it to PATH if needed"
        print_info "Or try: npm list -g memvid-cli"
        exit 1
    fi
}

# Main execution
main() {
    echo "=========================================="
    echo "  Memvid Installer v1"
    echo "=========================================="
    echo ""
    
    detect_os
    echo ""
    
    install_missing
    echo ""
    
    install_memvid
    echo ""
    
    verify
}

# Run main function
main
