const { ethers } = require("hardhat");
require("dotenv").config({ path: "env" });
const { WHITELIST_CONTRACT_ADDRESS, METADATA_URL } = require("../constants");

async function main() {
  const whitelistContract = WHITELIST_CONTRACT_ADDRESS;
  const metadataURL = METADATA_URL;

  const nftDevsContract = await ethers.getContractFactory("NFTDev");
  const deployedNFTDevsContract = await nftDevsContract.deploy(metadataURL, whitelistContract);
  console.log("NFTDevs Contract deployed to:", deployedNFTDevsContract.address);
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
