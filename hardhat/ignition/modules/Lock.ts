// This setup uses Hardhat Ignition to manage smart contract deployments.
// Learn more about it at https://hardhat.org/ignition

import { buildModule } from '@nomicfoundation/hardhat-ignition/modules';

const CensorlessModule = buildModule("CensorlessModule", (m) => {
    const initialEndpoint = m.getParameter("initialEndpoint", "");

    const censorless = m.contract("Censorless", []);

    if (initialEndpoint.defaultValue !== "") {
        m.call(censorless, "setEndpoint", [initialEndpoint]);
    }

    return { censorless };
});

export default CensorlessModule;