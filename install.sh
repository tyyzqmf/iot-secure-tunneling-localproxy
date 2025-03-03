#!/bin/bash

# Wrapper script to detect OS and run the appropriate installation script

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Print with color
print_color() {
    local color=$1
    local message=$2
    echo -e "${color}${message}${NC}"
}

# Print step information
print_step() {
    print_color "$BLUE" "==> $1"
}

# Print success message
print_success() {
    print_color "$GREEN" "✓ $1"
}

# Print error message and exit
print_error() {
    print_color "$RED" "✗ $1"
    exit 1
}

# Print warning message
print_warning() {
    print_color "$YELLOW" "! $1"
}

# Detect operating system
detect_os() {
    print_step "Detecting operating system..."
    
    if [[ "$OSTYPE" == "linux-gnu"* ]]; then
        OS="linux"
    elif [[ "$OSTYPE" == "darwin"* ]]; then
        OS="macOS"
    elif [[ "$OSTYPE" == "msys" || "$OSTYPE" == "win32" ]]; then
        OS="windows"
    else
        print_error "Unsupported operating system: $OSTYPE"
    fi
    
    print_success "Detected operating system: $OS"
}

# Parse command line arguments
parse_args() {
    while [[ $# -gt 0 ]]; do
        case "$1" in
            --version=*)
                VERSION="${1#*=}"
                shift
                ;;
            --version)
                VERSION="$2"
                shift 2
                ;;
            *)
                shift
                ;;
        esac
    done
}

# Main function
main() {
    print_step "AWS IoT Secure Tunneling LocalProxy Installer"
    
    # Parse command line arguments
    parse_args "$@"
    
    detect_os
    
# GitHub repository URL
REPO_URL="https://github.com/tyyzqmf/iot-secure-tunneling-localproxy"
BRANCH="main"
RAW_URL="https://raw.githubusercontent.com/tyyzqmf/iot-secure-tunneling-localproxy/$BRANCH"

# Create a temporary directory
TEMP_DIR=$(mktemp -d)
print_step "Created temporary directory: $TEMP_DIR"

# Function to clean up temporary files
cleanup() {
    print_step "Cleaning up temporary files..."
    rm -rf "$TEMP_DIR"
    print_success "Cleanup complete"
}

# Register the cleanup function to be called on exit
trap cleanup EXIT

# Download the installation scripts
download_scripts() {
    print_step "Downloading installation scripts from GitHub..."
    
    if command -v curl &> /dev/null; then
        curl -sSL -o "$TEMP_DIR/install_localproxy.sh" "$RAW_URL/install_localproxy.sh"
        curl -sSL -o "$TEMP_DIR/install_localproxy.ps1" "$RAW_URL/install_localproxy.ps1"
        
        if [[ $? -eq 0 ]]; then
            print_success "Downloaded installation scripts"
        else
            print_error "Failed to download installation scripts"
        fi
    elif command -v wget &> /dev/null; then
        wget -q -O "$TEMP_DIR/install_localproxy.sh" "$RAW_URL/install_localproxy.sh"
        wget -q -O "$TEMP_DIR/install_localproxy.ps1" "$RAW_URL/install_localproxy.ps1"
        
        if [[ $? -eq 0 ]]; then
            print_success "Downloaded installation scripts"
        else
            print_error "Failed to download installation scripts"
        fi
    else
        print_error "Neither curl nor wget found. Please install one of them and try again."
    fi
}

# Download the scripts
download_scripts

if [[ "$OS" == "windows" ]]; then
    print_step "Running Windows installation script..."
    
    # Check if PowerShell is available
    if command -v powershell &> /dev/null; then
        if [[ -n "$VERSION" ]]; then
            powershell -ExecutionPolicy Bypass -Command "& { \$env:VERSION='$VERSION'; & '$TEMP_DIR/install_localproxy.ps1' }"
        else
            powershell -ExecutionPolicy Bypass -File "$TEMP_DIR/install_localproxy.ps1"
        fi
    else
        print_error "PowerShell is not available. Please run install_localproxy.ps1 directly using PowerShell."
    fi
else
    print_step "Running Unix installation script..."
    
    # Make the script executable
    chmod +x "$TEMP_DIR/install_localproxy.sh"
    
    # Run the script with version if specified
    if [[ -n "$VERSION" ]]; then
        VERSION="$VERSION" "$TEMP_DIR/install_localproxy.sh"
    else
        "$TEMP_DIR/install_localproxy.sh"
    fi
fi
}

# Run the main function with all arguments
main "$@"
