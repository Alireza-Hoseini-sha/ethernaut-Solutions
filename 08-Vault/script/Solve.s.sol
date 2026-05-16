// SPDX-License-Identifier: MIT

pragma solidity 0.8.24;

import {Script} from "forge-std/Script.sol";
import {Vault} from "../src/Vault.sol";

contract Solve is Script {
    Vault vault;
    address VaultAddr = 0x2E80eA6E80583997Df0720808DE835eF07595F4D;
    bytes32 private password = "A very strong secret password :)";
    function run() external {
        vault = Vault(VaultAddr);

        vm.startBroadcast();
        vault.unlock(password);
        vm.stopBroadcast();
        require(!vault.locked(), "failed to unlock the vault");
    }
}