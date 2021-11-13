// deploy/00_deploy_your_contract.js

const { ethers } = require("hardhat");

module.exports = async ({ getNamedAccounts, deployments }) => {
  const { deploy } = deployments;
  const { deployer } = await getNamedAccounts();
  await deploy("Balloons", {
    // Learn more about args here: https://www.npmjs.com/package/hardhat-deploy#deploymentsdeploy
    from: deployer,
    //args: [ "Hello", ethers.utils.parseEther("1.5") ],
    log: true,
  });

  const balloons = await ethers.getContract("Balloons", deployer);

  await deploy("DEX", {
    // Learn more about args here: https://www.npmjs.com/package/hardhat-deploy#deploymentsdeploy
    from: deployer,
    args: [ balloons.address],
    log: true,
  });

  const dex = await ethers.getContract("DEX", deployer);
  
  // paste in your address here to get 10 balloons on deploy:
  await balloons.transfer("0x79522998AF5Ce9895842ab7a6210b5E224C089d2",""+(10*10**18));

  // uncomment to init DEX on deploy:
  console.log("Approving DEX ("+dex.address+") to take Balloons from main account...");
  // If you are going to the testnet make sure your deployer account has enough ETH
  await balloons.approve(dex.address,ethers.utils.parseEther('100'));
  console.log("INIT exchange...");
  await dex.init(""+(3*10**18),{value:ethers.utils.parseEther('3')});

};
module.exports.tags = ["YourContract"];
