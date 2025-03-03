# PowerShell script to download, install and configure AWS IoT Secure Tunneling localproxy
# This script detects architecture, downloads the appropriate version,
# installs it, and sets up environment variables

# Ensure script stops on error
$ErrorActionPreference = "Stop"

# Colors for output
function Write-ColorOutput {
    param (
        [Parameter(Mandatory=$true)]
        [string]$Message,
        
        [Parameter(Mandatory=$false)]
        [string]$ForegroundColor = "White"
    )
    
    Write-Host $Message -ForegroundColor $ForegroundColor
}

# Print step information
function Write-Step {
    param (
        [Parameter(Mandatory=$true)]
        [string]$Message
    )
    
    Write-ColorOutput "==> $Message" -ForegroundColor Cyan
}

# Print success message
function Write-Success {
    param (
        [Parameter(Mandatory=$true)]
        [string]$Message
    )
    
    Write-ColorOutput "✓ $Message" -ForegroundColor Green
}

# Print error message and exit
function Write-Error {
    param (
        [Parameter(Mandatory=$true)]
        [string]$Message
    )
    
    Write-ColorOutput "✗ $Message" -ForegroundColor Red
    exit 1
}

# Print warning message
function Write-Warning {
    param (
        [Parameter(Mandatory=$true)]
        [string]$Message
    )
    
    Write-ColorOutput "! $Message" -ForegroundColor Yellow
}

# Detect architecture
function Detect-Architecture {
    Write-Step "Detecting system architecture..."
    
    $arch = [System.Environment]::GetEnvironmentVariable("PROCESSOR_ARCHITECTURE")
    
    if ($arch -eq "AMD64") {
        $script:ARCH = "amd64"
    } elseif ($arch -eq "ARM64") {
        $script:ARCH = "arm64"
    } else {
        Write-Error "Unsupported architecture: $arch"
    }
    
    Write-Success "Detected architecture: $script:ARCH"
}

# Create installation directory
function Create-InstallDir {
    Write-Step "Creating installation directory..."
    
    $script:INSTALL_DIR = "$env:USERPROFILE\.aws-iot-localproxy"
    
    if (-not (Test-Path -Path $script:INSTALL_DIR)) {
        New-Item -ItemType Directory -Path $script:INSTALL_DIR -Force | Out-Null
    }
    
    Write-Success "Created installation directory: $script:INSTALL_DIR"
}

# Download localproxy
function Download-LocalProxy {
    Write-Step "Downloading localproxy for Windows/$script:ARCH..."
    
    # GitHub repository URL
    $REPO_URL = "https://github.com/tyyzqmf/iot-secure-tunneling-localproxy"
    
    # Specific version to use
    $VERSION = "v3.1.2-beta"
    
    # Binary name for Windows
    $BINARY_NAME = "localproxy.exe"
    
    # Download from GitHub releases
    Write-Step "Downloading from GitHub releases..."
    
    $DOWNLOAD_URL = "$REPO_URL/releases/download/$VERSION/localproxy-windows-$script:ARCH"
    
    try {
        Invoke-WebRequest -Uri $DOWNLOAD_URL -OutFile "$script:INSTALL_DIR\$BINARY_NAME"
        Write-Success "Downloaded localproxy from GitHub releases"
    } catch {
        Write-Error "Failed to download localproxy for Windows/$script:ARCH from $DOWNLOAD_URL. Error: $_"
    }
}

# Add to PATH
function Add-ToPath {
    Write-Step "Adding localproxy to PATH..."
    
    $userPath = [System.Environment]::GetEnvironmentVariable("PATH", "User")
    
    if (-not $userPath.Contains($script:INSTALL_DIR)) {
        $newPath = "$script:INSTALL_DIR;$userPath"
        [System.Environment]::SetEnvironmentVariable("PATH", $newPath, "User")
        Write-Success "Added localproxy directory to PATH"
        Write-Warning "Please restart your terminal or PowerShell session to apply changes"
    } else {
        Write-Success "localproxy directory already in PATH"
    }
}

# Display usage information
function Display-Usage {
    Write-Step "Usage Information"
    Write-Host ""
    Write-Host "AWS IoT Secure Tunneling localproxy has been installed successfully."
    Write-Host ""
    Write-Host "To use localproxy, you need to provide a source or destination access token:"
    Write-Host ""
    Write-Host "  Source mode (for connecting to a destination device):"
    Write-Host "    localproxy -r <region> -s <source-access-token>"
    Write-Host ""
    Write-Host "  Destination mode (for accepting connections on a device):"
    Write-Host "    localproxy -r <region> -d <destination-access-token> -t <destination-port>"
    Write-Host ""
    Write-Host "For more information, run:"
    Write-Host "    localproxy --help"
    Write-Host ""
}

# Main function
function Main {
    Write-Step "Starting AWS IoT Secure Tunneling localproxy installation..."
    
    Detect-Architecture
    Create-InstallDir
    Download-LocalProxy
    Add-ToPath
    
    Write-Success "AWS IoT Secure Tunneling localproxy installed successfully!"
    Display-Usage
}

# Run the main function
Main
