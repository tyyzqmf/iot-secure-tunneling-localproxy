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
2. Download version v3.1.15 of LocalProxy from GitHub releases (or a user-specified version)
3. Install it to a suitable location
4. Set up environment variables
5. Make it available for direct use

## Installation Instructions

### Quick Installation (Recommended)

The easiest way to install is to use the universal wrapper script:

1. Open a terminal
2. Download and run the script in one command:
   ```bash
   curl -sSL https://raw.githubusercontent.com/tyyzqmf/iot-secure-tunneling-localproxy/main/install.sh | bash
   ```

Or download and run separately:

1. Download the script:
   ```bash
   curl -sSL -o install.sh https://raw.githubusercontent.com/tyyzqmf/iot-secure-tunneling-localproxy/main/install.sh
   ```

2. Make the script executable:
   ```bash
   chmod +x install.sh
   ```

3. Run the script:
   ```bash
   ./install.sh
   ```

### Specifying a Version

You can specify a particular version of LocalProxy to install by using the `--version` parameter:

```bash
./install.sh --version=v3.1.2-beta
```

Or when using curl directly:

```bash
curl -sSL https://raw.githubusercontent.com/tyyzqmf/iot-secure-tunneling-localproxy/main/install.sh | bash -s -- --version=v3.1.2-beta
```

### Manual Installation

#### Linux and macOS

1. Open a terminal
2. Download the script:
   ```bash
   curl -sSL -o install_localproxy.sh https://raw.githubusercontent.com/tyyzqmf/iot-secure-tunneling-localproxy/main/install_localproxy.sh
   ```
3. Make the script executable:
   ```bash
   chmod +x install_localproxy.sh
   ```
4. Run the script (optionally with a version):
   ```bash
   ./install_localproxy.sh
   # Or with a specific version:
   VERSION=v3.1.2-beta ./install_localproxy.sh
   ```
5. After installation, you may need to restart your terminal or run:
   ```bash
   source ~/.bashrc  # For Bash on Linux
   source ~/.bash_profile  # For Bash on macOS
   source ~/.zshrc  # For Zsh
   ```

#### Windows

1. Open PowerShell as Administrator
2. Download the script:
   ```powershell
   Invoke-WebRequest -Uri https://raw.githubusercontent.com/tyyzqmf/iot-secure-tunneling-localproxy/main/install_localproxy.ps1 -OutFile install_localproxy.ps1
   ```
3. Set execution policy to allow the script to run (if not already set):
   ```powershell
   Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
   ```
4. Run the script (optionally with a version):
   ```powershell
   .\install_localproxy.ps1
   # Or with a specific version:
   $env:VERSION="v3.1.2-beta"; .\install_localproxy.ps1
   ```
5. After installation, restart your PowerShell session to apply PATH changes

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
