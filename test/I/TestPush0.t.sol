// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

// Contract demonstrating PUSH0 compatibility issues
contract TestPush0 {
    function testPush0() external pure returns (string memory) {
        return "Test";
    }
}
