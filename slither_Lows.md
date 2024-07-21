Summary
 - [missing-zero-check](#missing-zero-check) (2 results) (Low)
 - [reentrancy-benign](#reentrancy-benign) (3 results) (Low)
 - [reentrancy-events](#reentrancy-events) (7 results) (Low)
 - [timestamp](#timestamp) (2 results) (Low)
## missing-zero-check
Impact: Low
Confidence: Medium
 - [ ] ID-0
[PrelaunchPoints.proposeOwner(address)._owner](src/PrelaunchPoints.sol#L378) lacks a zero-check on :
		- [proposedOwner = _owner](src/PrelaunchPoints.sol#L379)

src/PrelaunchPoints.sol#L378


 - [ ] ID-1
[PrelaunchPoints.constructor(address,address,address[])._exchangeProxy](src/PrelaunchPoints.sol#L116) lacks a zero-check on :
		- [exchangeProxy = _exchangeProxy](src/PrelaunchPoints.sol#L121)

src/PrelaunchPoints.sol#L116


## reentrancy-benign
Impact: Low
Confidence: Medium
 - [ ] ID-2
Reentrancy in [PrelaunchPoints._processLock(address,uint256,address,bytes32)](src/PrelaunchPoints.sol#L199-L225):
	External calls:
	- [WETH.deposit{value: _amount}()](src/PrelaunchPoints.sol#L209)
	State variables written after the call(s):
	- [balances[_receiver][address(WETH)] += _amount](src/PrelaunchPoints.sol#L211)
	- [totalSupply += _amount](src/PrelaunchPoints.sol#L210)

src/PrelaunchPoints.sol#L199-L225


 - [ ] ID-3
Reentrancy in [PrelaunchPoints._processLock(address,uint256,address,bytes32)](src/PrelaunchPoints.sol#L199-L225):
	External calls:
	- [IERC20(_token).safeTransferFrom(msg.sender,address(this),_amount)](src/PrelaunchPoints.sol#L216)
	State variables written after the call(s):
	- [balances[_receiver][_token] += _amount](src/PrelaunchPoints.sol#L221)
	- [totalSupply += _amount](src/PrelaunchPoints.sol#L219)

src/PrelaunchPoints.sol#L199-L225


 - [ ] ID-4
Reentrancy in [PrelaunchPoints.convertAllETH()](src/PrelaunchPoints.sol#L352-L372):
	External calls:
	- [WETH.approve(address(lpETH),totalSupply)](src/PrelaunchPoints.sol#L362)
	- [lpETH.deposit(totalSupply,address(this))](src/PrelaunchPoints.sol#L363)
	State variables written after the call(s):
	- [totalLpETH = lpETH.balanceOf(address(this))](src/PrelaunchPoints.sol#L366)

src/PrelaunchPoints.sol#L352-L372


## reentrancy-events
Impact: Low
Confidence: Medium
 - [ ] ID-5
Reentrancy in [PrelaunchPoints._processLock(address,uint256,address,bytes32)](src/PrelaunchPoints.sol#L199-L225):
	External calls:
	- [WETH.deposit{value: _amount}()](src/PrelaunchPoints.sol#L209)
	- [IERC20(_token).safeTransferFrom(msg.sender,address(this),_amount)](src/PrelaunchPoints.sol#L216)
	External calls sending eth:
	- [WETH.deposit{value: _amount}()](src/PrelaunchPoints.sol#L209)
	Event emitted after the call(s):
	- [Locked(_receiver,_amount,_token,_referral)](src/PrelaunchPoints.sol#L224)

src/PrelaunchPoints.sol#L199-L225


 - [ ] ID-6
Reentrancy in [PrelaunchPoints._fillQuote(IERC20,uint256,bytes)](src/PrelaunchPoints.sol#L581-L602):
	External calls:
	- [! _sellToken.approve(exchangeProxy,_amount)](src/PrelaunchPoints.sol#L589)
	- [(success,None) = address(exchangeProxy).call{value: 0}(_swapCallData)](src/PrelaunchPoints.sol#L593)
	External calls sending eth:
	- [(success,None) = address(exchangeProxy).call{value: 0}(_swapCallData)](src/PrelaunchPoints.sol#L593)
	Event emitted after the call(s):
	- [SwappedTokens(address(_sellToken),_amount,boughtWETHAmount)](src/PrelaunchPoints.sol#L601)

src/PrelaunchPoints.sol#L581-L602


 - [ ] ID-7
Reentrancy in [PrelaunchPoints.convertAllETH()](src/PrelaunchPoints.sol#L352-L372):
	External calls:
	- [WETH.approve(address(lpETH),totalSupply)](src/PrelaunchPoints.sol#L362)
	- [lpETH.deposit(totalSupply,address(this))](src/PrelaunchPoints.sol#L363)
	Event emitted after the call(s):
	- [Converted(totalSupply,totalLpETH)](src/PrelaunchPoints.sol#L371)

src/PrelaunchPoints.sol#L352-L372


 - [ ] ID-8
Reentrancy in [PrelaunchPoints._claim(address,address,uint8,PrelaunchPoints.Exchange,bytes)](src/PrelaunchPoints.sol#L279-L314):
	External calls:
	- [lpETH.safeTransfer(_receiver,claimedAmount)](src/PrelaunchPoints.sol#L297)
	- [_fillQuote(IERC20(_token),userClaim,_data)](src/PrelaunchPoints.sol#L306)
		- [! _sellToken.approve(exchangeProxy,_amount)](src/PrelaunchPoints.sol#L589)
		- [(success,None) = address(exchangeProxy).call{value: 0}(_swapCallData)](src/PrelaunchPoints.sol#L593)
	- [WETH.approve(address(lpETH),claimedAmount)](src/PrelaunchPoints.sol#L310)
	- [lpETH.deposit(claimedAmount,_receiver)](src/PrelaunchPoints.sol#L311)
	External calls sending eth:
	- [_fillQuote(IERC20(_token),userClaim,_data)](src/PrelaunchPoints.sol#L306)
		- [(success,None) = address(exchangeProxy).call{value: 0}(_swapCallData)](src/PrelaunchPoints.sol#L593)
	Event emitted after the call(s):
	- [Claimed(msg.sender,_token,claimedAmount)](src/PrelaunchPoints.sol#L313)

src/PrelaunchPoints.sol#L279-L314


 - [ ] ID-9
Reentrancy in [PrelaunchPoints.claimAndStake(address,uint8,PrelaunchPoints.Exchange,uint256,bytes)](src/PrelaunchPoints.sol#L256-L274):
	External calls:
	- [claimedAmount = _claim(_token,address(this),_percentage,_exchange,_data)](src/PrelaunchPoints.sol#L263-L269)
		- [returndata = address(token).functionCall(data)](lib/openzeppelin-contracts/contracts/token/ERC20/utils/SafeERC20.sol#L96)
		- [! _sellToken.approve(exchangeProxy,_amount)](src/PrelaunchPoints.sol#L589)
		- [(success,None) = address(exchangeProxy).call{value: 0}(_swapCallData)](src/PrelaunchPoints.sol#L593)
		- [(success,returndata) = target.call{value: value}(data)](lib/openzeppelin-contracts/contracts/utils/Address.sol#L87)
		- [lpETH.safeTransfer(_receiver,claimedAmount)](src/PrelaunchPoints.sol#L297)
		- [WETH.approve(address(lpETH),claimedAmount)](src/PrelaunchPoints.sol#L310)
		- [lpETH.deposit(claimedAmount,_receiver)](src/PrelaunchPoints.sol#L311)
	- [lpETH.approve(address(lpETHVault),claimedAmount)](src/PrelaunchPoints.sol#L270)
	- [lpETHVault.stake(claimedAmount,msg.sender,_typeIndex)](src/PrelaunchPoints.sol#L271)
	External calls sending eth:
	- [claimedAmount = _claim(_token,address(this),_percentage,_exchange,_data)](src/PrelaunchPoints.sol#L263-L269)
		- [(success,None) = address(exchangeProxy).call{value: 0}(_swapCallData)](src/PrelaunchPoints.sol#L593)
		- [(success,returndata) = target.call{value: value}(data)](lib/openzeppelin-contracts/contracts/utils/Address.sol#L87)
	Event emitted after the call(s):
	- [StakedVault(msg.sender,claimedAmount,_typeIndex)](src/PrelaunchPoints.sol#L273)

src/PrelaunchPoints.sol#L256-L274


 - [ ] ID-10
Reentrancy in [PrelaunchPoints.recoverERC20(address,uint256)](src/PrelaunchPoints.sol#L432-L442):
	External calls:
	- [IERC20(tokenAddress).safeTransfer(owner,tokenAmount)](src/PrelaunchPoints.sol#L439)
	Event emitted after the call(s):
	- [Recovered(tokenAddress,tokenAmount)](src/PrelaunchPoints.sol#L441)

src/PrelaunchPoints.sol#L432-L442


 - [ ] ID-11
Reentrancy in [PrelaunchPoints.withdraw(address)](src/PrelaunchPoints.sol#L322-L344):
	External calls:
	- [IERC20(_token).safeTransfer(msg.sender,lockedAmount)](src/PrelaunchPoints.sol#L341)
	Event emitted after the call(s):
	- [Withdrawn(msg.sender,_token,lockedAmount)](src/PrelaunchPoints.sol#L343)

src/PrelaunchPoints.sol#L322-L344


## timestamp
Impact: Low
Confidence: Medium
 - [ ] ID-12
[PrelaunchPoints.convertAllETH()](src/PrelaunchPoints.sol#L352-L372) uses timestamp for comparisons
	Dangerous comparisons:
	- [block.timestamp - loopActivation <= TIMELOCK](src/PrelaunchPoints.sol#L357)

src/PrelaunchPoints.sol#L352-L372


 - [ ] ID-13
[PrelaunchPoints.withdraw(address)](src/PrelaunchPoints.sol#L322-L344) uses timestamp for comparisons
	Dangerous comparisons:
	- [block.timestamp >= startClaimDate](src/PrelaunchPoints.sol#L324)
	- [block.timestamp >= startClaimDate](src/PrelaunchPoints.sol#L336)

src/PrelaunchPoints.sol#L322-L344


