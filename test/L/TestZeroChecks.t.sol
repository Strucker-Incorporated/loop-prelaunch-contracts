// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

// Contract with missing zero address checks
contract TestZeroChecks {
    address public proposedOwner;
    address public lpETH;
    address public lpETHVault;

    function setOwner(address _owner) external {
        proposedOwner = _owner; // Missing zero address check
    }

    function setLoopAddresses(address _loopAddress, address _vaultAddress) external {
        lpETH = _loopAddress; // Missing zero address check
        lpETHVault = _vaultAddress; // Missing zero address check
    }
}
