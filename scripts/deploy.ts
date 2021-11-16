import { SignerWithAddress } from "@nomiclabs/hardhat-ethers/signers";
import { ethers, network, run } from "hardhat";
import { NomicLabsHardhatPluginError } from "hardhat/plugins";
import { chainLink } from "../settings";

async function main() {
  const signers = await ethers.getSigners();
  let deployer: SignerWithAddress | undefined;
  signers.forEach(signer => {
    if (signer.address === process.env.DEPLOYER_ADDRESS) {
      deployer = signer;
    }
  });
  if (!deployer) {
    throw new Error(`${process.env.DEPLOYER_ADDRESS} not found in signers!`);
  }

  if (network.name === "testnet" || network.name === "mainnet") {
    // Saving the info to be logged in the table (deployer address)
    const deployerLog = { Label: 'Deploying Address', Info: deployer.address };
    // Saving the info to be logged in the table (deployer address)
    const deployerBalanceLog = {
      Label: 'Deployer BNB Balance',
      Info: ethers.utils.formatEther(await deployer!.getBalance()),
    };

    const ChainLinkPriceConsumerFactory = await ethers.getContractFactory(
      "ChainLinkPriceConsumer"
    );

    // Deploy the contract
    const priceConsumerInst = await ChainLinkPriceConsumerFactory.deploy();
    await priceConsumerInst.deployed();

    try {
      // Verify the contract
      await run('verify:verify', {
        address: priceConsumerInst.address,
        constructorArguments: [],
      });

    } catch (error) {
      if (error instanceof NomicLabsHardhatPluginError) {
        console.log("Contract source code already verified");
      } else {
        console.error(error);
      }
    }

    // Set the contract functions
    await Object.values(chainLink[network.name]).reduce(
      async (promise, value, currentIndex) => {
      await promise;
      const address = value;
      if (address.length < 1) return;
      const pairId = currentIndex + 1;
      await priceConsumerInst.registerPriceFeed(pairId, address);
    }, Promise.resolve());

    const priceConsumerLog = {
      Label: 'Deployed Price Consumer Token Address',
      Info: priceConsumerInst.address
    };

    console.table([deployerLog, deployerBalanceLog, priceConsumerLog]);

  } else {
    throw new Error("Not found network");
  }
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
