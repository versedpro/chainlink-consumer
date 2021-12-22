//SPDX-License-Identifier: Unlicense

pragma solidity ^0.8.4;

import "hardhat/console.sol";
import "@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "./interfaces/IPriceConsumer.sol";

/**
 * ChainLink Price Consumer Contract for BNB/USD, BUSD/BNB,
 * CAKE/BNB, ADA/BNB, DOT/BNB, ETH/BNB, USDT/USD.
 *
 * Network: Binance Smart Chain(Mainnet)
 * Aggregator: BNB/USD
 * Address: 0x0567F2323251f0Aab15c8dFb1967E4e8A7D42aeE
 */
contract ChainLinkPriceConsumer is Ownable, IPriceConsumer {

    uint256 public constant defaultDigits = 8;

    mapping(address => address) public feedRegistry;
    mapping(address => uint256) public priceDigits;

    /**
     * @notice Register price feed aggregator per pair
     * @param _pair Supported currency pair
     * @param _aggregatorAddress Aggregator address
     *      https://docs.chain.link/docs/binance-smart-chain-addresses/
     * @param _digits price digits
     */
    function registerPriceFeed(
        address _pair,
        address _aggregatorAddress,
        uint256 _digits
    ) external onlyOwner {
        require(_pair != address(0), "Non zero pair");
        require(_aggregatorAddress != address(0), "Non zero aggregator");
        feedRegistry[_pair] = _aggregatorAddress;
        priceDigits[_pair] = _digits;
    }

    /**
     * @notice Get data from the latest round
     * @param _pair Supported currency pair
     * @return roundId The round ID
     * @return answer The price
     * @return startedAt Timestamp of when the round started
     * @return updatedAt Timestamp of when the round was updated
     * @return answeredInRound Timestamp of when the round was updated
     */
    function getLatestRoundData(address _pair)
        external
        view
        onlyOwner
        returns
    (
        uint80 roundId,
        int answer,
        uint startedAt,
        uint updatedAt,
        uint80 answeredInRound
    ) {
        require(_pair != address(0), "Non zero pair");
        address priceFeed = feedRegistry[_pair];
        require(priceFeed != address(0), "Not registered pair");

        return AggregatorV3Interface(priceFeed).latestRoundData();
    }

    /**
     * @notice Returns the latest price
     * @param _pair Supported currency pair
     * @return the latest price
     */
    function getLatestPrice(address _pair)
        external
        override
        view
        returns (uint256)
    {
        require(_pair != address(0), "Non zero pair");
        address priceFeed = feedRegistry[_pair];
        require(priceFeed != address(0), "Not registered pair");

        (, int price,,,) = AggregatorV3Interface(priceFeed).latestRoundData();
        return uint256(price) / 10 ** (priceDigits[_pair] - defaultDigits);
    }
}