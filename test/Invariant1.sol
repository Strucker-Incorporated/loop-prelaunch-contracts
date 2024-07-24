function invariant_onlyOwnerCanSetLRTs() public view returns (bool) {
    return contractInstance.isOwner(msg.sender) || !contractInstance.isLRTChangeRestricted();
}

function invariant_onlyOwnerCanChangeEmergencyMode() public view returns (bool) {
    return contractInstance.isOwner(msg.sender) || !contractInstance.isEmergencyModeChangeRestricted();
}

function invariant_onlyOwnerCanSetNewOwner() public view returns (bool) {
    return contractInstance.isOwner(msg.sender) || !contractInstance.isOwnerChangeRestricted();
}