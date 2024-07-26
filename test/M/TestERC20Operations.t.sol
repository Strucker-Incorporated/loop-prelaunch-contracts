// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

import "forge-std/Test.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

// Contract demonstrating unsafe ERC20 operations
contract TestERC20Operations is Test {
    ERC20 public token;
    address public spender;

    constructor(address _token, address _spender) {
        token = ERC20(_token);
        spender = _spender;
    }

    function testApprove() external {
        uint256 amount = 100;
        // Potentially failing `approve` call
        token.approve(spender, amount);
        // No validation if approval was successful
    }
}
