// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

import "forge-std/Test.sol";
import "../../src/PrelaunchPoints.sol";
import "../../src/mock/MockERC20.sol";

contract TestUninitialized is Test {
    PrelaunchPoints prelaunchPoints;
    address exchangeProxy = address(0x1234567890123456789012345678901234567890);
    address wethAddress = address(0x1234567890123456789012345678901234567891);
    address[] allowedTokens;

    function setUp() public {
        // Deploy mock token
        ERC20Token mockToken = new ERC20Token();
        allowedTokens.push(address(mockToken));

        // Deploy the PrelaunchPoints contract
        prelaunchPoints = new PrelaunchPoints(
            exchangeProxy,
            wethAddress,
            allowedTokens
        );
    }

    function testLockETH() external {
        bytes32 referral = bytes32("testReferral");

        // Lock ETH with a referral
        prelaunchPoints.lockETH{value: 1 ether}(referral);
    }

    function testLockToken() external {
        bytes32 referral = bytes32("testReferral");
        ERC20Token token = new ERC20Token();
        token.mint(address(this), 1000 ether);

        // Approve and lock token
        token.approve(address(prelaunchPoints), 1000 ether);
        prelaunchPoints.lock(address(token), 1000 ether, referral);
    }
}
