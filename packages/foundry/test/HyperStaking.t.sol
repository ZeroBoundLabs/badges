// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.20;

import "forge-std/Test.sol";
import "../contracts/HyperStaking.sol";
import "hypercerts-contracts/HypercertMinter.sol";
import {IHypercertToken} from "hypercerts-contracts/interfaces/IHypercertToken.sol";

contract HyperStakingTest is Test {
    HypercertMinter public hypercertMinter;
    HyperStaking public stakingContract;
    address public testUser;
    ERC1155Upgradeable public tokenContract;
    string internal _uri;
    event ClaimStored(uint256 indexed claimID, string uri, uint256 totalUnits);
    uint256 public testClaimId;

    function setUp() public {
        hypercertMinter = new HypercertMinter();
        stakingContract = new HyperStaking(address(hypercertMinter));
        testUser = vm.addr(1);
        tokenContract = ERC1155Upgradeable(address(hypercertMinter));

        // Mint tokens to the testUser
        uint256 units = 100;
        _uri = "ipfs://bafybeigdyrzt5sfp7udm7hu76uh7y26nf3efuylqabf3oclgtqy55fbzdi";
        // Setup expectations for the event emission
        vm.startPrank(testUser);
        vm.recordLogs(); // Start recording logs

        vm.expectEmit(false, false, false, true);
        emit ClaimStored(0x100000000000000000000000000000001, _uri, units); // Adjust this line if more parameters need to match exactly

        hypercertMinter.mintClaim(
            testUser,
            units,
            _uri,
            IHypercertToken.TransferRestrictions.AllowAll
        );

        vm.stopPrank();

        // Retrieve and decode logs to capture claimID
        Vm.Log[] memory logs = vm.getRecordedLogs();
        uint256 capturedClaimID;
        bool foundClaimID = false;

        for (uint256 i = 0; i < logs.length; i++) {
            if (
                logs[i].topics[0] ==
                keccak256("ClaimStored(uint256,string,uint256)")
            ) {
                capturedClaimID = uint256(logs[i].topics[1]);
                console.log("ClaimStored: claimID found", capturedClaimID);

                foundClaimID = true;
                break;
            }
        }

        testClaimId = capturedClaimID;
    }

    function testStake() public {
        vm.prank(testUser);
        uint256 balance = hypercertMinter.balanceOf(testUser, testClaimId);

        vm.prank(testUser);
        tokenContract.setApprovalForAll(address(stakingContract), true);
        vm.prank(testUser);
        stakingContract.stake(testClaimId, balance);

        uint256 stakedAmount = stakingContract.stakedAmount(
            testUser,
            testClaimId
        );
        vm.stopPrank();

        assertEq(stakedAmount, balance, "not equal");
    }
}
