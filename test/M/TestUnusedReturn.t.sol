// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

import "forge-std/Test.sol";
import "../../src/PrelaunchPoints.sol";
import "../../src/mock/MockERC20.sol";

contract TestUnusedReturn is Test {
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

    function testClaim() external {
        ERC20Token token = new ERC20Token();
        token.mint(address(this), 1000 ether);
        token.approve(address(prelaunchPoints), 1000 ether);

        // Lock token
        prelaunchPoints.lock(address(token), 1000 ether, bytes32("testReferral"));

        // Claim functionality
        uint8 percentage = 100;
        bytes memory data = abi.encodePacked(uint32(1), address(token));
        prelaunchPoints.claim(address(token), percentage, PrelaunchPoints.Exchange.UniswapV3, data);
    }
}
