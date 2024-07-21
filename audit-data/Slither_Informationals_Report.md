Summary
 - [assembly](#assembly) (4 results) (Informational)
 - [pragma](#pragma) (1 results) (Informational)
 - [low-level-calls](#low-level-calls) (6 results) (Informational)
 - [reentrancy-unlimited-gas](#reentrancy-unlimited-gas) (1 results) (Informational)
## assembly
Impact: Informational
Confidence: High
 - [ ] ID-0
[PrelaunchPoints._decodeUniswapV3Data(bytes)](src/PrelaunchPoints.sol#L486-L504) uses assembly
	- [INLINE ASM](src/PrelaunchPoints.sol#L492-L503)

src/PrelaunchPoints.sol#L486-L504

 - [ ] ID-3
[PrelaunchPoints._decodeTransformERC20Data(bytes)](src/PrelaunchPoints.sol#L510-L522) uses assembly
	- [INLINE ASM](src/PrelaunchPoints.sol#L515-L521)

src/PrelaunchPoints.sol#L510-L522


## low-level-calls
Impact: Informational
Confidence: High
 - [ ] ID-5
Low level call in [PrelaunchPoints._fillQuote(IERC20,uint256,bytes)](src/PrelaunchPoints.sol#L530-L547):
	- [(success,None) = address(exchangeProxy).call{value: 0}(_swapCallData)](src/PrelaunchPoints.sol#L538)

src/PrelaunchPoints.sol#L530-L547

