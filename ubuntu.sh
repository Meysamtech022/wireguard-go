#!/bin/bash

# Colors
red='\033[0;31m'
green='\033[0;32m'
yellow='\033[0;33m'
blue='\033[0;34m'
purple='\033[0;35m'
cyan='\033[0;36m'
rest='\033[0m'

# Check Dependencies build
check_dependencies_build() {
    local dependencies=("curl" "wget" "git" "golang")

    for dep in "${dependencies[@]}"; do
        if ! dpkg -s "${dep}" &> /dev/null; then
            echo -e "${yellow}${dep} is not installed. Installing...${rest}"
            sudo apt install "${dep}" -y
        fi
    done
}

# Check Dependencies
check_dependencies() {
    local dependencies=("curl" "openssl-tool" "wget" "unzip")

    for dep in "${dependencies[@]}"; do
        if ! dpkg -s "${dep}" &> /dev/null; then
            echo -e "${yellow}${dep} is not installed. Installing...${rest}"
            sudo apt install "${dep}" -y
        fi
    done
}

# Build
build() {
    if command -v warp &> /dev/null || command -v s-vpn &> /dev/null; then
        echo -e "${green}Warp is already installed.${rest}"
        return
    fi

    echo -e "${green}Installing Warp...${rest}"
    sudo apt update && sudo apt upgrade -y
    check_dependencies_build

    if git clone https://github.com/bepass-org/wireguard-go.git &&
        cd wireguard-go &&
        go build main.go &&
        chmod +x main &&
        sudo cp main /usr/local/bin/s-vpn &&
        sudo cp main /usr/local/bin/warp; then
        echo -e "${green}Warp installed successfully.${rest}"
    else
        echo -e "${red}Error installing WireGuard VPN.${rest}"
    fi
}

# Install
install() {
    if command -v warp &> /dev/null || command -v s-vpn &> /dev/null; then
        echo -e "${green}Warp is already installed.${rest}"
        return
    fi

    echo -e "${green}Installing Warp...${rest}"
    sudo apt update && sudo apt upgrade -y
    sudo apt install openssh -y
    check_dependencies

    if wget https://github.com/bepass-org/wireguard-go/releases/download/v0.0.6-alpha/warp-android-arm64.ed853c.zip &&
        unzip warp-android-arm64.ed853c.zip &&
        chmod +x warp &&
        sudo cp warp /usr/local/bin/s-vpn &&
        sudo cp warp /usr/local/bin/warp; then
        rm "README.md" "LICENSE" "warp-android-arm64.ed853c.zip"
        echo "================================================"
        echo -e "${green}Warp installed successfully.${rest}"
        socks
    else
        echo -e "${red}Error installing Warp.${rest}"
    fi
}

# Get socks config
socks() {
    echo ""
    echo -e "${yellow}Copy this Config to ${purple}V2ray${green} Or ${purple}Nekobox ${yellow}and Exclude Termux${rest}"
    echo "================================================"
    echo -e "${green}socks://Og==@127.0.0.1:8086#warp_(s-vpn)${rest}"
    echo "or"
    echo -e "${green}Manually create a SOCKS configuration with IP ${purple}127.0.0.1 ${green}and port${purple} 8086..${rest}"
    echo "================================================"
    echo -e "${yellow}To run again, type:${green} warp ${rest}or${green} s-vpn ${rest}or${green} ./warp${rest}"
    echo "================================================"
    echo -e "${green} If you get a 'Bad address' error, run ${yellow}[Arm]${rest}"
    echo ""
}

#Uninstall
uninstall() {
    warp="/usr/local/bin/warp"
    directory="/data/data/com.termux/files/home/wireguard-go"
    home="/data/data/com.termux/files/home"
    if [ -f "$warp" ]; then
        sudo rm -rf "$directory" "/usr/local/bin/s-vpn" "wa.py" "/usr/local/bin/warp" "$home/wgcf-profile.ini" "$home/warp" "$home/wgcf-identity.json" > /dev/null 2>&1
        echo -e "${red}Uninstallation completed.${rest}"
    else
        echo -e "${yellow} ____________________________________${rest}"
        echo -e "${red} Not installed.Please Install First.${rest}${yellow}|"
        echo -e "${yellow} ____________________________________${rest}"
    fi
}

# Warp to Warp plus
warp_plus() {
    if ! command -v python &> /dev/null; then
        echo "Installing Python..."
        sudo apt install python -y
    fi

    echo -e "${green}Downloading and running${purple} Warp+ script...${rest}"
    wget -O wa.py https://raw.githubusercontent.com/Ptechgithub/configs/main/wa.py
    python wa.py
}

# Menu
menu() {
    clear
    echo -e "${green}By --> Peyman * Github.com/Ptechgithub * ${rest}"
    echo ""
    echo -e "${yellow}❤️Github.com/${cyan}bepass-org${yellow}/wireguard-go❤️${rest}"
    echo -e "${purple}*********************************${rest}"
    echo -e "${blue}     ###${cyan} Warp in Ubuntu ${blue}###${rest}   ${purple}  * ${rest}"
    echo -e "${purple}*********************************${rest}"
    echo -e "${cyan}1)${rest} ${green}Install Warp (vpn)${purple}           * ${rest}"
    echo -e "                              ${purple}  * ${rest}"
    echo -e "${cyan}2)${rest} ${green}Install Warp (vpn) [${yellow}Arm${green}] ${purple}    * ${rest}"
    echo -e "                              ${purple}  * ${rest}"
    echo -e "${cyan}3)${rest} ${green}Uninstall${rest}${purple}                    * ${rest}"
    echo -e "                              ${purple}  * ${rest}"
    echo -e "${cyan}4)${rest} ${green}Warp to ${purple}Warp plus${green} [${yellow}Free GB${green}]${rest}${purple}  * ${rest}"
    echo -e "                              ${purple}  * ${rest}"
    echo -e "${cyan}5)${rest} ${green}Build (warp)${purple}                 * ${rest}"
    echo -e "                              ${purple}  * ${rest}"
    echo -e "${red}0)${rest} ${green}Exit                         ${purple}* ${rest}"
    echo -e "${purple}*********************************${rest}"
}

# Main
menu
read -p "Please enter your selection [0-5]:" choice

case "$choice" in
   1)
        install
        warp
        ;;
    2)
        install_arm
        warp
        ;;
    3)
        uninstall
        ;;
    4)
        warp_plus
        ;;
    5)
        build
        ;;
    0)
        echo -e "${cyan}Exiting...${rest}"
        exit
        ;;
    *)
        echo "Invalid choice. Please select a valid option."
        ;;
esac
