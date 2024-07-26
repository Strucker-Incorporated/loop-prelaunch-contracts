// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

import "forge-std/Test.sol";
import "../../src/PrelaunchPoints.sol";
import "../../src/mock/MockERC20.sol";

contract TestHelper is PrelaunchPoints {
    event FillQuoteExecuted(address indexed sellToken, uint256 amount, bytes swapCallData);

    constructor(
        address _exchangeProxy,
        address _wethAddress,
        address[] memory _allowedTokens
    ) PrelaunchPoints(_exchangeProxy, _wethAddress, _allowedTokens) {}

    // Expose the internal _fillQuote function for testing
    function exposeFillQuote(
        IERC20 _sellToken,
        uint256 _amount,
        bytes calldata _swapCallData
    ) public {
        _fillQuote(_sellToken, _amount, _swapCallData);
        emit FillQuoteExecuted(address(_sellToken), _amount, _swapCallData); // Emit event for testing
    }
}

contract TestArbitrarySend is Test {
    TestHelper prelaunchPoints;
    ERC20Token mockToken;

    address exchangeProxy = address(0x1234567890123456789012345678901234567890);
    address wethAddress = address(0x1234567890123456789012345678901234567891);
    address[] allowedTokens;

    event FillQuoteExecuted(address indexed sellToken, uint256 amount, bytes swapCallData);

    function setUp() public {
        // Deploy the mock token
        mockToken = new ERC20Token();
        allowedTokens.push(address(mockToken));

        // Add another valid token if needed
        allowedTokens.push(address(0x1234567890123456789012345678901234567892)); // Replace with a valid token address

        // Deploy the TestHelper contract with initial parameters
        prelaunchPoints = new TestHelper(
            exchangeProxy,
            wethAddress,
            allowedTokens
        );

        // Mint some mock tokens for testing
        mockToken.mint(address(this), 1000 ether);
    }

    function testExploit() external {
    uint256 amount = 1 ether; // Example amount to be used in the test

    // Setup mock data for the swap call
    bytes memory swapCallData = ""; // Replace with appropriate data if needed

    // Approve the TestHelper contract to spend mock tokens
    mockToken.approve(address(prelaunchPoints), amount);

    // Record the initial ETH balance and token balance of the contract
    uint256 initialBalance = address(prelaunchPoints).balance;
    uint256 initialTokenBalance = mockToken.balanceOf(address(prelaunchPoints));

    // Trigger the _fillQuote function using the TestHelper contract
    try prelaunchPoints.exposeFillQuote(mockToken, amount, swapCallData) {
        // Fetch the new ETH balance and token balance of the contract
        uint256 newBalance = address(prelaunchPoints).balance;
        uint256 finalTokenBalance = mockToken.balanceOf(address(prelaunchPoints));

        // Assert that the balance has changed as expected
        assertGt(newBalance, initialBalance, "ETH balance should increase after calling _fillQuote");
        assertEq(finalTokenBalance, initialTokenBalance - amount, "Mock token balance should decrease after calling _fillQuote");
    } catch Error(string memory reason) {
        fail(reason);
    } catch (bytes memory lowLevelData) {
        fail(string(lowLevelData));
    }
}

}
