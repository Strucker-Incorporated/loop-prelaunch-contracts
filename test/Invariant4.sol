function invariant_correctEthToLpETHConversion() public view returns (bool) {
    uint256 initialETH = address(this).balance;
    uint256 expectedLpETH = initialETH; // Assuming 1:1 conversion rate
    uint256 actualLpETH = contractInstance.lpETH().balanceOf(address(this));
    return actualLpETH >= expectedLpETH;
}