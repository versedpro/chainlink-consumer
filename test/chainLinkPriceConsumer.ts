import { expect } from "chai";
import { Contract } from "ethers";
import { ethers } from "hardhat";
import { chainLink } from "../settings";

describe("ChainLinkPriceConsumer", function () {

  let priceConsumer: Contract;

  beforeEach(async () => {
    const ChainLinkPriceConsumer = await ethers.getContractFactory(
      "ChainLinkPriceConsumer"
    );

    priceConsumer = await ChainLinkPriceConsumer.deploy(
      chainLink.testnet.BNBUSD
    );
    await priceConsumer.deployed();
  });

  it("should return latest round data", async () => {
    const [
      roundId,
      answer,
      startedAt,
      updatedAt,
      answeredInRound
    ] = await priceConsumer.getLatestRoundData();

    console.log('roundId', roundId);
    console.log('answer', answer);
    console.log('startedAt', startedAt);
    console.log('updatedAt', updatedAt);
    console.log('answeredInRound', answeredInRound);

    expect(answer > 0).to.equal(true, "unexpected answer.")
  });

  it("should return latest price", async () => {
    const price = await priceConsumer.getLatestPrice();

    console.log('price', price.toString());

    expect(price > 0).to.equal(true, "unexpected price.")
  });
});