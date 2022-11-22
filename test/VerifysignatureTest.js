const { expect } = require("chai");
const { ethers } = require("hardhat");

/* Verify The Signature using the Ether.js */
describe("Verify the Signature", function () {
  this.beforeEach;
  it("Verify the Signature By Signing the Message", async function () {
    const accounts = await ethers.getSigners(2);
    const Signer = accounts[0];
    const to = accounts[1];
    console.log(Signer.address, to.address);
    /* *Deploy The contract */
    const VerifySignature = await ethers.getContractFactory("VerifySignature");
    const contract = await VerifySignature.deploy();
    await contract.deployed();
    console.log("Verified....");
    const amount = 1000;
    const message = "Hello";
    const nonce = 999;
    const hash = await contract.GenerateMessageHash(
      to.address,
      nonce,
      amount,
      message
    );
    console.log(hash);
    //Sign a message using ether.js
    const Signature = await Signer.signMessage(ethers.utils.arrayify(hash));
    console.log(Signature);
    const EthMessage = await contract.GetEthSignedMessage(hash);
    console.log(EthMessage);

    console.log("Signer   ", Signer.address);
    console.log(
      "recovered Signer..",
      await contract.recoverSignerAddress(EthMessage, Signature)
    );

    expect(
      await contract.Verify(
        Signer.address,
        to.address,
        nonce,
        amount,
        message,
        Signature
      )
    ).to.be.equal(true);
    expect(
      await contract.Verify(
        Signer.address,
        to.address,
        nonce,
        amount + 3,
        message,
        Signature
      )
    ).to.be.equal(false);
  });
});
