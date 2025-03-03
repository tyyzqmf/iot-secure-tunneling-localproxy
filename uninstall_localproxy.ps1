# PowerShell script to uninstall AWS IoT Secure Tunneling localproxy
# This script removes the binary, installation directory, and cleans up environment variables

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

# Remove installation directory
function Remove-InstallDir {
    Write-Step "Removing installation directory..."
    
    $INSTALL_DIR = "$env:USERPROFILE\.aws-iot-localproxy"
    
    if (Test-Path -Path $INSTALL_DIR) {
        Remove-Item -Path $INSTALL_DIR -Recurse -Force
        Write-Success "Removed installation directory: $INSTALL_DIR"
    } else {
        Write-Warning "Installation directory not found: $INSTALL_DIR"
    }
}

# Remove from PATH
function Remove-FromPath {
    Write-Step "Removing localproxy from PATH..."
    
    $INSTALL_DIR = "$env:USERPROFILE\.aws-iot-localproxy"
    $userPath = [System.Environment]::GetEnvironmentVariable("PATH", "User")
    
    if ($userPath -and $userPath.Contains($INSTALL_DIR)) {
        $newPath = ($userPath.Split(';') | Where-Object { $_ -ne $INSTALL_DIR }) -join ';'
        [System.Environment]::SetEnvironmentVariable("PATH", $newPath, "User")
        Write-Success "Removed localproxy directory from PATH"
        Write-Warning "Please restart your terminal or PowerShell session to apply changes"
    } else {
        Write-Warning "localproxy directory not found in PATH"
    }
}

# Main function
function Main {
    Write-Step "Starting AWS IoT Secure Tunneling localproxy uninstallation..."
    
    Remove-InstallDir
    Remove-FromPath
    
    Write-Success "AWS IoT Secure Tunneling localproxy uninstalled successfully!"
}

# Run the main function
Main
