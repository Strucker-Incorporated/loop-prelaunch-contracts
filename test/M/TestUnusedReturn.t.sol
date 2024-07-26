// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

import "forge-std/Test.sol";
import "../src/PrelaunchPoints.sol";

// Contract demonstrating failure due to unused return values
contract TestUnusedReturn is Test {
    PrelaunchPoints prelaunchPoints;

    address exchangeProxy = address(0x1234567890123456789012345678901234567890);
    address wethAddress = address(0x1234567890123456789012345678901234567891);
    address[] allowedTokens;

    function setUp() public {
        // Set up allowed tokens (you may need to deploy mock tokens if necessary)
        allowedTokens.push(address(0x1234567890123456789012345678901234567892)); // Replace with a valid token address

        // Deploy the mock token
        ERC20Token mockToken = new ERC20Token();
        allowedTokens.push(address(mockToken));

        // Deploy the PrelaunchPoints contract
        prelaunchPoints = new PrelaunchPoints(exchangeProxy, wethAddress, allowedTokens);
    }

    function testFunction() external {
        uint256 amount = 100;
        address exchangeProxy = address(0x123);

        // Failing to handle return value
        prelaunchPoints._sellToken.approve(exchangeProxy, amount);
    }
}
