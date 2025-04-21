import { expect } from 'chai';
import hre from 'hardhat';

import { loadFixture } from '@nomicfoundation/hardhat-toolbox/network-helpers';

describe("Censorless", function () {
    async function deployCensorlessFixture() {
        const [owner, otherAccount] = await hre.ethers.getSigners();

        const Censorless = await hre.ethers.getContractFactory("Censorless");
        const censorless = await Censorless.deploy();

        return { censorless, owner, otherAccount };
    }

    describe("Deployment", function () {
        it("Should set the right owner", async function () {
            const { censorless, owner } = await loadFixture(deployCensorlessFixture);
            expect(await censorless.owner()).to.equal(owner.address);
        });

        it("Should initialize with empty endpoint", async function () {
            const { censorless } = await loadFixture(deployCensorlessFixture);
            expect(await censorless.getEndpoint()).to.equal("");
        });
    });

    describe("Endpoint Management", function () {
        const testEndpoint = "https://example.com";

        describe("Permissions", function () {
            it("Should allow owner to set endpoint", async function () {
                const { censorless } = await loadFixture(deployCensorlessFixture);

                await expect(censorless.setEndpoint(testEndpoint)).not.to.be.reverted;
                expect(await censorless.getEndpoint()).to.equal(testEndpoint);
            });

            it("Should not allow non-owner to set endpoint", async function () {
                const { censorless, otherAccount } = await loadFixture(deployCensorlessFixture);

                await expect(
                    (censorless.connect(otherAccount) as typeof censorless).setEndpoint(testEndpoint)
                ).to.be.revertedWith("Only the owner can set the endpoint");
            });
        });

        describe("Functionality", function () {
            it("Should update endpoint when owner calls setEndpoint", async function () {
                const { censorless } = await loadFixture(deployCensorlessFixture);

                // Set initial endpoint
                await censorless.setEndpoint(testEndpoint);
                expect(await censorless.getEndpoint()).to.equal(testEndpoint);

                // Update endpoint
                const newEndpoint = "https://newexample.com";
                await censorless.setEndpoint(newEndpoint);
                expect(await censorless.getEndpoint()).to.equal(newEndpoint);
            });

            it("Should correctly return the current endpoint", async function () {
                const { censorless } = await loadFixture(deployCensorlessFixture);

                expect(await censorless.getEndpoint()).to.equal("");

                await censorless.setEndpoint(testEndpoint);
                expect(await censorless.getEndpoint()).to.equal(testEndpoint);
            });
        });
    });
});