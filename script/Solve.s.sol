// SPDX-License-Identifier: MIT

pragma solidity 0.8.24;

import {Script, console} from "forge-std/Script.sol";
import {MagicNum} from "src/MagicNumber.sol";

contract Attack {
    MagicNum target;

    constructor(MagicNum _target) {
        target = _target;
    }

    function deploy() external {
        bytes memory bytecode = hex"69602a60005260206000f3600052600a6016f3"; //contract bytcodes that always return 42 no matter what;
        address addr;
        assembly {
            addr := create(0, add(bytecode, 0x20), 0x13)
        }
        target.setSolver(addr);
    }
}

contract Solve is Script {
    Attack attack;
    MagicNum target;
    address instanceAddre = 0xd7F67256Dbb9A3DDdA194c2d21B8d4e5a3c77dCA;

    function run() external {
        target = MagicNum(instanceAddre);
        vm.startBroadcast();
        attack = new Attack(target);
        attack.deploy();
        vm.stopBroadcast();
    }
}
