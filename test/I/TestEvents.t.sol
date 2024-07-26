// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

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
