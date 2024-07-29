// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Arbitrary {
    address public target;
    bool public attackMode = false; // Toggle attack mode
    uint256 public attackAmount = 0;

    constructor(address _target) {
        target = _target;
    }

    receive() external payable {
        if (attackMode) {
            // Trigger the attack by sending ETH to the target address
            (bool success, ) = target.call{value: attackAmount}("");
            require(success, "Transfer failed.");
        }
    }

    function setAttackMode(bool _attackMode) external {
        attackMode = _attackMode;
    }

    function setAttackAmount(uint256 _amount) external {
        attackAmount = _amount;
    }
}
