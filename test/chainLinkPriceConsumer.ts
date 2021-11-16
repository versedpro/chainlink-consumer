import { expect } from "chai";
import { Contract } from "ethers";
import { ethers } from "hardhat";
import { chainLink } from "../settings";

describe("ChainLinkPriceConsumer", async () => {

  let priceConsumer: Contract;

  beforeEach(async () => {
    const ChainLinkPriceConsumer = await ethers.getContractFactory(
      "ChainLinkPriceConsumer"
    );

    priceConsumer = await ChainLinkPriceConsumer.deploy();
    await priceConsumer.deployed();

    const MockAggregatorV3 = await ethers.getContractFactory(
      "MockAggregatorV3"
    );

    await Object.values(chainLink.testnet).reduce(
      async (promise, value, currentIndex) => {
      await promise;
      const address = value;
      if (address.length < 1) return;
      const pairId = currentIndex + 1;

      const mockAggregatorV3 = await MockAggregatorV3.deploy();
      await mockAggregatorV3.deployed();

      await priceConsumer.registerPriceFeed(
        pairId,
        mockAggregatorV3.address
      );
    }, Promise.resolve());
  });

  it("should return latest round data", async () => {

    await Object.values(chainLink.testnet).reduce(async (
      promise, value, currentIndex
    ) => {
      await promise;
      const address = value;
      if (address.length < 1) return;

      const [
        roundId,
        answer,
        startedAt,
        updatedAt,
        answeredInRound
      ] = await priceConsumer.getLatestRoundData(currentIndex + 1);
  
      expect(answer > 0).to.equal(true, "unexpected answer.");
    }, Promise.resolve());
  });

  it("should return latest price", async () => {
    await Object.values(chainLink.testnet).reduce(async (
      promise, value, currentIndex
    ) => {
      await promise;
      const address = value;
      if (address.length < 1) return;
      const price = await priceConsumer.getLatestPrice(currentIndex + 1);
      expect(price > 0).to.equal(true, "unexpected price.");
    }, Promise.resolve());
  });
});