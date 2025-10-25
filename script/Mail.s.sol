// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Script} from "forge-std/Script.sol";
import {Mail} from "src/Mail.sol";

contract MailScript is Script {
    Mail public mail;

    function setUp() public {}

    function run() public {
        vm.startBroadcast();

        mail = new Mail();

        vm.stopBroadcast();
    }
}
