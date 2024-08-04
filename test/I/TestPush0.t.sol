// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

import "forge-std/Test.sol";
import "../../src/PrelaunchPoints.sol";
import "../../src/mock/MockERC20.sol";

// Contract demonstrating PUSH0 compatibility issues
contract TestPush0 {
    function testPush0() external pure returns (string memory) {
        return "Test";
    }
}
