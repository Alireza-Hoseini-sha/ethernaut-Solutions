// Сan you get the item from the shop for less than the price asked?

// Things that might help:
// Shop expects to be used from a Buyer
// Understanding restrictions of view functions

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface IBuyer {
    function price() external view returns (uint256);
}

contract Shop {
    uint256 public price = 100;
    bool public isSold;

    function buy() public {
        IBuyer _buyer = IBuyer(msg.sender);

        if (_buyer.price() >= price && !isSold) {
            isSold = true;
            price = _buyer.price();
        }
    }
}
