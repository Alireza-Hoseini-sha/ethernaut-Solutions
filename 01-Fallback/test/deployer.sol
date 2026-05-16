// SPDX-License-Identifier: MIT

pragma solidity 0.8.0;

import "../src/Fallback.sol";



contract Deployer {
    Fallback public ethernaut1;
    function deploy() public returns (address){
         ethernaut1 = new Fallback();
         return address(ethernaut1);
    }
}