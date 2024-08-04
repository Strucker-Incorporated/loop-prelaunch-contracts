// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "forge-std/Test.sol";
import "../../src/PrelaunchPoints.sol";
import "../../src/mock/MockERC20.sol"; // Correct import path based on your contract structure

contract TestArbitrarySend is Test {
    PrelaunchPoints public prelaunchPoints;
    ERC20Token public mockToken; 
    ERC20Token public WETH; // Define WETH as ERC20Token
    address public exchangeProxy = 0x01fd869eBC05D8aD3F65a978D0a1307D406Ce627; // Update to actual address

    // Additional allowed tokens
    address[] public allowedTokens;

    function setUp() public {
        // Deploy the ERC20Token contract
        mockToken = new ERC20Token();
        WETH = new ERC20Token(); // Deploy the WETH mock contract

        // Mint tokens to this contract or another relevant address
        mockToken.mint(address(this), 1000 * 10**18); // Mint tokens with 18 decimals
        WETH.mint(address(this), 1000 * 10**18); // Mint WETH with 18 decimals

        // Set allowed tokens
        allowedTokens.push(address(mockToken));
        allowedTokens.push(address(WETH));

        // Deploy the PrelaunchPoints contract with the correct arguments
        prelaunchPoints = new PrelaunchPoints(
            exchangeProxy,          // Address for the exchange proxy
            address(WETH),          // Address for the WETH token
            allowedTokens           // Array of allowed tokens
        );

        // Approve the PrelaunchPoints contract to spend the mock tokens
        mockToken.approve(address(prelaunchPoints), 1000 * 10**18);
        WETH.approve(address(prelaunchPoints), 1000 * 10**18);
    }

    function testExploit() public {
        // Define the swap data; replace with actual encoding based on your exchangeProxy contract
        bytes memory swapData = abi.encodeWithSignature(
            "swap(address,uint256,address,bytes)",
            address(mockToken),
            1000 * 10**18,
            address(WETH),
            new bytes(0)
        );

        // Ensure _fillQuote exists and is correctly defined
        // If it's internal or private, use a testable function or adjust visibility in the contract
        (bool success, ) = address(prelaunchPoints).call(
            abi.encodeWithSignature(
                "_fillQuote(address,uint256,bytes)",
                address(mockToken),
                1000 * 10**18,
                swapData
            )
        );
        require(success, "Function call failed");

        // Assertions
        uint256 postSwapTokenBalance = mockToken.balanceOf(address(this));
        uint256 postSwapWETHBalance = WETH.balanceOf(address(prelaunchPoints));

        // Verify that the token balance is reduced
        assertEq(postSwapTokenBalance, 0, "Mock token balance should be zero after swap");

        // Verify that the WETH balance of PrelaunchPoints increased
        assertTrue(postSwapWETHBalance > 0, "WETH balance of PrelaunchPoints should be greater than zero after swap");
    }
}
