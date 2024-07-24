function invariant_depositsActiveUntilAddressesSet() public view returns (bool) {
    bool depositsActive = contractInstance.depositsActive();
    bool addressesSet = contractInstance.lpETH() != address(0) && contractInstance.lpETHVault() != address(0);
    return depositsActive || addressesSet;
}