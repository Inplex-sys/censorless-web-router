import { HardhatUserConfig } from "hardhat/config";
import "@nomicfoundation/hardhat-toolbox";

if (!process.env.PRIVATE_KEY) {
    throw new Error("Please set your PRIVATE_KEY in a .env file");
}

const config: HardhatUserConfig = {
    solidity: "0.8.28",
    networks: {
        optimism: {
            url: "https://optimism.meowrpc.com",
            accounts: [Bun.env.PRIVATE_KEY],
        },
    },
};

export default config;
