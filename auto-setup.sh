#/bin/bash

# check if a command "bun" and "ipfs" exists
CURENT_DIR=$(pwd)

reload() {
    if [ -f ~/.bashrc ]; then
        source ~/.bashrc
    elif [ -f ~/.zshrc ]; then
        source ~/.zshrc
    fi
}


if ! command -v bun &> /dev/null
then
    echo "bun could not be found, installing ..."
    curl -fsSL https://bun.sh/install | bash

    reload
fi

if ! command -v ipfs &> /dev/null
then
    echo "ipfs could not be found, installing ..."
    cd /tmp
    wget https://dist.ipfs.tech/kubo/v0.34.1/kubo_v0.34.1_linux-amd64.tar.gz
    tar -xvzf kubo_v0.34.1_linux-amd64.tar.gz
    cd kubo
    bash install.sh
fi

cd $CURENT_DIR

# check if a command "git" exists
if ! command -v git &> /dev/null
then
    echo "git could not be found, installing ..."
    if [ -f /etc/debian_version ]; then
        sudo apt update
        sudo apt install git -y
    elif [ -f /etc/redhat-release ]; then
        sudo yum install git -y
    else
        echo "Unsupported OS. Please install git manually."
        exit 1
    fi
fi

git clone https://github.com/SystemVll/censorless-web-router.git
cd censorless-web-router

cd hardhat
bun install

# ask user to prompot private key and netowrk rpc
echo "Please enter your private key:"
read PRIVATE_KEY

echo "Please enter your network rpc:"
read NETWORK_RPC

echo <<<EOF
PRIVATE_KEY=$PRIVATE_KEY
NETWORK_RPC=$NETWORK_RPC
EOF > .env

echo "/!\ You must have enough ETH in your wallet to deploy the contract. (at least 1$ for gas fee)"

bun run deploy