function invariant_withdrawalsActive() public view returns (bool) {
    bool isEmergencyMode = contractInstance.isEmergencyMode();
    bool isWithin7Days = block.timestamp <= contractInstance.loopActivation() + 7 days;
    return isEmergencyMode || isWithin7Days;
}