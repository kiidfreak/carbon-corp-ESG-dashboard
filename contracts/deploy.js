const { ethers } = require("hardhat");

async function main() {
  const [deployer] = await ethers.getSigners();
  console.log("Deploying contracts with account:", deployer.address);

  // Deploy AccessControl
  const AccessControl = await ethers.getContractFactory("ESGAccessControl");
  const accessControl = await AccessControl.deploy();
  await accessControl.deployed();
  console.log("AccessControl deployed to:", accessControl.address);

  // Deploy ESGDataStorage
  const ESGDataStorage = await ethers.getContractFactory("ESGDataStorage");
  const dataStorage = await ESGDataStorage.deploy();
  await dataStorage.deployed();
  console.log("ESGDataStorage deployed to:", dataStorage.address);

  // Deploy ESGReporting
  const ESGReporting = await ethers.getContractFactory("ESGReporting");
  const reporting = await ESGReporting.deploy(dataStorage.address, accessControl.address);
  await reporting.deployed();
  console.log("ESGReporting deployed to:", reporting.address);
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });