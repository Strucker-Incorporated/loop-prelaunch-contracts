Summary
 - [assembly](#assembly) (4 results) (Informational)
 - [pragma](#pragma) (1 results) (Informational)
 - [low-level-calls](#low-level-calls) (6 results) (Informational)
 - [reentrancy-unlimited-gas](#reentrancy-unlimited-gas) (1 results) (Informational)
## assembly
Impact: Informational
Confidence: High
 - [ ] ID-0
[PrelaunchPoints._decodeUniswapV3Data(bytes)](src/PrelaunchPoints.sol#L520-L547) uses assembly
	- [INLINE ASM](src/PrelaunchPoints.sol#L534-L546)

src/PrelaunchPoints.sol#L520-L547


 - [ ] ID-1
[PrelaunchPoints._decodeTransformERC20Data(bytes)](src/PrelaunchPoints.sol#L553-L572) uses assembly
	- [INLINE ASM](src/PrelaunchPoints.sol#L565-L571)

src/PrelaunchPoints.sol#L553-L572


 - [ ] ID-2
[Math.mulDiv(uint256,uint256,uint256)](lib/openzeppelin-contracts/contracts/utils/math/Math.sol#L123-L202) uses assembly
	- [INLINE ASM](lib/openzeppelin-contracts/contracts/utils/math/Math.sol#L130-L133)
	- [INLINE ASM](lib/openzeppelin-contracts/contracts/utils/math/Math.sol#L154-L161)
	- [INLINE ASM](lib/openzeppelin-contracts/contracts/utils/math/Math.sol#L167-L176)

lib/openzeppelin-contracts/contracts/utils/math/Math.sol#L123-L202


 - [ ] ID-3
[Address._revert(bytes)](lib/openzeppelin-contracts/contracts/utils/Address.sol#L146-L158) uses assembly
	- [INLINE ASM](lib/openzeppelin-contracts/contracts/utils/Address.sol#L151-L154)

lib/openzeppelin-contracts/contracts/utils/Address.sol#L146-L158


## pragma
Impact: Informational
Confidence: High
 - [ ] ID-4
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
 - [ ] ID-5
Low level call in [PrelaunchPoints._fillQuote(IERC20,uint256,bytes)](src/PrelaunchPoints.sol#L581-L602):
	- [(success,None) = address(exchangeProxy).call{value: 0}(_swapCallData)](src/PrelaunchPoints.sol#L593)

src/PrelaunchPoints.sol#L581-L602


 - [ ] ID-6
Low level call in [Address.functionStaticCall(address,bytes)](lib/openzeppelin-contracts/contracts/utils/Address.sol#L95-L98):
	- [(success,returndata) = target.staticcall(data)](lib/openzeppelin-contracts/contracts/utils/Address.sol#L96)

lib/openzeppelin-contracts/contracts/utils/Address.sol#L95-L98


 - [ ] ID-7
Low level call in [Address.functionDelegateCall(address,bytes)](lib/openzeppelin-contracts/contracts/utils/Address.sol#L104-L107):
	- [(success,returndata) = target.delegatecall(data)](lib/openzeppelin-contracts/contracts/utils/Address.sol#L105)

lib/openzeppelin-contracts/contracts/utils/Address.sol#L104-L107


 - [ ] ID-8
Low level call in [SafeERC20._callOptionalReturnBool(IERC20,bytes)](lib/openzeppelin-contracts/contracts/token/ERC20/utils/SafeERC20.sol#L110-L117):
	- [(success,returndata) = address(token).call(data)](lib/openzeppelin-contracts/contracts/token/ERC20/utils/SafeERC20.sol#L115)

lib/openzeppelin-contracts/contracts/token/ERC20/utils/SafeERC20.sol#L110-L117


 - [ ] ID-9
Low level call in [Address.sendValue(address,uint256)](lib/openzeppelin-contracts/contracts/utils/Address.sol#L41-L50):
	- [(success,None) = recipient.call{value: amount}()](lib/openzeppelin-contracts/contracts/utils/Address.sol#L46)

lib/openzeppelin-contracts/contracts/utils/Address.sol#L41-L50


 - [ ] ID-10
Low level call in [Address.functionCallWithValue(address,bytes,uint256)](lib/openzeppelin-contracts/contracts/utils/Address.sol#L83-L89):
	- [(success,returndata) = target.call{value: value}(data)](lib/openzeppelin-contracts/contracts/utils/Address.sol#L87)

lib/openzeppelin-contracts/contracts/utils/Address.sol#L83-L89


## reentrancy-unlimited-gas
Impact: Informational
Confidence: Medium
 - [ ] ID-11
Reentrancy in [MockWETH.withdraw(uint256)](src/mock/MockWETH.sol#L38-L43):
	External calls:
	- [address(msg.sender).transfer(wad)](src/mock/MockWETH.sol#L41)
	Event emitted after the call(s):
	- [Withdrawal(msg.sender,wad)](src/mock/MockWETH.sol#L42)

src/mock/MockWETH.sol#L38-L43


