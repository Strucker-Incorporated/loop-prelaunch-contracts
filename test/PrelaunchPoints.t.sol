// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Test.sol";
import "../src/PrelaunchPoints.sol";
import "../src/MockLpETH.sol";
import "../src/MockLpETHVault.sol";

contract PrelaunchPointsTest is Test {
    PrelaunchPoints prelaunchPoints;
    MockLpETH lpETH;
    MockLpETHVault lpETHVault;
    address constant EXCHANGE_PROXY = 0xdef1c0ded9bec7f1a1670819833240f027b25eff;
    address constant WETH = 0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2;

    function setUp() public {
        lpETH = new MockLpETH();
        lpETHVault = new MockLpETHVault();
        prelaunchPoints = new PrelaunchPoints(EXCHANGE_PROXY, WETH, new address );
    }

    function testClaimAfterDeposit() public {
        address depositor = address(0x123); // Use a fixed address for fuzzing
        vm.deal(depositor, 100 ether);
        vm.startPrank(depositor);
        // Add deposit logic and assertions
        vm.stopPrank();
    }

    function testClaimAndStakeAfterDeposit() public {
        address depositor = address(0x123); // Use a fixed address for fuzzing
        vm.deal(depositor, 100 ether);
        vm.startPrank(depositor);
        // Add deposit logic and assertions
        vm.stopPrank();
    }
}
