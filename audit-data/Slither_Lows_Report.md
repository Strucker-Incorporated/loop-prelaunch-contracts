Summary
 - [missing-zero-check](#missing-zero-check) (2 results) (Low)
 - [reentrancy-benign](#reentrancy-benign) (3 results) (Low)
 - [reentrancy-events](#reentrancy-events) (7 results) (Low)
 - [timestamp](#timestamp) (2 results) (Low)
 
## missing-zero-check
Impact: Low
Confidence: Medium
 - [ ] ID-0
[PrelaunchPoints.proposeOwner(address)._owner](src/PrelaunchPoints.sol#L358) lacks a zero-check on :
		- [proposedOwner = _owner](src/PrelaunchPoints.sol#L359)

src/PrelaunchPoints.sol#L358


 - [ ] ID-1
[PrelaunchPoints.constructor(address,address,address[])._exchangeProxy](src/PrelaunchPoints.sol#L102) lacks a zero-check on :
		- [exchangeProxy = _exchangeProxy](src/PrelaunchPoints.sol#L104)

src/PrelaunchPoints.sol#L102


## reentrancy-benign
Impact: Low
Confidence: Medium
 - [ ] ID-2
Reentrancy in [PrelaunchPoints._processLock(address,uint256,address,bytes32)](src/PrelaunchPoints.sol#L177-L206):
	External calls:
	- [WETH.deposit{value: _amount}()](src/PrelaunchPoints.sol#L190)
	State variables written after the call(s):
	- [balances[_receiver][address(WETH)] += _amount](src/PrelaunchPoints.sol#L192)
	- [totalSupply += _amount](src/PrelaunchPoints.sol#L191)

src/PrelaunchPoints.sol#L177-L206


 - [ ] ID-3
Reentrancy in [PrelaunchPoints.convertAllETH()](src/PrelaunchPoints.sol#L336-L352):
	External calls:
	- [WETH.approve(address(lpETH),totalSupply)](src/PrelaunchPoints.sol#L342)
	- [lpETH.deposit(totalSupply,address(this))](src/PrelaunchPoints.sol#L343)
	State variables written after the call(s):
	- [totalLpETH = lpETH.balanceOf(address(this))](src/PrelaunchPoints.sol#L346)

src/PrelaunchPoints.sol#L336-L352


 - [ ] ID-4
Reentrancy in [PrelaunchPoints._processLock(address,uint256,address,bytes32)](src/PrelaunchPoints.sol#L177-L206):
	External calls:
	- [IERC20(_token).safeTransferFrom(msg.sender,address(this),_amount)](src/PrelaunchPoints.sol#L197)
	State variables written after the call(s):
	- [balances[_receiver][_token] += _amount](src/PrelaunchPoints.sol#L202)
	- [totalSupply += _amount](src/PrelaunchPoints.sol#L200)

src/PrelaunchPoints.sol#L177-L206


## reentrancy-events
Impact: Low
Confidence: Medium
 - [ ] ID-5
Reentrancy in [PrelaunchPoints._fillQuote(IERC20,uint256,bytes)](src/PrelaunchPoints.sol#L530-L547):
	External calls:
	- [! _sellToken.approve(exchangeProxy,_amount)](src/PrelaunchPoints.sol#L534)
	- [(success,None) = address(exchangeProxy).call{value: 0}(_swapCallData)](src/PrelaunchPoints.sol#L538)
	External calls sending eth:
	- [(success,None) = address(exchangeProxy).call{value: 0}(_swapCallData)](src/PrelaunchPoints.sol#L538)
	Event emitted after the call(s):
	- [SwappedTokens(address(_sellToken),_amount,boughtWETHAmount)](src/PrelaunchPoints.sol#L546)

src/PrelaunchPoints.sol#L530-L547


 - [ ] ID-6
Reentrancy in [PrelaunchPoints.withdraw(address)](src/PrelaunchPoints.sol#L306-L328):
	External calls:
	- [IERC20(_token).safeTransfer(msg.sender,lockedAmount)](src/PrelaunchPoints.sol#L325)
	Event emitted after the call(s):
	- [Withdrawn(msg.sender,_token,lockedAmount)](src/PrelaunchPoints.sol#L327)

src/PrelaunchPoints.sol#L306-L328


 - [ ] ID-7
Reentrancy in [PrelaunchPoints.convertAllETH()](src/PrelaunchPoints.sol#L336-L352):
	External calls:
	- [WETH.approve(address(lpETH),totalSupply)](src/PrelaunchPoints.sol#L342)
	- [lpETH.deposit(totalSupply,address(this))](src/PrelaunchPoints.sol#L343)
	Event emitted after the call(s):
	- [Converted(totalSupply,totalLpETH)](src/PrelaunchPoints.sol#L351)

src/PrelaunchPoints.sol#L336-L352


 - [ ] ID-8
Reentrancy in [PrelaunchPoints._claim(address,address,uint8,PrelaunchPoints.Exchange,bytes)](src/PrelaunchPoints.sol#L260-L298):
	External calls:
	- [lpETH.safeTransfer(_receiver,claimedAmount)](src/PrelaunchPoints.sol#L281)
	- [_fillQuote(IERC20(_token),userClaim,_data)](src/PrelaunchPoints.sol#L290)
		- [! _sellToken.approve(exchangeProxy,_amount)](src/PrelaunchPoints.sol#L534)
		- [(success,None) = address(exchangeProxy).call{value: 0}(_swapCallData)](src/PrelaunchPoints.sol#L538)
	- [WETH.approve(address(lpETH),claimedAmount)](src/PrelaunchPoints.sol#L294)
	- [lpETH.deposit(claimedAmount,_receiver)](src/PrelaunchPoints.sol#L295)
	External calls sending eth:
	- [_fillQuote(IERC20(_token),userClaim,_data)](src/PrelaunchPoints.sol#L290)
		- [(success,None) = address(exchangeProxy).call{value: 0}(_swapCallData)](src/PrelaunchPoints.sol#L538)
	Event emitted after the call(s):
	- [Claimed(msg.sender,_token,claimedAmount)](src/PrelaunchPoints.sol#L297)

src/PrelaunchPoints.sol#L260-L298


 - [ ] ID-9
Reentrancy in [PrelaunchPoints.recoverERC20(address,uint256)](src/PrelaunchPoints.sol#L416-L423):
	External calls:
	- [IERC20(tokenAddress).safeTransfer(owner,tokenAmount)](src/PrelaunchPoints.sol#L420)
	Event emitted after the call(s):
	- [Recovered(tokenAddress,tokenAmount)](src/PrelaunchPoints.sol#L422)

src/PrelaunchPoints.sol#L416-L423

 
 - [ ] ID-11
Reentrancy in [PrelaunchPoints._processLock(address,uint256,address,bytes32)](src/PrelaunchPoints.sol#L177-L206):
	External calls:
	- [WETH.deposit{value: _amount}()](src/PrelaunchPoints.sol#L190)
	- [IERC20(_token).safeTransferFrom(msg.sender,address(this),_amount)](src/PrelaunchPoints.sol#L197)
	External calls sending eth:
	- [WETH.deposit{value: _amount}()](src/PrelaunchPoints.sol#L190)
	Event emitted after the call(s):
	- [Locked(_receiver,_amount,_token,_referral)](src/PrelaunchPoints.sol#L205)

src/PrelaunchPoints.sol#L177-L206


## timestamp
Impact: Low
Confidence: Medium
 - [ ] ID-12
[PrelaunchPoints.convertAllETH()](src/PrelaunchPoints.sol#L336-L352) uses timestamp for comparisons
	Dangerous comparisons:
	- [block.timestamp - loopActivation <= TIMELOCK](src/PrelaunchPoints.sol#L337)

src/PrelaunchPoints.sol#L336-L352


 - [ ] ID-13
[PrelaunchPoints.withdraw(address)](src/PrelaunchPoints.sol#L306-L328) uses timestamp for comparisons
	Dangerous comparisons:
	- [block.timestamp >= startClaimDate](src/PrelaunchPoints.sol#L308)
	- [block.timestamp >= startClaimDate](src/PrelaunchPoints.sol#L320)

src/PrelaunchPoints.sol#L306-L328


