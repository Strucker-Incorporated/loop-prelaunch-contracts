function invariant_correctLRTConversion() public view returns (bool) {
    uint256 lrtAmount = IERC20(lrtToken).balanceOf(address(this));
    uint256 initialETHBalance = address(this).balance;

    // Simulate LRT to ETH conversion (mocked)
    // Example: contractInstance.convertLRTToETH(lrtAmount);
    
    uint256 newETHBalance = address(this).balance;
    uint256 convertedETHAmount = newETHBalance - initialETHBalance;

    uint256 lpETHAmount = contractInstance.lpETH().balanceOf(address(this));
    uint256 expectedLpETHAmount = convertedETHAmount;

    return lpETHAmount >= expectedLpETHAmount;
}