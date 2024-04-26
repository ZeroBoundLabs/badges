//SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

// Useful for debugging. Remove when deploying to a live network.
import "forge-std/console.sol";
import {ERC1155Upgradeable} from "oz-upgradeable/token/ERC1155/ERC1155Upgradeable.sol";

import "@openzeppelin/utils/ReentrancyGuard.sol";
import "@openzeppelin/token/ERC1155/utils/ERC1155Holder.sol";
import "@openzeppelin/utils/structs/EnumerableSet.sol";

/**
 * A smart contract that allows changing a state variable of the contract and tracking the changes
 * It also allows the owner to withdraw the Ether in the contract
 * @author BuidlGuidl
 */
contract HyperStaking is ReentrancyGuard, ERC1155Holder {
    using EnumerableSet for EnumerableSet.UintSet;

    ERC1155Upgradeable public immutable stakingToken;

    // Mapping from user address to mapping of token ID to Stake details
    mapping(address => mapping(uint256 => Stake)) public stakes;

    // Mapping to keep track of which token IDs each address has staked
    mapping(address => EnumerableSet.UintSet) private _stakedTokens;

    struct Stake {
        uint256 amount;
        uint256 timestamp;
    }

    // Events: a way to emit log statements from smart contract that can be listened to by external parties
    event Staked(
        address indexed user,
        uint256 indexed tokenId,
        uint256 amount,
        uint256 timestamp
    );
    event Unstaked(
        address indexed user,
        uint256 indexed tokenId,
        uint256 amount,
        uint256 timestamp
    );

    // Constructor: Called once on contract deployment
    // Check packages/foundry/script/Deploy.s.sol
    constructor(address _stakingToken) {
        stakingToken = ERC1155Upgradeable(_stakingToken);
    }

    function stake(uint256 id, uint256 amount) external nonReentrant {
        require(amount > 0, "Amount must be greater than 0");
        console.log("In Stake function", msg.sender, id, amount);
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
        stakes[msg.sender][id].amount += amount;
        stakes[msg.sender][id].timestamp = block.timestamp;

        // // Add the token ID to the user's staked tokens set
        _stakedTokens[msg.sender].add(id);

        emit Staked(msg.sender, id, amount, block.timestamp);
    }

    // Rewritten function to return the staked amount for a given tokenId and user
    function stakedAmount(
        address user,
        uint256 tokenId
    ) external view returns (uint256) {
        return stakes[user][tokenId].amount;
    }
}
