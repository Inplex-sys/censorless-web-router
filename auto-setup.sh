#!/bin/bash

RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[0;33m'
CYAN='\033[0;36m'
BOLD='\033[1m'
NC='\033[0m'

CURRENT_DIR=$(pwd)

print_header() {
  echo -e "\n${BOLD}${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
  echo -e "${BOLD}${BLUE}   $1${NC}"
  echo -e "${BOLD}${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}\n"
}

print_step() {
  echo -e "${YELLOW}➡️  ${BOLD}$1${NC}"
}

print_success() {
  echo -e "${GREEN}✅ ${BOLD}$1${NC}\n"
}

print_error() {
  echo -e "${RED}❌ ${BOLD}$1${NC}\n"
  exit 1
}

print_info() {
  echo -e "${CYAN}ℹ️  $1${NC}"
}

reload() {
    if [ -f ~/.bashrc ]; then
        source ~/.bashrc
    elif [ -f ~/.zshrc ]; then
        source ~/.zshrc
    fi
}

clear
print_header "🌐 CENSORLESS WEB ROUTER SETUP 🌐"
echo -e "Welcome to the automated setup wizard for Censorless Web Router!\n"

print_header "🔍 CHECKING DEPENDENCIES"

print_step "Checking for Bun runtime..."
if ! command -v bun &> /dev/null; then
    print_info "Bun could not be found, installing..."
    curl -fsSL https://bun.sh/install | bash
    reload
    if ! command -v bun &> /dev/null; then
        print_error "Failed to install Bun. Please install manually and try again."
    fi
    print_success "Bun installed successfully!"
else
    print_success "Bun is already installed!"
fi

cd $CURRENT_DIR

print_step "Checking for Git..."
if ! command -v git &> /dev/null; then
    print_info "Git could not be found, installing..."
    if [ -f /etc/debian_version ]; then
        sudo apt update
        sudo apt install git -y
    elif [ -f /etc/redhat-release ]; then
        sudo yum install git -y
    else
        print_error "Unsupported OS. Please install Git manually."
    fi
    print_success "Git installed successfully!"
else
    print_success "Git is already installed!"
fi

print_header "📥 CLONING REPOSITORY"
print_step "Cloning censorless-web-router..."
git clone https://github.com/SystemVll/censorless-web-router.git
print_success "Repository cloned successfully!"

print_header "🛠️  SETTING UP ENVIRONMENT"
print_step "Installing dependencies..."
cd censorless-web-router/hardhat
bun install
print_success "Dependencies installed!"

print_header "⚙️  CONFIGURATION"

echo -e "${BOLD}Please provide the following information:${NC}"
echo -e "${CYAN}┌────────────────────────────────────────┐${NC}"
echo -ne "${CYAN}│${NC} 🔑 Enter your private key: ${BOLD}"
read PRIVATE_KEY
echo -ne "${NC}${CYAN}│${NC} 🔌 Enter your network RPC: ${BOLD}"
read NETWORK_RPC
echo -e "${NC}${CYAN}└────────────────────────────────────────┘${NC}"

cat > .env << EOF
PRIVATE_KEY=$PRIVATE_KEY
NETWORK_RPC=$NETWORK_RPC
EOF

print_success "Environment configured!"

print_header "📝 DEPLOYING CONTRACT"
print_info "⚠️  You must have enough ETH in your wallet to deploy the contract (at least 1$ for gas fee)"
echo -e "${YELLOW}Deploying contract to Optimism network...${NC}"
CONTRACT_ADDRESS=$(bun run deploy --network optimism)

if [ -z "$CONTRACT_ADDRESS" ]; then
    print_error "Failed to deploy contract. Check your private key and network RPC."
else
    print_success "Contract deployed successfully at: ${BOLD}$CONTRACT_ADDRESS${NC}"
fi

cd ..

print_header "🔧 INSTALLATION OPTIONS"

echo -e "${BOLD}Choose your installation option:${NC}"
echo -e "${CYAN}┌────────────────────────────────────────┐${NC}"
echo -e "${CYAN}│${NC} 1️⃣  Install local IPFS node           ${CYAN}│${NC}"
echo -e "${CYAN}│${NC} 2️⃣  Export router as .zip file        ${CYAN}│${NC}"
echo -e "${CYAN}└────────────────────────────────────────┘${NC}"
echo -ne "Enter your choice (1/2): "
read INSTALL_CHOICE

if [ "$INSTALL_CHOICE" == "1" ]; then
    print_header "🪢 SETTING UP IPFS NODE"
    if ! command -v ipfs &> /dev/null; then
        print_step "Installing IPFS Kubo..."
        cd /tmp
        wget https://dist.ipfs.tech/kubo/v0.34.1/kubo_v0.34.1_linux-amd64.tar.gz
        tar -xvzf kubo_v0.34.1_linux-amd64.tar.gz
        cd kubo
        bash install.sh
        print_success "IPFS Kubo installed!"
    else
        print_success "IPFS is already installed!"
    fi
    
    print_step "Initializing IPFS..."
    ipfs init
    print_success "IPFS initialized successfully!"
    
    print_info "To start the IPFS daemon, run: ${BOLD}ipfs daemon${NC}"
    
elif [ "$INSTALL_CHOICE" == "2" ]; then
    print_header "📦 EXPORTING ROUTER"
    print_step "Building router..."
    cd router/
    bun install
    
    cat > .env << EOF
VITE_NETWORK_RPC=$NETWORK_RPC
VITE_CONTRACT_ADDRESS=$CONTRACT_ADDRESS
EOF
    
    bun run build
    zip -r router.zip dist
    print_success "Router built and exported as router.zip!"
    print_info "Your router.zip file is ready at: ${BOLD}$(pwd)/router.zip${NC}"
else
    print_error "Invalid choice. Please run the script again and select 1 or 2."
fi

print_header "🎉 SETUP COMPLETE!"
echo -e "Thank you for using Censorless Web Router Setup!"
echo -e "For more information, visit: ${BOLD}https://github.com/SystemVll/censorless-web-router${NC}\n"