#!/bin/bash

# Script to download, install and configure AWS IoT Secure Tunneling localproxy
# This script detects OS and architecture, downloads the appropriate version,
# installs it, and sets up environment variables

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

# Detect architecture
detect_arch() {
    print_step "Detecting system architecture..."
    
    local arch=$(uname -m)
    
    if [[ "$arch" == "x86_64" || "$arch" == "amd64" ]]; then
        ARCH="amd64"
    elif [[ "$arch" == "arm64" || "$arch" == "aarch64" ]]; then
        ARCH="arm64"
    else
        print_error "Unsupported architecture: $arch"
    fi
    
    print_success "Detected architecture: $ARCH"
}

# Create installation directory
create_install_dir() {
    print_step "Creating installation directory..."
    
    INSTALL_DIR="$HOME/.aws-iot-localproxy"
    mkdir -p "$INSTALL_DIR"
    
    print_success "Created installation directory: $INSTALL_DIR"
}

# Download localproxy
download_localproxy() {
    print_step "Downloading localproxy for $OS/$ARCH..."
    
    # GitHub repository URL
    REPO_URL="https://github.com/aws-samples/iot-secure-tunneling-localproxy"
    
    # AWS S3 URL as fallback
    AWS_URL="https://s3.amazonaws.com/aws-iot-device-sdk-secure-tunneling"
    
    # Determine binary name based on OS
    if [[ "$OS" == "windows" ]]; then
        BINARY_NAME="localproxy.exe"
    else
        BINARY_NAME="localproxy"
    fi
    
    # Try to download from GitHub releases first
    if command -v curl &> /dev/null; then
        print_step "Attempting to download from GitHub releases..."
        
        # Get the latest release tag
        LATEST_RELEASE=$(curl -s https://api.github.com/repos/aws-samples/iot-secure-tunneling-localproxy/releases/latest | grep -oP '"tag_name": "\K(.*)(?=")')
        
        if [[ -n "$LATEST_RELEASE" ]]; then
            DOWNLOAD_URL="$REPO_URL/releases/download/$LATEST_RELEASE/localproxy-$OS-$ARCH"
            curl -L -o "$INSTALL_DIR/$BINARY_NAME" "$DOWNLOAD_URL"
            
            if [[ $? -eq 0 ]]; then
                print_success "Downloaded localproxy from GitHub releases"
                return
            fi
        fi
    fi
    
    # If GitHub download failed, try AWS S3
    print_step "Attempting to download from AWS S3..."
    
    if command -v curl &> /dev/null; then
        DOWNLOAD_URL="$AWS_URL/localproxy-$OS-$ARCH"
        curl -L -o "$INSTALL_DIR/$BINARY_NAME" "$DOWNLOAD_URL"
        
        if [[ $? -eq 0 ]]; then
            print_success "Downloaded localproxy from AWS S3"
            return
        fi
    elif command -v wget &> /dev/null; then
        DOWNLOAD_URL="$AWS_URL/localproxy-$OS-$ARCH"
        wget -O "$INSTALL_DIR/$BINARY_NAME" "$DOWNLOAD_URL"
        
        if [[ $? -eq 0 ]]; then
            print_success "Downloaded localproxy from AWS S3"
            return
        fi
    fi
    
    # If both GitHub and AWS downloads failed, try to copy from the current repository
    print_step "Attempting to copy from local repository..."
    
    if [[ -f "bin/$OS/$ARCH/$BINARY_NAME" ]]; then
        cp "bin/$OS/$ARCH/$BINARY_NAME" "$INSTALL_DIR/$BINARY_NAME"
        print_success "Copied localproxy from local repository"
    else
        print_error "Failed to download or find localproxy for $OS/$ARCH"
    fi
}

# Set executable permissions
set_permissions() {
    print_step "Setting executable permissions..."
    
    if [[ "$OS" != "windows" ]]; then
        chmod +x "$INSTALL_DIR/localproxy"
        print_success "Set executable permissions"
    fi
}

# Create symbolic link
create_symlink() {
    print_step "Creating symbolic link..."
    
    if [[ "$OS" == "windows" ]]; then
        # On Windows, we don't create symlinks
        print_warning "Symbolic links not created on Windows"
    else
        # Create bin directory if it doesn't exist
        mkdir -p "$HOME/bin"
        
        # Create symbolic link
        ln -sf "$INSTALL_DIR/localproxy" "$HOME/bin/localproxy"
        
        print_success "Created symbolic link in $HOME/bin"
    fi
}

# Configure environment variables
configure_env_vars() {
    print_step "Configuring environment variables..."
    
    # Determine shell configuration file
    if [[ "$OS" == "windows" ]]; then
        print_warning "Environment variables not configured on Windows"
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
    
    # Check if PATH already contains $HOME/bin
    if ! echo "$PATH" | grep -q "$HOME/bin"; then
        echo "" >> "$shell_config"
        echo "# AWS IoT Secure Tunneling localproxy" >> "$shell_config"
        echo "export PATH=\"\$HOME/bin:\$PATH\"" >> "$shell_config"
        
        print_success "Added $HOME/bin to PATH in $shell_config"
        print_warning "Please run 'source $shell_config' or restart your terminal to apply changes"
    else
        print_success "$HOME/bin already in PATH"
    fi
}

# Display usage information
display_usage() {
    print_step "Usage Information"
    echo ""
    echo "AWS IoT Secure Tunneling localproxy has been installed successfully."
    echo ""
    echo "To use localproxy, you need to provide a source or destination access token:"
    echo ""
    echo "  Source mode (for connecting to a destination device):"
    echo "    localproxy -r <region> -s <source-access-token>"
    echo ""
    echo "  Destination mode (for accepting connections on a device):"
    echo "    localproxy -r <region> -d <destination-access-token> -t <destination-port>"
    echo ""
    echo "For more information, run:"
    echo "    localproxy --help"
    echo ""
}

# Main function
main() {
    print_step "Starting AWS IoT Secure Tunneling localproxy installation..."
    
    detect_os
    detect_arch
    create_install_dir
    download_localproxy
    set_permissions
    create_symlink
    configure_env_vars
    
    print_success "AWS IoT Secure Tunneling localproxy installed successfully!"
    display_usage
}

# Run the main function
main
