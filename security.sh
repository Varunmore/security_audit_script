#!/bin/bash

#list users and groups
audit_user_group(){
    echo "### User and Group Audit ###"
    echo "All users and groups on the server"
    cat /etc/passwd
    cat /etc/group

    echo "Non-standard UID 0 users;"
    awk -F: '($3 == 0) {print $1}' /etc/passwd

    echo "Users without passwords or weak passwords;"
    awk -F: '($2 == "") {print $1}'  /etc/shadow
}


# File and Directory Permission

audit_file_dire(){
    echo "### File and Direcotry Permission Audit ###"
    echo "World-Writable Files and directories:"
    find / -pem -002 -type f -print 2>/dev/null
    find / -pem -002 -type d -print 2>/dev/null

    echo "Checking .ssh directories for secure persmissions:"
    find /home -type d -name ".ssh" -exec chmod 700 {} \;

    echo "SUID and SGID files:"
    find / -prem /6000 -type f -exec ls -ld {} \; 2>/dev/null
}

# services

audit_services() {
    echo "### Service Audit ###"
    echo "Running services:"
    systemctl list-units --type=service --state=running

    echo "Critical services running:"
    for service in sshd iptables; do 
        systemctl is-active --quiet $service && echo "$service is running" || echo "$service is not running"
    done

    echo "Services listening on non-standard or insecure ports:"
    netstat -tulnp | grep -v ':22\|:80\|:443'
}

# Firewall and networks security

audit_firewall_network(){
    echo "### Firewall and Network Secuirty  Audit ###"
    echo "Checking if firewall is active:"
    systemctl is-activve --quiet iptables && echo "Firewall is active" || echo "Firewall is not active"

    echo "Open ports and thier associated services:"
    netstat -tulnp

    echo "Checkinng for IP forwarding"
    systemctl net.ipv4.ip_forward net.ipv6.cong.all.forwarding
}

# IP and Network configuration

audit_ip_network() {
    echo "### IP and Network Configuration Checks ###"
    echo "Public vs. Private IPs:"
    ip a | grep inet

    echo "Network interfaces:"
    ip link show
}

# Check for security updates and patching

audit_security_updates(){
    echo "### Secuirty Updates and Patching ###"
    echo "Available securoity updates:"
    apt-get -s dist-upgrade | grep "^Inst" | grep -i securi
}

# Monitor log

audit_log(){
    echo "### Log Monitoring ###"
    echo "Checking for recent suspicious log entries:"
    grep "Failed password" /var/log/auth.log | tail -n 10
}

# Harden SSH configurations

harden_ssh() {
    echo "### SSH Configuration Haardening ###"
    sed -i 's/^#PermitRootLogin.*/PermitRootLogin no/' /etc/ssh/sshd_config
    sed -i 's/^#PasswordAuthentication.*/PasswordAuthentication no/' /etc/ssh/sshd_config
    systemctl restart sshd
}

# Disable IPV6 if not required

disable_ipv6() {
    echo "### Disabling IPV6 ###"
    systemctl -w net.ipv6.conf.all.disable_ipv6=1
    echo "net.ipv6.conf.all.disable_ipv6 = 1" >> /etc/sysctl.conf
}


# Secure the bootloader

secure_bootloder() {
    echo "### Securing the Bootloader ###"
    grub-mkpasswd-pbkdf2 | tee -a /etc/grub.d/40_custom
    update-grub
}

# Configure firewall

configure_firewall() {
    echo "### Firewall Configguration ###"
    ufw default deny incoming
    ufw default allow outgoing
    ufw allow ssh
    ufw enable
}

# Automatic update

configure_automatic_updates(){
    echo "### Configuring Automatic Updates ###"
    apt-get install unattended-upgrades
    dpkg-reconfigure --priority=low unsttended-upgrades
}



main() {
    audit_user_group
    audit_file_dire
    audit_services
    audit_firewall_network
    audit_ip_network
    audit_security_updates
    audit_log
    harden_ssh
    disable_ipv6
    secure_bootloder
    configure_firewall
    configure_automatic_updates

    echo "Security audit and hardeing compete."
}

main