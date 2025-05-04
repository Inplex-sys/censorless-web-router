import 'dotenv/config';

import { HardhatUserConfig } from "hardhat/config";
import "@nomicfoundation/hardhat-toolbox";

if (!process.env.PRIVATE_KEY) {
    throw new Error("Please set your PRIVATE_KEY in a .env file");
}

if (!process.env.NETWORK_RPC) {
    throw new Error("Please set your NETWORK_RPC in a .env file");
}

const config: HardhatUserConfig = {
    solidity: "0.8.28",
    networks: {
        optimism: {
            url: process.env.NETWORK_RPC,
            accounts: [process.env.PRIVATE_KEY],
        },
    },
};

export default config;
