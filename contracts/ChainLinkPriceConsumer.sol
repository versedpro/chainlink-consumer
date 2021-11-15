//SPDX-License-Identifier: Unlicense

pragma solidity 0.8.4;

import "@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "./interfaces/IPriceConsumer.sol";

contract ChainLinkPriceConsumer is Ownable, IPriceConsumer {

    AggregatorV3Interface internal priceFeed;

    /**
     * Network: Binance Smart Chain(Mainnet)
     * Aggregator: BNB/USD
     * Address: 0x0567F2323251f0Aab15c8dFb1967E4e8A7D42aeE
     */
    constructor(address _aggregator) {
        priceFeed = AggregatorV3Interface(_aggregator);
    }

    function setPriceFeed(address _aggregatorAddress) external onlyOwner {
        priceFeed = AggregatorV3Interface(_aggregatorAddress);
    }

    function getLatestRoundData() external view onlyOwner returns (
        uint80,
        int,
        uint,
        uint,
        uint80
    ) {
        return priceFeed.latestRoundData();
    }

    /**
     * @notice Returns the latest price
     * @return latest price
     */
    function getLatestPrice() external override view returns (uint256) {
        (, int price,,,) = priceFeed.latestRoundData();
        return uint256(price);
    }
}