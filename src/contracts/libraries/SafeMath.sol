// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

library SafeMath {

    function add(uint x, uint y) internal pure returns(uint256) {

        uint256 r = x + y;
        require(r >= x, "Error: Safemath addition overflow");
        return r;

    }

    function sub(uint x, uint y) internal pure returns(uint256) {

        require(y <= x, "Error: Safemath subtraction overflow");
        uint256 r = x - y;
        return r;

    }

    function mul(uint x, uint y) internal pure returns(uint256) {

        if(x == 0) {
            return 0;
        }

        uint256 r = x * y;
        require(r / x == y, "Error: Safemath multiplication overflow");
        return r;

    }

    function div(uint x, uint y) internal pure returns(uint256) {

        require(y > 0, "Error: Safemath division overflow");
        uint256 r = x / y;
        return r;

    }

    function mod(uint x, uint y) internal pure returns(uint256) {

        require(y != 0, "Error: Safemath Modulo overflow");
        return x % y;

    }
}