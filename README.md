![IPFS](https://github.com/ipfs) | ![Optimism](https://github.com/ethereum-optimism/optimism) | ![BUN](https://bun.sh/)

# 🌐 Censorless Web Router 🛡️

A censorship-resistant web application that uses **blockchain** technology and **IPFS** to dynamically route users to the correct endpoint, even if traditional DNS or domain services are blocked or compromised.

## 🤔 How It Works

The Censorless Web Router consists of two main components:

1. **Smart Contract** ⛓️ - A contract deployed on the Optimism blockchain that stores the current valid endpoint URL
2. **Web Router** 🔄 - A simple web application that queries the blockchain and redirects users to the current endpoint

When censorship occurs, the website owner can update the endpoint in the blockchain, and all users visiting the router will be automatically redirected to the new location.

## 🏗️ Architecture
![image](https://github.com/user-attachments/assets/5a144dbe-78e0-4f30-a2e9-aa12adbd5f53)


## 🚀 Setup

1. **Deploy the smart contract**:
   ```bash
   cd hardhat
   bun install
   bunx hardhat compile
   bunx hardhat deploy --network optimism
   ```

2. **Configure the router**:
   ```bash
   cd ../router
   bun install
   # Set contract address in .env
   echo "VITE_CONTRACT_ADDRESS=YOUR_CONTRACT_ADDRESS" > .env
   ```

3. **Deploy the router**:
   ```bash
   bun run build
   # Deploy dist folder to any static hosting service
   ```

## 💻 Usage

### For Website Owners 👨‍💼

1. Deploy the Censorless contract once
2. Update the endpoint URL whenever your site is censored:
   ```javascript
   await censorlessContract.methods.setEndpoint("https://new-domain.com").send({from: ownerAddress});
   ```

### For Users 👥

1. Bookmark the router URL
2. When the main site becomes inaccessible, visit the router
3. You'll be automatically redirected to the current working endpoint

## 🔧 Technical Details

- **Blockchain**: Optimism (Layer 2 Ethereum solution)
- **Smart Contract**: Solidity 0.8.28
- **Frontend**: Vanilla TypeScript with Web3.js
- **Connection**: WebSocket connection to Optimism public node

## 🛑 Limitations

- Requires the router to be accessible
- Relies on blockchain availability
- Small delay during redirection process

---

⚠️ This project is designed for legitimate websites facing unjust censorship. Always use responsibly and in accordance with applicable laws.
