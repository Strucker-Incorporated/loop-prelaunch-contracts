Summary
 - [divide-before-multiply](#divide-before-multiply) (8 results) (Medium)
 - [locked-ether](#locked-ether) (1 results) (Medium)
 - [reentrancy-no-eth](#reentrancy-no-eth) (1 results) (Medium)
 - [uninitialized-local](#uninitialized-local) (3 results) (Medium)
 - [unused-return](#unused-return) (5 results) (Medium)

## reentrancy-no-eth
Impact: Medium
Confidence: Medium
 - [ ] ID-9
Reentrancy in [PrelaunchPoints.convertAllETH()](src/PrelaunchPoints.sol#L336-L352):
	External calls:
	- [WETH.approve(address(lpETH),totalSupply)](src/PrelaunchPoints.sol#L342)
	- [lpETH.deposit(totalSupply,address(this))](src/PrelaunchPoints.sol#L343)
	State variables written after the call(s):
	- [startClaimDate = uint32(block.timestamp)](src/PrelaunchPoints.sol#L349)
	[PrelaunchPoints.startClaimDate](src/PrelaunchPoints.sol#L47) can be used in cross function reentrancies:
	- [PrelaunchPoints._processLock(address,uint256,address,bytes32)](src/PrelaunchPoints.sol#L177-L206)
	- [PrelaunchPoints.claim(address,uint8,PrelaunchPoints.Exchange,bytes)](src/PrelaunchPoints.sol#L219-L229)
	- [PrelaunchPoints.claimAndStake(address,uint8,PrelaunchPoints.Exchange,uint256,bytes)](src/PrelaunchPoints.sol#L240-L255)
	- [PrelaunchPoints.constructor(address,address,address[])](src/PrelaunchPoints.sol#L102-L119)
	- [PrelaunchPoints.convertAllETH()](src/PrelaunchPoints.sol#L336-L352)
	- [PrelaunchPoints.startClaimDate](src/PrelaunchPoints.sol#L47)
	- [PrelaunchPoints.withdraw(address)](src/PrelaunchPoints.sol#L306-L328)

src/PrelaunchPoints.sol#L336-L352


## uninitialized-local
Impact: Medium
Confidence: Medium
 - [ ] ID-10
[PrelaunchPoints._validateData(address,uint256,PrelaunchPoints.Exchange,bytes).inputTokenAmount](src/PrelaunchPoints.sol#L445) is a local variable never initialized

src/PrelaunchPoints.sol#L445


 - [ ] ID-11
[PrelaunchPoints._validateData(address,uint256,PrelaunchPoints.Exchange,bytes).outputToken](src/PrelaunchPoints.sol#L444) is a local variable never initialized

src/PrelaunchPoints.sol#L444


 - [ ] ID-12
[PrelaunchPoints._validateData(address,uint256,PrelaunchPoints.Exchange,bytes).inputToken](src/PrelaunchPoints.sol#L443) is a local variable never initialized

src/PrelaunchPoints.sol#L443


## unused-return
Impact: Medium
Confidence: Medium
 - [ ] ID-13
[PrelaunchPoints._claim(address,address,uint8,PrelaunchPoints.Exchange,bytes)](src/PrelaunchPoints.sol#L260-L298) ignores return value by [WETH.approve(address(lpETH),claimedAmount)](src/PrelaunchPoints.sol#L294)

src/PrelaunchPoints.sol#L260-L298


 - [ ] ID-14
[PrelaunchPoints.convertAllETH()](src/PrelaunchPoints.sol#L336-L352) ignores return value by [WETH.approve(address(lpETH),totalSupply)](src/PrelaunchPoints.sol#L342)

src/PrelaunchPoints.sol#L336-L352


 - [ ] ID-15
[PrelaunchPoints.convertAllETH()](src/PrelaunchPoints.sol#L336-L352) ignores return value by [lpETH.deposit(totalSupply,address(this))](src/PrelaunchPoints.sol#L343)

src/PrelaunchPoints.sol#L336-L352


 - [ ] ID-16
[PrelaunchPoints._claim(address,address,uint8,PrelaunchPoints.Exchange,bytes)](src/PrelaunchPoints.sol#L260-L298) ignores return value by [lpETH.deposit(claimedAmount,_receiver)](src/PrelaunchPoints.sol#L295)

src/PrelaunchPoints.sol#L260-L298


 - [ ] ID-17
[PrelaunchPoints.claimAndStake(address,uint8,PrelaunchPoints.Exchange,uint256,bytes)](src/PrelaunchPoints.sol#L240-L255) ignores return value by [lpETH.approve(address(lpETHVault),claimedAmount)](src/PrelaunchPoints.sol#L251)

src/PrelaunchPoints.sol#L240-L255


