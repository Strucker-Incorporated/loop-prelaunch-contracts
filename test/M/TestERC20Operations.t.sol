// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

import "forge-std/Test.sol";
import "../../src/PrelaunchPoints.sol";
import "../../src/mock/MockERC20.sol";

contract MockERC20Wrapper {
    ERC20Token public token;
    bool public simulateApproveFailure;

    constructor(address _token) {
        token = ERC20Token(_token);
    }

    function setSimulateApproveFailure(bool _simulateFailure) external {
        simulateApproveFailure = _simulateFailure;
    }

    function approve(address spender, uint256 amount) external returns (bool) {
        if (simulateApproveFailure) {
            return false; // Simulate failure
        }
        return token.approve(spender, amount);
    }

    function balanceOf(address account) external view returns (uint256) {
        return token.balanceOf(account);
    }

    function allowance(address owner, address spender) external view returns (uint256) {
        return token.allowance(owner, spender);
    }
}

contract TestERC20Operations is Test {
    PrelaunchPoints prelaunchPoints;
    ERC20Token erc20Token;
    MockERC20Wrapper mockERC20Wrapper; // Wrapper for simulating failures

    address exchangeProxy = address(0x1234567890123456789012345678901234567890);
    address wethAddress = address(0x1234567890123456789012345678901234567891);
    address[] allowedTokens;

    // Set up the initial state for testing
    function setUp() public {
        // Deploy the ERC20 token
        erc20Token = new ERC20Token();
        allowedTokens.push(address(erc20Token));

        // Deploy the MockERC20Wrapper with the ERC20 token address
        mockERC20Wrapper = new MockERC20Wrapper(address(erc20Token));

        // Deploy the PrelaunchPoints contract
        prelaunchPoints = new PrelaunchPoints(
            exchangeProxy,
            wethAddress,
            allowedTokens
        );

        // Mint some tokens for testing
        erc20Token.mint(address(this), 1000 ether);
    }

    function testApprove() external {
        uint256 amount = 100 ether; // Amount to approve
        address spender = address(0x000000000000000000000000000000000000ABcD); // Example spender address

        // Simulate failure in the approve function
        mockERC20Wrapper.setSimulateApproveFailure(true);

        // Attempt to approve the spender to use the mock token
        bool approvalSuccess = mockERC20Wrapper.approve(spender, amount);

        // Check the allowance
        uint256 allowance = mockERC20Wrapper.allowance(address(this), spender);

        // Assert that the approval fails as expected
        assertFalse(approvalSuccess, "Approve call should fail");
        assertEq(allowance, 0, "Allowance should not be set if approval fails");

        // Reset the flag to normal behavior
        mockERC20Wrapper.setSimulateApproveFailure(false);

        // Approve again to check normal behavior
        bool approvalSuccessNormal = mockERC20Wrapper.approve(spender, amount);

        // Check the allowance
        uint256 allowanceNormal = mockERC20Wrapper.allowance(address(this), spender);

        // Assert that the approval succeeds and allowance is set correctly
        assertTrue(approvalSuccessNormal, "Approval should succeed");
        assertEq(allowanceNormal, amount, "Allowance should be set correctly");

        // Example: Ensure PrelaunchPoints does not handle unverified approvals incorrectly
        uint256 prelaunchPointsAllowance = mockERC20Wrapper.allowance(address(prelaunchPoints), address(this));
        assertEq(prelaunchPointsAllowance, 0, "PrelaunchPoints should not have approval by default");

        // Example: Check the token balance in PrelaunchPoints contract if applicable
        uint256 prelaunchPointsBalance = mockERC20Wrapper.balanceOf(address(prelaunchPoints));
        assertEq(prelaunchPointsBalance, 0, "PrelaunchPoints balance should be zero initially");
    }
}
