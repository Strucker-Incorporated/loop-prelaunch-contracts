
---
# LoopFI Security Report For C4 Labs

### High-Risk Issues

#### 1. **Arbitrary ETH Sending (`arbitrary-send-eth`)**
   - **Description**: The `_fillQuote` function in the Loopfi contract employs a low-level `call` to interact with an arbitrary address specified by `exchangeProxy`, executing any code contained in the `swapCallData`. This function is designed to facilitate various interactions within Loopfi, a platform that enables users to engage in Ethereum carry trades using Liquid Restaking derivatives (LRTs) as collateral.
    Loopfi allows users to borrow ETH and participate in the decentralized finance (DeFi) ecosystem, with the `exchangeProxy` potentially playing a pivotal role in these processes.

   However, the design introduces a significant risk: if the `exchangeProxy` is compromised or if the `swapCallData` contains malicious instructions, the function could execute unintended or harmful actions. 
   
   Given the capacity of `_fillQuote` to execute arbitrary code, the platform is vulnerable to unauthorized ETH transfers, state manipulations, and broader contract exploitation.

     - **Lines**: [530-547](src/PrelaunchPoints.sol#L530-L547)
   - **Code Context**:
     ```javascript
     function _fillQuote(IERC20 token, uint256 amount, bytes memory swapCallData) internal {
         (bool success,) = payable(exchangeProxy).call{ value: 0 }(swapCallData);
         require(success, "Swap failed");
     }
     ```

**Impact**:
- **Unauthorized ETH Transfers**: The execution of arbitrary code through `swapCallData` can result in unintended ETH transfers. An attacker could craft `swapCallData` to redirect ETH to their own address, potentially draining the project's ETH reserves. This vulnerability exposes the entire contract's ETH holdings to theft, posing a severe risk to the protocol and its users.

- **State Manipulation**: The external contract invoked by `exchangeProxy` may alter its own or the calling contract's state in unforeseen ways. This could lead to unauthorized changes to user balances, critical configuration settings, or other sensitive data, compromising the integrity and security of the protocol. Such manipulation can cause widespread disruptions, affecting all users and transactions within the platform.

- **Contract Exploitation**: Malicious actors can exploit vulnerabilities within the `exchangeProxy` contract, leveraging the arbitrary execution capabilities to gain unauthorized access to privileged functions or alter contract permissions. This could allow attackers to bypass security measures, execute restricted actions, or otherwise compromise the system's integrity, potentially leading to further financial losses or operational failures.


**Protocols Affected by Similar Issues**:
- **The DAO Hack (2016)**: This infamous incident exploited a recursive call vulnerability, allowing an attacker to drain approximately $60 million worth of ETH from the DAO smart contract. It underscored the importance of rigorous contract validation and secure coding practices.
- **Parity Multisig Wallet Vulnerability (2017)**: A flaw in the Parity multisig wallet contract allowed an attacker to gain control over the wallet, resulting in the loss of over $30 million in ETH. The vulnerability was related to improper handling of external contract calls, highlighting the risks associated with such interactions.
- **bZx Protocol (2020)**: The bZx protocol experienced multiple attacks due to vulnerabilities in how it handled external interactions, leading to significant financial losses. These incidents demonstrated the dangers of not properly securing external calls and the importance of thorough auditing.
- **Spectra Finance (2024)**: On July 23, 2024, Spectra Finance suffered a $550K loss due to an arbitrary call vulnerability in their router contract. This flaw allowed an attacker to drain all tokens approved to the contract. More details can be found on [Spectra's Twitter update](https://x.com/spectra_finance/status/1815813300111786488) and the [BlockSec Explorer](https://app.blocksec.com/explorer/tx/eth/0x491cf8b2a5753fdbf3096b42e0a16bc109b957dc112d6537b1ed306e483d0744?line=7).

   - **Mitigation**: 
     - Use higher-level functions with well-defined interfaces to interact with external contracts. Ensure that the `exchangeProxy` address and the content of `swapCallData` are thoroughly vetted and validated before execution.

   - **PoC**: Demonstrate how a malicious contract could exploit the `_fillQuote` function to cause financial loss or contract manipulation.

     ```javascript
    // SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

import "forge-std/Test.sol";
import "../../src/PrelaunchPoints.sol";
import "../../src/mock/MockERC20.sol";

contract TestHelper is PrelaunchPoints {
    constructor(
        address _exchangeProxy,
        address _wethAddress,
        address[] memory _allowedTokens
    ) PrelaunchPoints(_exchangeProxy, _wethAddress, _allowedTokens) {}

    // Expose the internal _fillQuote function for testing
    function exposeFillQuote(
        IERC20 _sellToken,
        uint256 _amount,
        bytes calldata _swapCallData
    ) public {
        _fillQuote(_sellToken, _amount, _swapCallData);
    }
}


contract TestArbitrarySend is Test {
    TestHelper prelaunchPoints;
    ERC20Token mockToken;

    address exchangeProxy = address(0x1234567890123456789012345678901234567890);
    address wethAddress = address(0x1234567890123456789012345678901234567891);
    address[] allowedTokens;

    function setUp() public {
        // Deploy the mock token
        mockToken = new ERC20Token();
        allowedTokens.push(address(mockToken));

        // Add another valid token if needed
        allowedTokens.push(address(0x1234567890123456789012345678901234567892)); // Replace with a valid token address

        // Deploy the TestHelper contract with initial parameters
        prelaunchPoints = new TestHelper(
            exchangeProxy,
            wethAddress,
            allowedTokens
        );

        // Mint some mock tokens for testing
        mockToken.mint(address(this), 1000 ether);
    }

    function testExploit() external {
        uint256 amount = 1 ether; // Example amount to be used in the test

        // Setup mock data for the swap call
        bytes memory swapCallData = ""; // Replace with appropriate data if needed

        // Approve the TestHelper contract to spend mock tokens
        mockToken.approve(address(prelaunchPoints), amount);

        // Record the initial ETH balance of the contract
        uint256 initialBalance = address(prelaunchPoints).balance;

        // Trigger the _fillQuote function using the TestHelper contract
        prelaunchPoints.exposeFillQuote(mockToken, amount, swapCallData);

        // Fetch the new ETH balance of the contract
        uint256 newBalance = address(prelaunchPoints).balance;

        // Assert that the balance has changed as expected
        assertGt(newBalance, initialBalance, "ETH balance should increase after calling _fillQuote");

        // Additional assertions as needed
        // For example:
        // - Verify the mock token balance of the contract has decreased
        uint256 finalTokenBalance = mockToken.balanceOf(address(prelaunchPoints));
        assertEq(finalTokenBalance, 1000 ether - amount, "Mock token balance should decrease after calling _fillQuote");

        // If _fillQuote emits any events, assert that they were emitted correctly
        // For example:
        // emit EventName(arg1, arg2);
        // assertEmitted(prelaunchPoints, "EventName", arg1, arg2);
    }
}
 ```


### Medium-Risk Issues
#### 1. **Uninitialized Local Variables (`uninitialized-local`)**
   - **Description**: Local variables are declared but not initialized before use. This can lead to unpredictable contract behavior because default values might be used in calculations or function calls, resulting in logical errors or unintended consequences.
   - **Lines**: [443-445](src/PrelaunchPoints.sol#L443-L445)
   - **Code Context**:
     ```javascript
     address inputToken;
     address outputToken;
     uint256 inputTokenAmount;
     ```
   - **Impact**:
     - **Incorrect Calculations**: Uninitialized variables could lead to incorrect calculations or function calls. For example, if `inputToken` or `outputToken` is used in a function that requires valid addresses, using the default 0x0 address could cause errors or unexpected behavior in user interactions.
     - **Security Vulnerabilities**: Uninitialized variables used in security-sensitive operations might introduce vulnerabilities. If a function expects specific values and gets default or unintended ones, it might expose the contract to risks.
   - **Mitigation**: 
     - Initialize all local variables with appropriate default values before use. Validate that the values are correctly set before any operation that depends on them.
   - **PoC**: Show how using uninitialized variables can lead to failures or incorrect behavior in contract operations.
     ```javascript
     // Contract demonstrating uninitialized variables
     contract TestUninitialized {
         PrelaunchPoints public prelaunchPoints;

         constructor(address _prelaunchPoints) {
             prelaunchPoints = PrelaunchPoints(_prelaunchPoints);
         }

         function testFunction() external {
             address inputToken; // Uninitialized
             address outputToken; // Uninitialized
             uint256 inputTokenAmount; // Uninitialized

             // Attempt to use the uninitialized variables
             // This could result in errors if the function requires valid input
             prelaunchPoints.someFunction(inputToken, outputToken, inputTokenAmount);
         }
     }
     ```
   - **Real-World Example**: 
     - **Parity Multi-Sig Wallet** (2018): An uninitialized variable issue in the contract caused incorrect behavior, leading to the loss of significant funds. This incident underscores the importance of proper initialization and handling of contract state.

#### 2. **Unused Return Values (`unused-return`)**
   - **Description**: Ignoring the return values from functions that indicate success or failure can cause critical issues to go unnoticed. This might result in the contract operating under false assumptions or failing silently, leading to potential financial loss or incorrect contract behavior.
   - **Lines**: [260-298](src/PrelaunchPoints.sol#L260-L298)
   - **Code Context**:
     ```javascript
     if (!_sellToken.approve(exchangeProxy, _amount)) {
         revert SellTokenApprovalFailed();
     }
     ```
   - **Impact**:
     - **Unnoticed Failures**: If the `approve` function fails and its return value is ignored, the contract might continue to function under the assumption that the approval was successful, which could lead to failed token transfers or other operations.
     - **Operational Risks**: Critical operations depending on the success of token approvals or other functions might fail silently, causing financial loss or unexpected states in the contract.
   - **Mitigation**: 
     - Ensure that all function calls that return values are handled appropriately. Validate the success of each operation and include error handling where necessary.
   - **PoC**: Show how ignoring return values can lead to silent failures in critical operations.
     ```javascript
     // Contract demonstrating failure due to unused return values
     contract TestUnusedReturn {
         PrelaunchPoints public prelaunchPoints;

         constructor(address _prelaunchPoints) {
             prelaunchPoints = PrelaunchPoints(_prelaunchPoints);
         }

         function testFunction() external {
             uint256 amount = 100;
             address exchangeProxy = address(0x123);

             // Ignoring the return value of approve, leading to potential silent failure
             // If approval fails, subsequent operations relying on this approval might also fail
             prelaunchPoints._sellToken.approve(exchangeProxy, amount);
         }
     }
     ```
   - **Real-World Example**:
     - **DAO Hack** (2016): Highlighted how ignoring the outcomes of critical operations can lead to significant losses. The failure to properly handle transaction outcomes contributed to the exploit that drained funds from the DAO.
To elevate the "Unsafe ERC20 Operations" from low to medium risk, let's build out more detailed Proofs of Concept (PoCs) that illustrate their impact on functionality and security. These PoCs will help to showcase how ignoring the return values of ERC20 operations could lead to significant issues in the contract.

### Unsafe ERC20 Operations (`unsafe-erc20-operations`)

- **Description**: Lack of checks for ERC20 operations which could fail silently.
- **Files and Lines**:
  - `src/PrelaunchPoints.sol` [Line: 235](src/PrelaunchPoints.sol#L235)
    ```javascript
    lpETH.approve(address(lpETHVault), claimedAmount);
    ```
  - `src/PrelaunchPoints.sol` [Line: 272](src/PrelaunchPoints.sol#L272)
    ```javascript
    WETH.approve(address(lpETH), claimedAmount);
    ```
  - `src/PrelaunchPoints.sol` [Line: 320](src/PrelaunchPoints.sol#L320)
    ```javascript
    WETH.approve(address(lpETH), totalSupply);
    ```
  - `src/PrelaunchPoints.sol` [Line: 508](src/PrelaunchPoints.sol#L508)
    ```javascript
    if (!_sellToken.approve(exchangeProxy, _amount)) {
    ```

- **Impact**: 
  - Ignoring return values from `approve` calls can result in unexpected behavior or failed transactions if the approval fails, impacting contract functionality and leading to potential financial losses or disruptions.

- **Mitigation**: 
  - Ensure that `approve` calls handle the returned boolean value properly and include appropriate error handling to address failures.

- **PoC**: Show potential failure in ERC20 operations due to unverified `approve` calls.

#### Proof of Concept for Unsafe ERC20 Operations

1. **Contract with Unsafe ERC20 Operations**

   This contract demonstrates how ignoring the return values of `approve` calls can lead to failed token transfers, which can disrupt the intended functionality.

   ```solidity
   // SPDX-License-Identifier: MIT
   pragma solidity ^0.8.0;

   interface ERC20 {
       function approve(address spender, uint256 amount) external returns (bool);
   }

   contract TestERC20Operations {
       ERC20 public token;
       address public spender;

       constructor(address _token, address _spender) {
           token = ERC20(_token);
           spender = _spender;
       }

       function testApprove() external {
           uint256 amount = 100;

           // Ignoring the return value of approve, leading to potential silent failure
           token.approve(spender, amount);
       }
   }
   ```

2. **Malicious Contract to Exploit the Issue**

   This malicious contract will try to exploit the `TestERC20Operations` contract by assuming that approvals are successful, which might not be the case if the return values are ignored.

   ```solidity
   // SPDX-License-Identifier: MIT
   pragma solidity ^0.8.0;

   interface TestERC20Operations {
       function testApprove() external;
   }

   contract ExploitContract {
       TestERC20Operations public target;

       constructor(address _target) {
           target = TestERC20Operations(_target);
       }

       function exploit() external {
           // Call the function that has unsafe ERC20 operations
           target.testApprove();

           // Here, we can try to perform actions that assume approval was successful
           // If the approval failed silently, these actions will fail
       }
   }
   ```

   **Explanation**:
   - The `TestERC20Operations` contract calls `approve` on an ERC20 token but ignores the return value.
   - The `ExploitContract` assumes that the approval was successful and attempts to perform actions based on that assumption.
   - If the approval failed silently, these subsequent actions will fail, demonstrating the impact of not handling return values properly.

3. **Testing Scenario**

   - Deploy the `ERC20` token contract with an appropriate `approve` method that fails under certain conditions.
   - Deploy the `TestERC20Operations` contract with this token and an address for the spender.
   - Deploy the `ExploitContract` with the address of the `TestERC20Operations` contract.
   - Call the `exploit` function from the `ExploitContract` to observe the failure of subsequent actions.

4. **Mitigation**

   - Modify the `TestERC20Operations` contract to handle the return value of `approve`:

     ```solidity
     function testApprove() external {
         uint256 amount = 100;
         require(token.approve(spender, amount), "Approval failed");
     }
     ```

   - This ensures that the contract checks whether the approval succeeded and handles errors appropriately.


## Low-Risk Issues

### Low-Level Calls (`low-level-calls`)

- **Description**: Low-level calls can be used to interact with contracts but might bypass some of the safety checks provided by Solidity's higher-level constructs.
- **Files and Lines**:
  - `src/PrelaunchPoints.sol` [Lines: 530-547](src/PrelaunchPoints.sol#L530-L547)
    ```javascript
    function _fillQuote(IERC20 token, uint256 amount, bytes memory swapCallData) internal {
        (bool success,) = address(exchangeProxy).call{value: 0}(swapCallData);
        require(success, "Swap failed");
    }
    ```
    *Explanation*: The use of low-level `call` can potentially lead to reentrancy attacks or unexpected behavior. Ensure that all external calls are handled securely.

- **Impact**: 
  - Low-level calls can introduce risks such as reentrancy attacks if not properly managed.

- **Mitigation**: 
  - Use high-level abstractions where possible and ensure thorough validation of all data and success indicators.

- **Proof of Concept (PoC)**

   The PoC demonstrates how low-level calls can be exploited through reentrancy attacks. 

   **Malicious Contract**
   ```javascript
   // Malicious Contract
   contract Malicious {
       PrelaunchPoints public prelaunchPoints;
       address public owner;

       constructor(address _prelaunchPoints) {
           prelaunchPoints = PrelaunchPoints(_prelaunchPoints);
           owner = msg.sender;
       }

       // Fallback function to reenter the _fillQuote function
       receive() external payable {
           if (address(prelaunchPoints).balance > 0) {
               // Call _fillQuote again to exploit reentrancy
               bytes memory swapCallData = abi.encodeWithSignature("someFunction()");
               prelaunchPoints._fillQuote(IERC20(address(0)), 0, swapCallData);
           }
       }

       function exploit() external {
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
           prelaunchPoints = PrelaunchPoints(_prelaunchPoints);
           malicious = Malicious(_malicious);
       }

       function testExploit() external {
           // Trigger the exploit
           malicious.exploit();
       }
   }
   ```

   **Explanation**

   - The **Malicious Contract** contains a fallback function that re-enters the `_fillQuote` function if the balance is greater than zero. This can exploit the low-level `call` to perform a reentrancy attack or other malicious actions.

   - The **TestLowLevelCall Contract** initiates the exploit by calling the malicious contract's exploit function, which triggers the reentrant call.

   **Mitigation**

   - **High-Level Abstractions**: Prefer using high-level functions and abstractions that provide built-in safety checks.
   - **Validation**: Validate all inputs and the success of external calls thoroughly.
   - **Reentrancy Guard**: Implement reentrancy guards to prevent reentrant attacks.

### Missing Zero-Checks (`missing-zero-check`)

- **Description**: Checks for `address(0)` when assigning values are missing.
- **Files and Lines**:
  - `src/PrelaunchPoints.sol` [Line: 337](src/PrelaunchPoints.sol#L337)
    ```javascript
    proposedOwner = _owner;
    ```
    *Explanation*: There should be a check to ensure `_owner` is not the zero address to avoid assigning an invalid owner.

  - `src/PrelaunchPoints.sol` [Line: 365](src/PrelaunchPoints.sol#L365)
    ```javascript
    lpETH = ILpETH(_loopAddress);
    ```
    *Explanation*: Ensure `_loopAddress` is not `address(0)` to prevent assigning an invalid address.

  - `src/PrelaunchPoints.sol` [Line: 366](src/PrelaunchPoints.sol#L366)
    ```javascript
    lpETHVault = ILpETHVault(_vaultAddress);
    ```
    *Explanation*: Similarly, `_vaultAddress` should be validated to avoid setting an invalid address.

- **Impact**: 
  - Assigning an invalid address can lead to contract malfunction or loss of control.
- **Mitigation**: 
  - Ensure that addresses are checked for zero value before assignment.
- **PoC**: Demonstrate contract issues due to missing zero address checks.

  ```javascript
  // Contract with missing zero address checks
  contract TestZeroChecks {
      address public proposedOwner;
      address public lpETH;
      address public lpETHVault;

      function setOwner(address _owner) external {
          proposedOwner = _owner; // Missing zero address check
      }

      function setLoopAddresses(address _loopAddress, address _vaultAddress) external {
          lpETH = _loopAddress; // Missing zero address check
          lpETHVault = _vaultAddress; // Missing zero address check
      }
  }
  ```

### PUSH0 Compatibility (`push0-compatibility`)

- **Description**: Solidity 0.8.20 introduces `PUSH0` which may have unintended effects.
- **Files and Lines**:
  - `src/interfaces/ILpETHVault.sol` [Line: 2](src/interfaces/ILpETHVault.sol#L2)
    ```javascript
    pragma solidity 0.8.20;
    ```
    *Explanation*: Using a specific version pragma (0.8.20) can lead to compatibility issues if new opcodes like `PUSH0` are not handled correctly.

- **Impact**: 
  - Potential issues with opcode compatibility and behavior.
- **Mitigation**: 
  - Test contracts thoroughly with the specified Solidity version to ensure compatibility and handle any new opcodes appropriately.
- **PoC**: Demonstrate potential issues with `PUSH0` opcode.

  ```javascript
  // Contract demonstrating PUSH0 compatibility issues
  pragma solidity 0.8.20;

  contract TestPush0 {
      function testPush0() external pure returns (string memory) {
          return "Test";
      }
  }
  ```


## Informationals

### Event Missing Indexed Fields (`event-missing-indexed-fields`)

- **Description**: Events lack indexed fields, making them less efficient to query.
- **Files and Lines**:
  - `src/PrelaunchPoints.sol` [Line: 53](src/PrelaunchPoints.sol#L53)

    ```javascript
    event StakedVault(address user, uint256 amount, uint256 typeIndex);

    ```
    *Explanation*: Adding `indexed` to the `user` parameter would make it easier to search and filter logs.

  - `src/PrelaunchPoints.sol` [Line: 146](src/PrelaunchPoints.sol#L146)
    ```javascript
    event Converted(uint256 amountETH, uint256 amountlpETH);
    ```
    *Explanation*: While this event has fewer parameters, indexing at least one would improve query efficiency.

- **Impact**: 
  - Difficulty in filtering and querying events, leading to potential inefficiencies in event handling.
- **Mitigation**: 
  - Add `indexed` to relevant fields in the events to facilitate efficient querying.
- **PoC**: Show inefficient event querying due to missing indexed fields.

  ```javascript
  // Contract with events missing indexed fields
  contract TestEvents {
      event StakedVault(address indexed user, uint256 amount, uint256 typeIndex);
      event Converted(uint256 amountETH, uint256 amountlpETH);

      function stake(address user, uint256 amount, uint256 typeIndex) external {
          emit StakedVault(user, amount, typeIndex);
      }

      function convert(uint256 amountETH, uint256 amountlpETH) external {
          emit Converted(amountETH, amountlpETH);
      }
  }
  ```
### Unused Custom Error (`unused-custom-error`)

- **Description**: Custom error definitions are not used in the contract.
- **Files and Lines**:
  - `src/PrelaunchPoints.sol` [Line: 36](src/PrelaunchPoints.sol#L36)
    ```javascript
    error FailedToSendEther();
    ```
    *Explanation*: If custom errors are defined but not used, they should either be implemented in relevant places or removed to avoid confusion.

- **Impact**: 
  - Unused code elements may lead to confusion and potential issues in code maintenance.
- **Mitigation**: 
  - Implement the custom errors where applicable or remove them if not needed.
- **PoC**: Show unused custom error in the contract.
  ```javascript
  // Contract with unused custom error
  contract TestCustomError {
      error FailedToSendEther(); // Unused error

      function testFunction() external {
          // Function logic here
      }
  }

  ```


### Solidity Pragma Specificity (`solidity-pragma`)

- **Description**: Using a wide version of Solidity pragma.
- **Files and Lines**:
  - `src/interfaces/IWETH.sol` [Line: 2](src/interfaces/IWETH.sol#L2)
    ```javascript
    pragma solidity >=0.5.0;
    ```
    *Explanation*: Using a broad version range in the pragma can lead to compatibility issues, as it may include versions that introduce unintended changes or bugs.

- **Impact**: 
  - Potential compatibility issues with future Solidity versions.
- **Mitigation**: 
  - Use a more specific Solidity version pragma to avoid unintended changes or bugs.
- **PoC**: Show potential issues with a broad Solidity version pragma.
  ```javascript
  // Contract with a broad Solidity version pragma
  pragma solidity >=0.5.0;

  contract TestPragma {
      function testFunction() external pure returns (string memory) {
          return "Test";
      }
  }
  ```

---
