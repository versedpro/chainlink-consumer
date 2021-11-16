//SPDX-License-Identifier: Unlicense

pragma solidity ^0.8.4;

import "@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";

contract MockAggregatorV3 is AggregatorV3Interface {

    uint8 private _decimals = 18;
    string private _description = "BNBUSD";
    uint256 private _version = 1;

    uint80 private _roundId = 18446744073709776538;
    int256 private _answer = 58299439916;
    uint256 private _startedAt = 1637064487;
    uint256 private _updatedAt = 1637064487;
    uint80 private _answeredInRound = 18446744073709776538;

    function decimals() external override view returns (uint8) {
        return _decimals;
    }
    
    function description() external override view returns (string memory) {
        return _description;
    }
    
    function version() external override view returns (uint256) {
        return _version;
    }
    
    function getRoundData(uint80 _roundIdT) external override view returns (
        uint80 roundId,
        int256 answer,
        uint256 startedAt,
        uint256 updatedAt,
        uint80 answeredInRound
    ) {
        return (
            _roundId,
            _answer,
            _startedAt,
            _updatedAt,
            _answeredInRound
        );
    }
    
    function latestRoundData() external override view returns (
        uint80 roundId,
        int256 answer,
        uint256 startedAt,
        uint256 updatedAt,
        uint80 answeredInRound
    ) {
        return (
            _roundId,
            _answer,
            _startedAt,
            _updatedAt,
            _answeredInRound
        );
    }
}