import { ethers } from "hardhat";

async function main() {
    const ContractFactory = await ethers.getContractFactory("Censorless");
    const contract = await ContractFactory.deploy();
    await contract.deploymentTransaction()?.wait();

    console.log(await contract.getAddress());
}

main()
    .then(() => process.exit(0))
    .catch(error => {
        console.error(error);
        process.exit(1);
    });
