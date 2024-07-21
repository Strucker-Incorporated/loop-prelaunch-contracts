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


## incorrect-exp
Impact: High
Confidence: Medium
 - [ ] ID-1
[Math.mulDiv(uint256,uint256,uint256)](lib/openzeppelin-contracts/contracts/utils/math/Math.sol#L123-L202) has bitwise-xor operator ^ instead of the exponentiation operator **: 
	 - [inverse = (3 * denominator) ^ 2](lib/openzeppelin-contracts/contracts/utils/math/Math.sol#L184)

lib/openzeppelin-contracts/contracts/utils/math/Math.sol#L123-L202


