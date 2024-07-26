// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

import "forge-std/Test.sol";
import "../src/PrelaunchPoints.sol"; // Adjust the path according to your directory structure
import "src/mock/MockERC20.sol";

contract PrelaunchPointsTest is Test {
    PrelaunchPoints prelaunchPoints;
    ERC20Token mockToken;
    address exchangeProxy = address(0x1234567890123456789012345678901234567890); // Replace with a valid address
    address wethAddress = address(0x1234567890123456789012345678901234567891); // Replace with a valid address
    address[] allowedTokens;

    function setUp() public {
        // Set up allowed tokens (you may need to deploy mock tokens if necessary)
        allowedTokens.push(address(0x1234567890123456789012345678901234567892)); // Replace with a valid token address

        // Deploy the mock token
        mockToken = new ERC20Token();
        allowedTokens.push(address(mockToken));

        // Deploy the PrelaunchPoints contract
        prelaunchPoints = new PrelaunchPoints(
            exchangeProxy,
            wethAddress,
            allowedTokens
        );
    }

    function testLockETH() public payable {
        // Assuming you want to test lockETH functionality
        bytes32 referral = bytes32("testReferral");
        prelaunchPoints.lockETH{value: 1 ether}(referral);

        // Add your assertions and checks here
    }

    function testLockToken() public {
        // Assuming you want to test lock functionality for tokens
        mockToken.mint(address(this), 1000 ether); // Mint tokens to the test address
        mockToken.approve(address(prelaunchPoints), 1000 ether);
        bytes32 referral = bytes32("testReferral");
        prelaunchPoints.lock(address(mockToken), 1000 ether, referral);

        // Add your assertions and checks here
    }

    function testClaim() public {
        // Test claim function
        // Setup for claim (lock some tokens or ETH first if necessary)
        bytes32 referral = bytes32("testReferral");
        prelaunchPoints.lock(address(mockToken), 1000 ether, referral);

        // Add code to call claim and check the results
    }
}
