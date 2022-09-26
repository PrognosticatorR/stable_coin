import { SignerWithAddress } from "@nomiclabs/hardhat-ethers/signers";
import { expect } from "chai";
import { ethers } from "hardhat";
import { ERC20 } from "./../typechain-types/ERC20";

describe("ERC20Contract", function () {
  let ERC20Contract: ERC20;
  let someAddress: SignerWithAddress;
  let someOtherAddress: SignerWithAddress;
  beforeEach(async () => {
    const ERC20TokenFactory = await ethers.getContractFactory("ERC20");
    ERC20Contract = await ERC20TokenFactory.deploy("Shiva", "Shiv");
    ERC20Contract.deployed();
    someAddress = (await ethers.getSigners())[1];
    someOtherAddress = (await ethers.getSigners())[2];
  });

  describe("it should transfer exact amount of tokens", () => {
    beforeEach(async () => {
      await ERC20Contract.transfer(someAddress.address, 10);
    });
    describe("When I transfer 10 tokens", () => {
      it("should transfer exact tokens", async () => {
        await ERC20Contract.connect(someAddress).transfer(
          someOtherAddress.address,
          10
        );
        expect(
          await ERC20Contract.balanceOf(someOtherAddress.address)
        ).to.equal(10);
      });
    });
    describe("When I transfer 15 tokens", () => {
      it("should not be able to transfer tokens then available", async () => {
        await expect(
          ERC20Contract.connect(someAddress).transfer(
            someOtherAddress.address,
            15
          )
        ).to.be.rejectedWith("ERC20: cant transfer more then balance");
      });
    });
  });
});
