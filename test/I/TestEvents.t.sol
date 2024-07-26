// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

import "forge-std/Test.sol";
import "../../src/PrelaunchPoints.sol";
import "../../src/mock/MockERC20.sol";

// Contract with events missing indexed fields
contract TestEvents {
    event StakedVault(address user, uint256 amount, uint256 typeIndex);
    event Converted(uint256 amountETH, uint256 amountlpETH);

    function stake(address user, uint256 amount, uint256 typeIndex) external {
        emit StakedVault(user, amount, typeIndex);
    }

    function convert(uint256 amountETH, uint256 amountlpETH) external {
        emit Converted(amountETH, amountlpETH);
    }
}
