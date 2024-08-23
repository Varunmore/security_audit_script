# Linux Server Security Audit and Hardening Script

## Overview

This Bash script automates security audits and hardening measures on Linux servers. It is modular, reusable, and configurable, designed to enforce stringent security standards across multiple servers.

## Features

- **User and Group Audits**: List users, groups, check for UID 0 users, and identify users without passwords.
- **File and Directory Permissions**: Scan for world-writable files, SSH directories, SUID, and SGID files.
- **Service Audits**: Check running services, ensure critical services are active, and scan for non-standard ports.
- **Firewall and Network Security**: Verify firewall status, open ports, and check for IP forwarding.
- **IP and Network Configuration**: Identify public vs. private IPs and audit network interfaces.
- **Security Updates and Patching**: Check for available security updates.
- **Log Monitoring**: Monitor for suspicious log entries.
- **Server Hardening**: Implement SSH key-based authentication, disable IPv6, secure the bootloader, and configure the firewall.
- **Automatic Updates**: Configure unattended-upgrades for automatic security updates.

## Usage

1. Clone the repository:
    ```bash
    git clone https://github.com/yourusername/security-audit-script.git
    cd security-audit-script
    ```

2. Run the script with root privileges:
    ```bash
    sudo bash security_audit_hardening.sh
    ```

3. Review the output and logs to ensure all security measures are applied.

