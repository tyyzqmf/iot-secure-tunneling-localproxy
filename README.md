# AWS IoT Secure Tunneling LocalProxy Installation Guide

This guide provides instructions for installing the AWS IoT Secure Tunneling LocalProxy on different operating systems.

## What is AWS IoT Secure Tunneling?

AWS IoT Secure Tunneling provides a secure way to establish bidirectional communication to remote devices that are behind firewalls or NAT (Network Address Translation). The LocalProxy is a client application that establishes and maintains the secure tunnel connection.

## Installation Scripts

This repository includes installation scripts for different operating systems:

- `install.sh` - Universal wrapper script that detects your OS and runs the appropriate script
- `install_localproxy.sh` - For Linux and macOS
- `install_localproxy.ps1` - For Windows

These scripts will:
1. Detect your operating system and architecture
2. Download version v3.1.2-beta of LocalProxy from GitHub releases
3. Install it to a suitable location
4. Set up environment variables
5. Make it available for direct use

## Installation Instructions

### Quick Installation (Recommended)

The easiest way to install is to use the universal wrapper script:

1. Open a terminal
2. Make the script executable:
   ```bash
   chmod +x install.sh
   ```
3. Run the script:
   ```bash
   ./install.sh
   ```

The script will automatically detect your operating system and run the appropriate installation script.

### Manual Installation

#### Linux and macOS

1. Open a terminal
2. Make the script executable:
   ```bash
   chmod +x install_localproxy.sh
   ```
3. Run the script:
   ```bash
   ./install_localproxy.sh
   ```
4. After installation, you may need to restart your terminal or run:
   ```bash
   source ~/.bashrc  # For Bash on Linux
   source ~/.bash_profile  # For Bash on macOS
   source ~/.zshrc  # For Zsh
   ```

#### Windows

1. Open PowerShell as Administrator
2. Set execution policy to allow the script to run (if not already set):
   ```powershell
   Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
   ```
3. Run the script:
   ```powershell
   .\install_localproxy.ps1
   ```
4. After installation, restart your PowerShell session to apply PATH changes

## Usage

After installation, you can use LocalProxy with the following commands:

### Source Mode (for connecting to a destination device)

```
localproxy -r <region> -s <source-access-token>
```

### Destination Mode (for accepting connections on a device)

```
localproxy -r <region> -d <destination-access-token> -t <destination-port>
```

### Additional Options

For more information and additional options, run:

```
localproxy --help
```

## Troubleshooting

### Common Issues

1. **Permission Denied**: Ensure the script has executable permissions
2. **Download Failed**: Check your internet connection and firewall settings
3. **Command Not Found**: Ensure your PATH environment variable is updated (restart your terminal/PowerShell)

### Manual Installation

If the automatic installation fails, you can manually:

1. Download the appropriate binary from the [GitHub releases](https://github.com/tyyzqmf/iot-secure-tunneling-localproxy/releases)
2. Place it in a directory of your choice
3. Add that directory to your PATH environment variable

## Additional Resources

- [AWS IoT Secure Tunneling Documentation](https://docs.aws.amazon.com/iot/latest/developerguide/secure-tunneling.html)
- [AWS IoT Secure Tunneling API Reference](https://docs.aws.amazon.com/iot/latest/apireference/API_CreateTunnel.html)
