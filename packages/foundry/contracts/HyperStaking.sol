//SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

// Useful for debugging. Remove when deploying to a live network.
import "forge-std/console.sol";
import {IHypercertToken} from "hypercerts-contracts/interfaces/IHypercertToken.sol";

import "@openzeppelin/utils/ReentrancyGuard.sol";

/**
 * A smart contract that allows changing a state variable of the contract and tracking the changes
 * It also allows the owner to withdraw the Ether in the contract
 * @author BuidlGuidl
 */
contract HyperStaking is ReentrancyGuard {
    IHypercertToken public immutable stakingToken;

    // Mapping from user address to mapping of token ID to Stake details
    mapping(address => mapping(uint256 => Stake)) public stakes;

    // Events: a way to emit log statements from smart contract that can be listened to by external parties
    event Stake(address staker, uint256 amountStaked);

    // Constructor: Called once on contract deployment
    // Check packages/foundry/script/Deploy.s.sol
    constructor(address _stakingToken) {
        stakingToken = IHypercertToken(_stakingToken);
    }

    function stake(uint256 id, uint256 amount) external nonReentrant {
        require(amount > 0, "Amount must be greater than 0");
        require(
            stakingToken.balanceOf(msg.sender, id) >= amount,
            "Insufficient balance"
        );

        // Transfer the tokens to this contract for staking
        stakingToken.safeTransferFrom(
            msg.sender,
            address(this),
            id,
            amount,
            ""
        );

        // Update the stake details
        // stakes[msg.sender][id].amount += amount;
        // stakes[msg.sender][id].timestamp = block.timestamp;

        // // Add the token ID to the user's staked tokens set
        // _stakedTokens[msg.sender].add(id);

        // emit Staked(msg.sender, id, amount, block.timestamp);
    }
}
