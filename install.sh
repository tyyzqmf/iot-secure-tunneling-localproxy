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

# Main function
main() {
    print_step "AWS IoT Secure Tunneling LocalProxy Installer"
    
    detect_os
    
    # Check if the installation scripts exist
    if [[ ! -f "install_localproxy.sh" ]]; then
        print_error "Could not find install_localproxy.sh. Please make sure you're running this script from the correct directory."
    fi
    
    if [[ "$OS" == "windows" ]]; then
        if [[ ! -f "install_localproxy.ps1" ]]; then
            print_error "Could not find install_localproxy.ps1. Please make sure you're running this script from the correct directory."
        fi
        
        print_step "Running Windows installation script..."
        
        # Check if PowerShell is available
        if command -v powershell &> /dev/null; then
            powershell -ExecutionPolicy Bypass -File ./install_localproxy.ps1
        else
            print_error "PowerShell is not available. Please run install_localproxy.ps1 directly using PowerShell."
        fi
    else
        print_step "Running Unix installation script..."
        
        # Make the script executable if it's not already
        chmod +x ./install_localproxy.sh
        
        # Run the script
        ./install_localproxy.sh
    fi
}

# Run the main function
main
