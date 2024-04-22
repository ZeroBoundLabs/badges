// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.17;

import "forge-std/Test.sol";
import "../contracts/HyperStaking.sol";
import "hypercerts-contracts/HypercertMinter.sol";

contract HyperStakingTest is Test {
    HypercertMinter public hypercertMinter;
    HyperStaking public hyperStaking;

    function setUp() public {
        hypercertMinter = new HypercertMinter();
        //hyperStaking = new HyperStaking();
    }

    function testMessageOnDeployment() public view {
        // require(
        //     keccak256(bytes(yourContract.greeting())) ==
        //         keccak256("Building Unstoppable Apps!!!")
        // );
    }

    function testSetNewMessage() public {
        // yourContract.setGreeting("Learn Scaffold-ETH 2! :)");
        // require(
        //     keccak256(bytes(yourContract.greeting())) ==
        //         keccak256("Learn Scaffold-ETH 2! :)")
        // );
    }
}
