#!/bin/bash

GREEN="\033[0;32m"
YELLOW="\033[0;33m"
RED="\033[0;31m"
RESET="\033[0m"

error_exit() {
    echo -e "${RED}ERROR: $1${RESET}" >&2
    exit 1
}

print_proxy_settings() {
    echo -e "${YELLOW}Current proxy settings:${RESET}"
    if grep -q "proxy" ~/.bashrc; then
        echo -e "${GREEN}- Proxy settings found in ~/.bashrc:${RESET}"
        grep -i "proxy" ~/.bashrc
    else
        echo -e "${GREEN}- No proxy settings found in ~/.bashrc.${RESET}"
    fi
    if grep -q "proxy" /etc/environment; then
        echo -e "${GREEN}- Proxy settings found in /etc/environment:${RESET}"
        grep -i "proxy" /etc/environment
    else
        echo -e "${GREEN}- No proxy settings found in /etc/environment.${RESET}"
    fi
    if [[ -f "/etc/apt/apt.conf.d/proxy.conf" ]]; then
        echo -e "${GREEN}- Proxy settings found in /etc/apt/apt.conf.d/proxy.conf.${RESET}"
    else
        echo -e "${GREEN}- No proxy settings found in /etc/apt/apt.conf.d/proxy.conf.${RESET}"
    fi
    if sudo snap get system.proxy.http >/dev/null 2>&1 || sudo snap get system.proxy.https >/dev/null 2>&1; then
        echo -e "${GREEN}- Proxy settings found in Snap.${RESET}"
    else
        echo -e "${GREEN}- No proxy settings found in Snap.${RESET}"
    fi
    if command -v gsettings >/dev/null 2>&1 && gsettings get org.gnome.system.proxy mode | grep -q "manual"; then
        echo -e "${GREEN}- Proxy settings found in GSettings.${RESET}"
    else
        echo -e "${GREEN}- No proxy settings found in GSettings.${RESET}"
    fi
    if grep -q "proxy" /etc/profile && [[ -s "/etc/profile.d/proxy.sh" ]]; then
        echo -e "${GREEN}- Proxy settings found in /etc/profile and /etc/profile.d/proxy.sh:${RESET}"
        sudo grep -i "proxy" /etc/profile /etc/profile.d/proxy.sh
    else
        echo -e "${GREEN}- No proxy settings found in /etc/profile and /etc/profile.d/proxy.sh.${RESET}"
    fi
}

remove_proxy_settings() {
    # Bash environment
    echo -e "${YELLOW}Removing proxy settings from Bash environment...${RESET}"
    if ! grep -v -i "proxy" ~/.bashrc > ~/.bashrc_temp; then
        error_exit "File not found: ~/.bashrc"
    fi
    mv ~/.bashrc_temp ~/.bashrc
    source ~/.bashrc
    echo -e "${GREEN}Removed proxy settings from ~/.bashrc${RESET}"
    # Snap
    echo -e "${YELLOW}Removing proxy settings from Snap...${RESET}"
    sudo snap unset system.proxy.http
    sudo snap unset system.proxy.https
    if [[ -f "/etc/systemd/system/snapd.service.d/snap_proxy.conf" ]]; then
        sudo mv /etc/systemd/system/snapd.service.d/snap_proxy.conf /etc/systemd/system/snapd.service.d/https-proxy.conf_bkp
    fi
    echo -e "${GREEN}Removed proxy settings from Snap.${RESET}"
    sudo chown -R root:root /var/lib/snapd
    sudo systemctl daemon-reload
    sudo systemctl restart snapd.service
    # GSettings
    if command -v gsettings >/dev/null 2>&1; then
        echo -e "${YELLOW}Removing proxy settings from GSettings...${RESET}"
        gsettings set org.gnome.system.proxy mode 'none'
        echo -e "${GREEN}Removed proxy settings from GSettings.${RESET}"
    else
        echo -e "${YELLOW}GSettings not found. Skipping...${RESET}"
    fi
    # System-wide profile
    echo -e "${YELLOW}Removing proxy settings from system-wide profile...${RESET}"
    if ! sudo grep -v -i "proxy" /etc/profile > /etc/profile_temp; then
        error_exit "File not found: /etc/profile"
    fi
    sudo mv /etc/profile_temp /etc/profile
    if [[ -f "/etc/profile.d/proxy.sh" ]]; then
        sudo grep -v -i "proxy" /etc/profile.d/proxy.sh > /etc/profile.d/proxy_temp.sh
        sudo mv /etc/profile.d/proxy_temp.sh /etc/profile.d/proxy.sh
    fi
    echo -e "${GREEN}Removed proxy settings from /etc/profile and /etc/profile.d/proxy.sh${RESET}"
}

reset_machine() {
    # Prompt the user before resetting the machine
    read -p "This will reset the machine to its original state. Are you sure? [y/N] " confirm_reset
    if [[ "$confirm_reset" =~ ^[Yy]$ ]]; then
        # Restore the original bashrc
        echo -e "${YELLOW}Restoring the original bashrc...${RESET}"
        cp /etc/skel/.bashrc ~/
        source ~/.bashrc
        echo -e "${GREEN}Restored the original bashrc.${RESET}"
        # Remove the proxy settings
        remove_proxy_settings
        echo -e "${GREEN}Machine has been reset to its original state.${RESET}"
    else
        echo -e "${YELLOW}Machine reset canceled.${RESET}"
    fi
}

# Parse command line options
while getopts ":pro" opt; do
    case ${opt} in
        p )
            print_proxy_settings
            exit 0
            ;;
        r )
            remove_proxy_settings
            exit 0
            ;;
        o )
            reset_machine
            exit 0
            ;;
        \? )
            echo -e "${RED}Invalid option: -$OPTARG${RESET}" >&2
            echo -e "Usage: $0 [-p|-r|-o]" >&2
            exit 1
            ;;
        : )
            echo -e "${RED}Option -$OPTARG requires an argument.${RESET}" >&2
            echo -e "Usage: $0 [-p|-r|-o]" >&2
            exit 1
            ;;
    esac
done
if [[ $# -eq 0 ]]; then
    echo -e "Usage: $0 [-p|-r|-o]" >&2
    echo -e "  -p  Print the current proxy settings"
    echo -e "  -r  Remove all the proxy settings"
    echo -e "  -o  Reset the machine to its original state"
    exit 1
fi

exit 0

