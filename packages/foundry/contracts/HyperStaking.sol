//SPDX-License-Identifier: MIT
pragma solidity >=0.8.0 <0.9.0;

// Useful for debugging. Remove when deploying to a live network.
import "forge-std/console.sol";
import {IHypercertToken} from "hypercerts-contracts/interfaces/IHypercertToken.sol";

// Use openzeppelin to inherit battle-tested implementations (ERC20, ERC721, etc)
// import "@openzeppelin/contracts/access/Ownable.sol";

/**
 * A smart contract that allows changing a state variable of the contract and tracking the changes
 * It also allows the owner to withdraw the Ether in the contract
 * @author BuidlGuidl
 */
contract HyperStaking {
    IHypercertToken public immutable stakingToken;

    // Events: a way to emit log statements from smart contract that can be listened to by external parties
    event Stake(address staker, uint256 amountStaked);

    // Constructor: Called once on contract deployment
    // Check packages/foundry/script/Deploy.s.sol
    constructor(address _stakingToken) {
        stakingToken = IHypercertToken(_stakingToken);
    }
}
