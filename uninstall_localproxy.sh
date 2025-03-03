#!/bin/bash

# Script to uninstall AWS IoT Secure Tunneling localproxy
# This script removes the binary, installation directory, symbolic link,
# and cleans up environment variables

set -e

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

# Remove symbolic link
remove_symlink() {
    print_step "Removing symbolic link..."
    
    if [[ -L "$HOME/bin/localproxy" ]]; then
        rm -f "$HOME/bin/localproxy"
        print_success "Removed symbolic link from $HOME/bin"
    else
        print_warning "Symbolic link not found in $HOME/bin"
    fi
}

# Remove installation directory
remove_install_dir() {
    print_step "Removing installation directory..."
    
    INSTALL_DIR="$HOME/.aws-iot-localproxy"
    
    if [[ -d "$INSTALL_DIR" ]]; then
        rm -rf "$INSTALL_DIR"
        print_success "Removed installation directory: $INSTALL_DIR"
    else
        print_warning "Installation directory not found: $INSTALL_DIR"
    fi
}

# Clean up environment variables
cleanup_env_vars() {
    print_step "Cleaning up environment variables..."
    
    if [[ "$OS" == "windows" ]]; then
        print_warning "Environment variables cleanup not needed on Windows"
        return
    fi
    
    local shell_config=""
    
    if [[ -n "$ZSH_VERSION" ]]; then
        shell_config="$HOME/.zshrc"
    elif [[ -n "$BASH_VERSION" ]]; then
        if [[ "$OS" == "macOS" ]]; then
            shell_config="$HOME/.bash_profile"
        else
            shell_config="$HOME/.bashrc"
        fi
    else
        # Default to .profile for other shells
        shell_config="$HOME/.profile"
    fi
    
    if [[ -f "$shell_config" ]]; then
        # Remove the AWS IoT Secure Tunneling localproxy lines from the shell config
        sed -i.bak '/# AWS IoT Secure Tunneling localproxy/d' "$shell_config"
        sed -i.bak '/export PATH="\$HOME\/bin:\$PATH"/d' "$shell_config"
        
        # Remove the backup file
        rm -f "${shell_config}.bak"
        
        print_success "Cleaned up environment variables in $shell_config"
        print_warning "Please run 'source $shell_config' or restart your terminal to apply changes"
    else
        print_warning "Shell configuration file not found: $shell_config"
    fi
}

# Main function
main() {
    print_step "Starting AWS IoT Secure Tunneling localproxy uninstallation..."
    
    detect_os
    remove_symlink
    remove_install_dir
    cleanup_env_vars
    
    print_success "AWS IoT Secure Tunneling localproxy uninstalled successfully!"
}

# Run the main function
main
