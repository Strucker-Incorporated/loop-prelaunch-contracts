## Summary
 - [uninitialized-local](#uninitialized-local) (3 results) (Medium)
 - [unused-return](#unused-return) (5 results) (Medium)



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


