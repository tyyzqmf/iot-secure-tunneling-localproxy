# AWS IoT Secure Tunneling Localproxy 卸载指南

本文档提供了卸载 AWS IoT Secure Tunneling Localproxy 的详细说明。

## 使用方法

### 方法 1：直接使用 curl 卸载（Linux/macOS）

您可以使用以下命令直接从 GitHub 下载并执行卸载脚本：

```bash
curl -sSL https://raw.githubusercontent.com/tyyzqmf/iot-secure-tunneling-localproxy/main/uninstall_localproxy.sh | bash
```

这将下载卸载脚本并立即执行，无需手动下载或保存文件。

### 方法 2：下载后执行（Linux/macOS）

1. 下载卸载脚本：
   ```bash
   curl -O https://raw.githubusercontent.com/tyyzqmf/iot-secure-tunneling-localproxy/main/uninstall_localproxy.sh
   ```

2. 添加执行权限：
   ```bash
   chmod +x uninstall_localproxy.sh
   ```

3. 执行卸载脚本：
   ```bash
   ./uninstall_localproxy.sh
   ```

### 方法 3：Windows 系统卸载

1. 使用 PowerShell 下载卸载脚本：
   ```powershell
   Invoke-WebRequest -Uri https://raw.githubusercontent.com/tyyzqmf/iot-secure-tunneling-localproxy/main/uninstall_localproxy.ps1 -OutFile uninstall_localproxy.ps1
   ```

2. 执行卸载脚本：
   ```powershell
   .\uninstall_localproxy.ps1
   ```

## 卸载过程说明

卸载脚本会执行以下操作：

### Linux/macOS 系统

1. 检测操作系统类型
2. 删除 $HOME/bin 目录中的 localproxy 符号链接
3. 删除安装目录 $HOME/.aws-iot-localproxy
4. 清理 shell 配置文件（.bashrc、.zshrc 或 .bash_profile）中的环境变量设置

### Windows 系统

1. 删除安装目录 %USERPROFILE%\.aws-iot-localproxy
2. 从用户 PATH 环境变量中移除 localproxy 目录

## 注意事项

- 卸载完成后，可能需要重新加载 shell 配置或重启终端，以使环境变量的更改生效
- 如果您使用的是自定义 shell 或配置文件，脚本可能无法自动清理环境变量设置
- 卸载脚本会显示彩色输出，以便于区分不同类型的信息（步骤、成功、警告、错误）
