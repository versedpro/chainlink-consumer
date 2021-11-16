// SPDX-License-Identifier: MIT

pragma solidity ^0.8.4;

library SupportedPair {
    uint32 public constant BNBUSD = 0x1;
    uint32 public constant BUSDBNB = 0x2;
    uint32 public constant CAKEBNB = 0x3;
    uint32 public constant ADABNB = 0x4;
    uint32 public constant DOTBNB = 0x5;
    uint32 public constant ETHBNB = 0x6;
    uint32 public constant USDTUSD = 0x7;

    function isSupportedPair(uint32 _pair) internal pure returns (bool) {
        if (
            _pair == BNBUSD ||
            _pair == BUSDBNB ||
            _pair == CAKEBNB ||
            _pair == ADABNB ||
            _pair == DOTBNB ||
            _pair == ETHBNB ||
            _pair == USDTUSD
        ) {
            return true;
        }
        return false;
    }
}