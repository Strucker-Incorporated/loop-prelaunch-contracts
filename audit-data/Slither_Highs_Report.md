Summary
 - [arbitrary-send-eth](#arbitrary-send-eth) (1 results) (High)
 - [incorrect-exp](#incorrect-exp) (1 results) (High)
## arbitrary-send-eth
Impact: High
Confidence: Medium
 - [ ] ID-0
[PrelaunchPoints._fillQuote(IERC20,uint256,bytes)](src/PrelaunchPoints.sol#L530-L547) sends eth to arbitrary user
	Dangerous calls:
	- [(success,None) = address(exchangeProxy).call{value: 0}(_swapCallData)](src/PrelaunchPoints.sol#L538)

src/PrelaunchPoints.sol#L530-L547



