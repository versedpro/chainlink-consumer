//SPDX-License-Identifier: Unlicense

pragma solidity ^0.8.4;

interface IPriceConsumer {
    /**
     * @notice Returns the latest price
     * @param _pair Supported currency pair
     * @return latest price
     */
    function getLatestPrice(address _pair)
        external
        view
        returns (uint256);
}
