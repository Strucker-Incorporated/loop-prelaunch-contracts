// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

import "forge-std/Test.sol";
import "../src/PrelaunchPoints.sol";
import "../src/mock/MockERC20.sol";

// Malicious Contract to exploit arbitrary ETH sending
contract Malicious {
    receive() external payable {
        // Reentrancy or malicious logic to exploit the received ETH
    }
}

// Contract using PrelaunchPoints
contract TestArbitrarySend is Test {
    PrelaunchPoints prelaunchPoints;
    ERC20Token mockToken;
    Malicious malicious;

    address exchangeProxy = address(0x1234567890123456789012345678901234567890);
    address wethAddress = address(0x1234567890123456789012345678901234567891);
    address[] allowedTokens;

    function setUp() public {
        // Set up allowed tokens (you may need to deploy mock tokens if necessary)
        allowedTokens.push(address(0x1234567890123456789012345678901234567892)); // Replace with a valid token address

        // Deploy the mock token
        mockToken = new ERC20Token();
        allowedTokens.push(address(mockToken));

        // Deploy the PrelaunchPoints contract
        prelaunchPoints = new PrelaunchPoints(exchangeProxy, wethAddress, allowedTokens);

        // Deploy the Malicious contract
        malicious = new Malicious();
    }

    function exploit() external {
        bytes memory swapCallData = abi.encodeWithSignature("maliciousFunction()");
        // Trigger the _fillQuote function to send ETH to the malicious contract
        prelaunchPoints._fillQuote(swapCallData);
    }
}
