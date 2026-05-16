// SPDX-License-Identifier: MIT

pragma solidity 0.8.24;

import {Test, console2} from "forge-std/Test.sol";
import {Brute} from "script/Solve.s.sol";
import {GatekeeperOne} from "src/GatekeeperOne.sol";

contract test is Test {
    Brute brute;
    GatekeeperOne gateKeeper;
    uint256 offset;
    function setUp() external {
        gateKeeper = GatekeeperOne(0x34b7Ca25810Bca22CE934e9A86D02c6aBEBE387A);
        brute = new Brute(gateKeeper);
    }

    function testGas() public { //gas needed is 256
        for(offset = 0; offset < 8191; offset++){
            try brute.callGatekeeperOne(offset) {
                console2.log("gas needed: ", offset);
            }
            catch {}
        }
    }
}