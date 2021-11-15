//SPDX-License-Identifier: Unlicense

pragma solidity 0.8.4;

interface IPriceConsumer {
    /**
     * @notice Returns the latest price
     * @return latest price
     */
    function getLatestPrice() external view returns (uint256);
}
