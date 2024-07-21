Summary
 - [arbitrary-send-eth](#arbitrary-send-eth) (1 results) (High)
 - [incorrect-exp](#incorrect-exp) (1 results) (High)
 - [divide-before-multiply](#divide-before-multiply) (8 results) (Medium)
 - [locked-ether](#locked-ether) (1 results) (Medium)
 - [reentrancy-no-eth](#reentrancy-no-eth) (1 results) (Medium)
 - [uninitialized-local](#uninitialized-local) (3 results) (Medium)
 - [unused-return](#unused-return) (5 results) (Medium)
 - [missing-zero-check](#missing-zero-check) (2 results) (Low)
 - [reentrancy-benign](#reentrancy-benign) (3 results) (Low)
 - [reentrancy-events](#reentrancy-events) (7 results) (Low)
 - [timestamp](#timestamp) (2 results) (Low)
 - [assembly](#assembly) (4 results) (Informational)
 - [pragma](#pragma) (1 results) (Informational)
 - [low-level-calls](#low-level-calls) (6 results) (Informational)
 - [reentrancy-unlimited-gas](#reentrancy-unlimited-gas) (1 results) (Informational)
 - [constable-states](#constable-states) (4 results) (Optimization)
 - [immutable-states](#immutable-states) (1 results) (Optimization)
## arbitrary-send-eth
Impact: High
Confidence: Medium
 - [ ] ID-0
[PrelaunchPoints._fillQuote(IERC20,uint256,bytes)](src/PrelaunchPoints.sol#L581-L602) sends eth to arbitrary user
	Dangerous calls:
	- [(success,None) = address(exchangeProxy).call{value: 0}(_swapCallData)](src/PrelaunchPoints.sol#L593)

src/PrelaunchPoints.sol#L581-L602


## incorrect-exp
Impact: High
Confidence: Medium
 - [ ] ID-1
[Math.mulDiv(uint256,uint256,uint256)](lib/openzeppelin-contracts/contracts/utils/math/Math.sol#L123-L202) has bitwise-xor operator ^ instead of the exponentiation operator **: 
	 - [inverse = (3 * denominator) ^ 2](lib/openzeppelin-contracts/contracts/utils/math/Math.sol#L184)

lib/openzeppelin-contracts/contracts/utils/math/Math.sol#L123-L202


## divide-before-multiply
Impact: Medium
Confidence: Medium
 - [ ] ID-2
[Math.mulDiv(uint256,uint256,uint256)](lib/openzeppelin-contracts/contracts/utils/math/Math.sol#L123-L202) performs a multiplication on the result of a division:
	- [denominator = denominator / twos](lib/openzeppelin-contracts/contracts/utils/math/Math.sol#L169)
	- [inverse *= 2 - denominator * inverse](lib/openzeppelin-contracts/contracts/utils/math/Math.sol#L190)

lib/openzeppelin-contracts/contracts/utils/math/Math.sol#L123-L202


 - [ ] ID-3
[Math.mulDiv(uint256,uint256,uint256)](lib/openzeppelin-contracts/contracts/utils/math/Math.sol#L123-L202) performs a multiplication on the result of a division:
	- [denominator = denominator / twos](lib/openzeppelin-contracts/contracts/utils/math/Math.sol#L169)
	- [inverse *= 2 - denominator * inverse](lib/openzeppelin-contracts/contracts/utils/math/Math.sol#L193)

lib/openzeppelin-contracts/contracts/utils/math/Math.sol#L123-L202


 - [ ] ID-4
[Math.mulDiv(uint256,uint256,uint256)](lib/openzeppelin-contracts/contracts/utils/math/Math.sol#L123-L202) performs a multiplication on the result of a division:
	- [denominator = denominator / twos](lib/openzeppelin-contracts/contracts/utils/math/Math.sol#L169)
	- [inverse *= 2 - denominator * inverse](lib/openzeppelin-contracts/contracts/utils/math/Math.sol#L188)

lib/openzeppelin-contracts/contracts/utils/math/Math.sol#L123-L202


 - [ ] ID-5
[Math.mulDiv(uint256,uint256,uint256)](lib/openzeppelin-contracts/contracts/utils/math/Math.sol#L123-L202) performs a multiplication on the result of a division:
	- [denominator = denominator / twos](lib/openzeppelin-contracts/contracts/utils/math/Math.sol#L169)
	- [inverse = (3 * denominator) ^ 2](lib/openzeppelin-contracts/contracts/utils/math/Math.sol#L184)

lib/openzeppelin-contracts/contracts/utils/math/Math.sol#L123-L202


 - [ ] ID-6
[Math.mulDiv(uint256,uint256,uint256)](lib/openzeppelin-contracts/contracts/utils/math/Math.sol#L123-L202) performs a multiplication on the result of a division:
	- [prod0 = prod0 / twos](lib/openzeppelin-contracts/contracts/utils/math/Math.sol#L172)
	- [result = prod0 * inverse](lib/openzeppelin-contracts/contracts/utils/math/Math.sol#L199)

lib/openzeppelin-contracts/contracts/utils/math/Math.sol#L123-L202


 - [ ] ID-7
[Math.mulDiv(uint256,uint256,uint256)](lib/openzeppelin-contracts/contracts/utils/math/Math.sol#L123-L202) performs a multiplication on the result of a division:
	- [denominator = denominator / twos](lib/openzeppelin-contracts/contracts/utils/math/Math.sol#L169)
	- [inverse *= 2 - denominator * inverse](lib/openzeppelin-contracts/contracts/utils/math/Math.sol#L192)

lib/openzeppelin-contracts/contracts/utils/math/Math.sol#L123-L202


 - [ ] ID-8
[Math.mulDiv(uint256,uint256,uint256)](lib/openzeppelin-contracts/contracts/utils/math/Math.sol#L123-L202) performs a multiplication on the result of a division:
	- [denominator = denominator / twos](lib/openzeppelin-contracts/contracts/utils/math/Math.sol#L169)
	- [inverse *= 2 - denominator * inverse](lib/openzeppelin-contracts/contracts/utils/math/Math.sol#L191)

lib/openzeppelin-contracts/contracts/utils/math/Math.sol#L123-L202


 - [ ] ID-9
[Math.mulDiv(uint256,uint256,uint256)](lib/openzeppelin-contracts/contracts/utils/math/Math.sol#L123-L202) performs a multiplication on the result of a division:
	- [denominator = denominator / twos](lib/openzeppelin-contracts/contracts/utils/math/Math.sol#L169)
	- [inverse *= 2 - denominator * inverse](lib/openzeppelin-contracts/contracts/utils/math/Math.sol#L189)

lib/openzeppelin-contracts/contracts/utils/math/Math.sol#L123-L202


## locked-ether
Impact: Medium
Confidence: High
 - [ ] ID-10
Contract locking ether found:
	Contract [AttackContract](src/mock/AttackContract.sol#L6-L40) has payable functions:
	 - [AttackContract.receive()](src/mock/AttackContract.sol#L28-L39)
	But does not have a function to withdraw the ether

src/mock/AttackContract.sol#L6-L40


## reentrancy-no-eth
Impact: Medium
Confidence: Medium
 - [ ] ID-11
Reentrancy in [PrelaunchPoints.convertAllETH()](src/PrelaunchPoints.sol#L352-L372):
	External calls:
	- [WETH.approve(address(lpETH),totalSupply)](src/PrelaunchPoints.sol#L362)
	- [lpETH.deposit(totalSupply,address(this))](src/PrelaunchPoints.sol#L363)
	State variables written after the call(s):
	- [startClaimDate = uint32(block.timestamp)](src/PrelaunchPoints.sol#L369)
	[PrelaunchPoints.startClaimDate](src/PrelaunchPoints.sol#L47) can be used in cross function reentrancies:
	- [PrelaunchPoints._processLock(address,uint256,address,bytes32)](src/PrelaunchPoints.sol#L199-L225)
	- [PrelaunchPoints.claim(address,uint8,PrelaunchPoints.Exchange,bytes)](src/PrelaunchPoints.sol#L238-L245)
	- [PrelaunchPoints.claimAndStake(address,uint8,PrelaunchPoints.Exchange,uint256,bytes)](src/PrelaunchPoints.sol#L256-L274)
	- [PrelaunchPoints.constructor(address,address,address[])](src/PrelaunchPoints.sol#L115-L136)
	- [PrelaunchPoints.convertAllETH()](src/PrelaunchPoints.sol#L352-L372)
	- [PrelaunchPoints.startClaimDate](src/PrelaunchPoints.sol#L47)
	- [PrelaunchPoints.withdraw(address)](src/PrelaunchPoints.sol#L322-L344)

src/PrelaunchPoints.sol#L352-L372


## uninitialized-local
Impact: Medium
Confidence: Medium
 - [ ] ID-12
[PrelaunchPoints._validateData(address,uint256,PrelaunchPoints.Exchange,bytes).inputTokenAmount](src/PrelaunchPoints.sol#L469) is a local variable never initialized

src/PrelaunchPoints.sol#L469


 - [ ] ID-13
[PrelaunchPoints._validateData(address,uint256,PrelaunchPoints.Exchange,bytes).outputToken](src/PrelaunchPoints.sol#L468) is a local variable never initialized

src/PrelaunchPoints.sol#L468


 - [ ] ID-14
[PrelaunchPoints._validateData(address,uint256,PrelaunchPoints.Exchange,bytes).inputToken](src/PrelaunchPoints.sol#L467) is a local variable never initialized

src/PrelaunchPoints.sol#L467


## unused-return
Impact: Medium
Confidence: Medium
 - [ ] ID-15
[PrelaunchPoints.convertAllETH()](src/PrelaunchPoints.sol#L352-L372) ignores return value by [WETH.approve(address(lpETH),totalSupply)](src/PrelaunchPoints.sol#L362)

src/PrelaunchPoints.sol#L352-L372


 - [ ] ID-16
[PrelaunchPoints.convertAllETH()](src/PrelaunchPoints.sol#L352-L372) ignores return value by [lpETH.deposit(totalSupply,address(this))](src/PrelaunchPoints.sol#L363)

src/PrelaunchPoints.sol#L352-L372


 - [ ] ID-17
[PrelaunchPoints._claim(address,address,uint8,PrelaunchPoints.Exchange,bytes)](src/PrelaunchPoints.sol#L279-L314) ignores return value by [WETH.approve(address(lpETH),claimedAmount)](src/PrelaunchPoints.sol#L310)

src/PrelaunchPoints.sol#L279-L314


 - [ ] ID-18
[PrelaunchPoints._claim(address,address,uint8,PrelaunchPoints.Exchange,bytes)](src/PrelaunchPoints.sol#L279-L314) ignores return value by [lpETH.deposit(claimedAmount,_receiver)](src/PrelaunchPoints.sol#L311)

src/PrelaunchPoints.sol#L279-L314


 - [ ] ID-19
[PrelaunchPoints.claimAndStake(address,uint8,PrelaunchPoints.Exchange,uint256,bytes)](src/PrelaunchPoints.sol#L256-L274) ignores return value by [lpETH.approve(address(lpETHVault),claimedAmount)](src/PrelaunchPoints.sol#L270)

src/PrelaunchPoints.sol#L256-L274


## missing-zero-check
Impact: Low
Confidence: Medium
 - [ ] ID-20
[PrelaunchPoints.proposeOwner(address)._owner](src/PrelaunchPoints.sol#L378) lacks a zero-check on :
		- [proposedOwner = _owner](src/PrelaunchPoints.sol#L379)

src/PrelaunchPoints.sol#L378


 - [ ] ID-21
[PrelaunchPoints.constructor(address,address,address[])._exchangeProxy](src/PrelaunchPoints.sol#L116) lacks a zero-check on :
		- [exchangeProxy = _exchangeProxy](src/PrelaunchPoints.sol#L121)

src/PrelaunchPoints.sol#L116


## reentrancy-benign
Impact: Low
Confidence: Medium
 - [ ] ID-22
Reentrancy in [PrelaunchPoints._processLock(address,uint256,address,bytes32)](src/PrelaunchPoints.sol#L199-L225):
	External calls:
	- [WETH.deposit{value: _amount}()](src/PrelaunchPoints.sol#L209)
	State variables written after the call(s):
	- [balances[_receiver][address(WETH)] += _amount](src/PrelaunchPoints.sol#L211)
	- [totalSupply += _amount](src/PrelaunchPoints.sol#L210)

src/PrelaunchPoints.sol#L199-L225


 - [ ] ID-23
Reentrancy in [PrelaunchPoints._processLock(address,uint256,address,bytes32)](src/PrelaunchPoints.sol#L199-L225):
	External calls:
	- [IERC20(_token).safeTransferFrom(msg.sender,address(this),_amount)](src/PrelaunchPoints.sol#L216)
	State variables written after the call(s):
	- [balances[_receiver][_token] += _amount](src/PrelaunchPoints.sol#L221)
	- [totalSupply += _amount](src/PrelaunchPoints.sol#L219)

src/PrelaunchPoints.sol#L199-L225


 - [ ] ID-24
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
 - [ ] ID-25
Reentrancy in [PrelaunchPoints._processLock(address,uint256,address,bytes32)](src/PrelaunchPoints.sol#L199-L225):
	External calls:
	- [WETH.deposit{value: _amount}()](src/PrelaunchPoints.sol#L209)
	- [IERC20(_token).safeTransferFrom(msg.sender,address(this),_amount)](src/PrelaunchPoints.sol#L216)
	External calls sending eth:
	- [WETH.deposit{value: _amount}()](src/PrelaunchPoints.sol#L209)
	Event emitted after the call(s):
	- [Locked(_receiver,_amount,_token,_referral)](src/PrelaunchPoints.sol#L224)

src/PrelaunchPoints.sol#L199-L225


 - [ ] ID-26
Reentrancy in [PrelaunchPoints._fillQuote(IERC20,uint256,bytes)](src/PrelaunchPoints.sol#L581-L602):
	External calls:
	- [! _sellToken.approve(exchangeProxy,_amount)](src/PrelaunchPoints.sol#L589)
	- [(success,None) = address(exchangeProxy).call{value: 0}(_swapCallData)](src/PrelaunchPoints.sol#L593)
	External calls sending eth:
	- [(success,None) = address(exchangeProxy).call{value: 0}(_swapCallData)](src/PrelaunchPoints.sol#L593)
	Event emitted after the call(s):
	- [SwappedTokens(address(_sellToken),_amount,boughtWETHAmount)](src/PrelaunchPoints.sol#L601)

src/PrelaunchPoints.sol#L581-L602


 - [ ] ID-27
Reentrancy in [PrelaunchPoints.convertAllETH()](src/PrelaunchPoints.sol#L352-L372):
	External calls:
	- [WETH.approve(address(lpETH),totalSupply)](src/PrelaunchPoints.sol#L362)
	- [lpETH.deposit(totalSupply,address(this))](src/PrelaunchPoints.sol#L363)
	Event emitted after the call(s):
	- [Converted(totalSupply,totalLpETH)](src/PrelaunchPoints.sol#L371)

src/PrelaunchPoints.sol#L352-L372


 - [ ] ID-28
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


 - [ ] ID-29
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


 - [ ] ID-30
Reentrancy in [PrelaunchPoints.recoverERC20(address,uint256)](src/PrelaunchPoints.sol#L432-L442):
	External calls:
	- [IERC20(tokenAddress).safeTransfer(owner,tokenAmount)](src/PrelaunchPoints.sol#L439)
	Event emitted after the call(s):
	- [Recovered(tokenAddress,tokenAmount)](src/PrelaunchPoints.sol#L441)

src/PrelaunchPoints.sol#L432-L442


 - [ ] ID-31
Reentrancy in [PrelaunchPoints.withdraw(address)](src/PrelaunchPoints.sol#L322-L344):
	External calls:
	- [IERC20(_token).safeTransfer(msg.sender,lockedAmount)](src/PrelaunchPoints.sol#L341)
	Event emitted after the call(s):
	- [Withdrawn(msg.sender,_token,lockedAmount)](src/PrelaunchPoints.sol#L343)

src/PrelaunchPoints.sol#L322-L344


## timestamp
Impact: Low
Confidence: Medium
 - [ ] ID-32
[PrelaunchPoints.convertAllETH()](src/PrelaunchPoints.sol#L352-L372) uses timestamp for comparisons
	Dangerous comparisons:
	- [block.timestamp - loopActivation <= TIMELOCK](src/PrelaunchPoints.sol#L357)

src/PrelaunchPoints.sol#L352-L372


 - [ ] ID-33
[PrelaunchPoints.withdraw(address)](src/PrelaunchPoints.sol#L322-L344) uses timestamp for comparisons
	Dangerous comparisons:
	- [block.timestamp >= startClaimDate](src/PrelaunchPoints.sol#L324)
	- [block.timestamp >= startClaimDate](src/PrelaunchPoints.sol#L336)

src/PrelaunchPoints.sol#L322-L344


## assembly
Impact: Informational
Confidence: High
 - [ ] ID-34
[PrelaunchPoints._decodeUniswapV3Data(bytes)](src/PrelaunchPoints.sol#L520-L547) uses assembly
	- [INLINE ASM](src/PrelaunchPoints.sol#L534-L546)

src/PrelaunchPoints.sol#L520-L547


 - [ ] ID-35
[PrelaunchPoints._decodeTransformERC20Data(bytes)](src/PrelaunchPoints.sol#L553-L572) uses assembly
	- [INLINE ASM](src/PrelaunchPoints.sol#L565-L571)

src/PrelaunchPoints.sol#L553-L572


 - [ ] ID-36
[Math.mulDiv(uint256,uint256,uint256)](lib/openzeppelin-contracts/contracts/utils/math/Math.sol#L123-L202) uses assembly
	- [INLINE ASM](lib/openzeppelin-contracts/contracts/utils/math/Math.sol#L130-L133)
	- [INLINE ASM](lib/openzeppelin-contracts/contracts/utils/math/Math.sol#L154-L161)
	- [INLINE ASM](lib/openzeppelin-contracts/contracts/utils/math/Math.sol#L167-L176)

lib/openzeppelin-contracts/contracts/utils/math/Math.sol#L123-L202


 - [ ] ID-37
[Address._revert(bytes)](lib/openzeppelin-contracts/contracts/utils/Address.sol#L146-L158) uses assembly
	- [INLINE ASM](lib/openzeppelin-contracts/contracts/utils/Address.sol#L151-L154)

lib/openzeppelin-contracts/contracts/utils/Address.sol#L146-L158


## pragma
Impact: Informational
Confidence: High
 - [ ] ID-38
3 different versions of Solidity are used:
	- Version constraint ^0.8.20 is used by:
		-[^0.8.20](lib/openzeppelin-contracts/contracts/interfaces/draft-IERC6093.sol#L3)
		-[^0.8.20](lib/openzeppelin-contracts/contracts/token/ERC20/ERC20.sol#L4)
		-[^0.8.20](lib/openzeppelin-contracts/contracts/token/ERC20/IERC20.sol#L4)
		-[^0.8.20](lib/openzeppelin-contracts/contracts/token/ERC20/extensions/IERC20Metadata.sol#L4)
		-[^0.8.20](lib/openzeppelin-contracts/contracts/token/ERC20/extensions/IERC20Permit.sol#L4)
		-[^0.8.20](lib/openzeppelin-contracts/contracts/token/ERC20/utils/SafeERC20.sol#L4)
		-[^0.8.20](lib/openzeppelin-contracts/contracts/utils/Address.sol#L4)
		-[^0.8.20](lib/openzeppelin-contracts/contracts/utils/Context.sol#L4)
		-[^0.8.20](lib/openzeppelin-contracts/contracts/utils/math/Math.sol#L4)
	- Version constraint 0.8.20 is used by:
		-[0.8.20](src/PrelaunchPoints.sol#L2)
		-[0.8.20](src/interfaces/ILpETH.sol#L2)
		-[0.8.20](src/interfaces/ILpETHVault.sol#L2)
		-[0.8.20](src/mock/AttackContract.sol#L2)
		-[0.8.20](src/mock/MockERC20.sol#L2)
		-[0.8.20](src/mock/MockLRT.sol#L2)
		-[0.8.20](src/mock/MockLpETH.sol#L2)
		-[0.8.20](src/mock/MockLpETHVault.sol#L2)
		-[0.8.20](src/mock/MockWETH.sol#L16)
	- Version constraint >=0.5.0 is used by:
		-[>=0.5.0](src/interfaces/IWETH.sol#L2)

lib/openzeppelin-contracts/contracts/interfaces/draft-IERC6093.sol#L3


## low-level-calls
Impact: Informational
Confidence: High
 - [ ] ID-39
Low level call in [PrelaunchPoints._fillQuote(IERC20,uint256,bytes)](src/PrelaunchPoints.sol#L581-L602):
	- [(success,None) = address(exchangeProxy).call{value: 0}(_swapCallData)](src/PrelaunchPoints.sol#L593)

src/PrelaunchPoints.sol#L581-L602


 - [ ] ID-40
Low level call in [Address.functionStaticCall(address,bytes)](lib/openzeppelin-contracts/contracts/utils/Address.sol#L95-L98):
	- [(success,returndata) = target.staticcall(data)](lib/openzeppelin-contracts/contracts/utils/Address.sol#L96)

lib/openzeppelin-contracts/contracts/utils/Address.sol#L95-L98


 - [ ] ID-41
Low level call in [Address.functionDelegateCall(address,bytes)](lib/openzeppelin-contracts/contracts/utils/Address.sol#L104-L107):
	- [(success,returndata) = target.delegatecall(data)](lib/openzeppelin-contracts/contracts/utils/Address.sol#L105)

lib/openzeppelin-contracts/contracts/utils/Address.sol#L104-L107


 - [ ] ID-42
Low level call in [SafeERC20._callOptionalReturnBool(IERC20,bytes)](lib/openzeppelin-contracts/contracts/token/ERC20/utils/SafeERC20.sol#L110-L117):
	- [(success,returndata) = address(token).call(data)](lib/openzeppelin-contracts/contracts/token/ERC20/utils/SafeERC20.sol#L115)

lib/openzeppelin-contracts/contracts/token/ERC20/utils/SafeERC20.sol#L110-L117


 - [ ] ID-43
Low level call in [Address.sendValue(address,uint256)](lib/openzeppelin-contracts/contracts/utils/Address.sol#L41-L50):
	- [(success,None) = recipient.call{value: amount}()](lib/openzeppelin-contracts/contracts/utils/Address.sol#L46)

lib/openzeppelin-contracts/contracts/utils/Address.sol#L41-L50


 - [ ] ID-44
Low level call in [Address.functionCallWithValue(address,bytes,uint256)](lib/openzeppelin-contracts/contracts/utils/Address.sol#L83-L89):
	- [(success,returndata) = target.call{value: value}(data)](lib/openzeppelin-contracts/contracts/utils/Address.sol#L87)

lib/openzeppelin-contracts/contracts/utils/Address.sol#L83-L89


## reentrancy-unlimited-gas
Impact: Informational
Confidence: Medium
 - [ ] ID-45
Reentrancy in [MockWETH.withdraw(uint256)](src/mock/MockWETH.sol#L38-L43):
	External calls:
	- [address(msg.sender).transfer(wad)](src/mock/MockWETH.sol#L41)
	Event emitted after the call(s):
	- [Withdrawal(msg.sender,wad)](src/mock/MockWETH.sol#L42)

src/mock/MockWETH.sol#L38-L43


## constable-states
Impact: Optimization
Confidence: High
 - [ ] ID-46
[MockWETH.decimals](src/mock/MockWETH.sol#L21) should be constant 

src/mock/MockWETH.sol#L21


 - [ ] ID-47
[MockWETH.name](src/mock/MockWETH.sol#L19) should be constant 

src/mock/MockWETH.sol#L19


 - [ ] ID-48
[MockWETH.symbol](src/mock/MockWETH.sol#L20) should be constant 

src/mock/MockWETH.sol#L20


 - [ ] ID-49
[AttackContract.emptydata](src/mock/AttackContract.sol#L9) should be constant 

src/mock/AttackContract.sol#L9


## immutable-states
Impact: Optimization
Confidence: High
 - [ ] ID-50
[AttackContract.prelaunchPoints](src/mock/AttackContract.sol#L7) should be immutable 

src/mock/AttackContract.sol#L7


