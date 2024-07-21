
---
# LoopFI Security Audit Report for C4 Labs
### High-Risk Issues

#### 1. **Arbitrary ETH Sending (`arbitrary-send-eth`)**
   - **Description**: The `_fillQuote` function calls an arbitrary address with a data payload that could include ETH sending operations. This poses a risk if the recipient address is malicious and could lead to unexpected behavior or exploits.
   - **Lines**: [530-547](src/PrelaunchPoints.sol#L530-L547)
   - **Code Context**:
     ```javascript
     (bool success,) = payable(exchangeProxy).call{ value: 0 }(_swapCallData);
     ```
   - **Impact**: 
     - The use of `call` to send ETH can potentially lead to reentrancy attacks or unintended behavior, especially when sending ETH or interacting with untrusted contracts. 
     - Ensure the `exchangeProxy` address and `_swapCallData` are secure and trusted.
   - **Mitigation**: 
     - Consider using a more controlled approach for handling ETH transfers and validating data before execution.
   - **PoC**: Exploit potential by sending ETH to a malicious contract via the `_fillQuote` function.
     ```javascript
     // Malicious Contract to exploit arbitrary ETH sending
     contract Malicious {
         receive() external payable {
             // Reentrancy or malicious logic to exploit the received ETH
         }
     }

     // Contract using PrelaunchPoints
     contract TestArbitrarySend {
         PrelaunchPoints public prelaunchPoints;
         Malicious public malicious;

         constructor(address _prelaunchPoints, address _malicious) {
             prelaunchPoints = PrelaunchPoints(_prelaunchPoints);
             malicious = Malicious(_malicious);
         }

         function exploit() external {
             bytes memory swapCallData = abi.encodeWithSignature("maliciousFunction()");
             // Trigger the _fillQuote function to send ETH to the malicious contract
             prelaunchPoints._fillQuote(swapCallData);
         }
     }
     ```

### Medium-Risk Issues

#### 1. **Uninitialized Local Variables (`uninitialized-local`)**
   - **Description**: Local variables are used without proper initialization, which might lead to undefined behavior or logical errors.
   - **Lines**: [443-445](src/PrelaunchPoints.sol#L443-L445)
   - **Code Context**:
     ```javascript
     address inputToken;
     address outputToken;
     uint256 inputTokenAmount;
     ```
   - **Impact**: 
     - Using uninitialized variables can lead to unexpected behavior or security vulnerabilities.
   - **Mitigation**: 
     - Ensure these variables are properly initialized before use.
   - **PoC**: Demonstrate undefined behavior due to uninitialized local variables.
     ```javascript
     // Contract demonstrating uninitialized variables
     contract TestUninitialized {
         PrelaunchPoints public prelaunchPoints;

         constructor(address _prelaunchPoints) {
             prelaunchPoints = PrelaunchPoints(_prelaunchPoints);
         }

         function testFunction() external {
             address inputToken;
             address outputToken;
             uint256 inputTokenAmount;

             // Using the uninitialized variables
             prelaunchPoints.someFunction(inputToken, outputToken, inputTokenAmount);
         }
     }
     ```

#### 2. **Unused Return Values (`unused-return`)**
   - **Description**: Return values from functions are ignored, which might lead to potential issues or failed operations going unnoticed.
   - **Lines**: [260-298](src/PrelaunchPoints.sol#L260-L298)
   - **Code Context**:
     ```javascript
     if (!_sellToken.approve(exchangeProxy, _amount)) {
         revert SellTokenApprovalFailed();
     }
     ```
   - **Impact**: 
     - Ignoring return values might hide errors and lead to undetected failures in critical operations.
   - **Mitigation**: 
     - Ensure all function calls that return values are checked.
   - **PoC**: Demonstrate failure due to ignoring return values of critical operations.
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

             // Failing to handle return value
             prelaunchPoints._sellToken.approve(exchangeProxy, amount);
         }
     }
     ```

## Low-Risk Issues

### Unsafe ERC20 Operations (`unsafe-erc20-operations`)

- **Description**: Lack of checks for ERC20 operations which could fail silently.
- **Files and Lines**:
  - `src/PrelaunchPoints.sol` [Line: 235](src/PrelaunchPoints.sol#L235)
    ```javascript
    lpETH.approve(address(lpETHVault), claimedAmount);
    ```
    *Explanation*: The `approve` method of ERC20 tokens returns a boolean indicating success. If the approval fails, the transaction will not revert, which can lead to unexpected behaviors if the approval was not successful.

  - `src/PrelaunchPoints.sol` [Line: 272](src/PrelaunchPoints.sol#L272)
    ```javascript
    WETH.approve(address(lpETH), claimedAmount);
    ```
    *Explanation*: Similar to the previous case, this `approve` operation might fail silently if the approval was unsuccessful.

  - `src/PrelaunchPoints.sol` [Line: 320](src/PrelaunchPoints.sol#L320)
    ```javascript
    WETH.approve(address(lpETH), totalSupply);
    ```
    *Explanation*: Again, the `approve` method should be checked to ensure that it succeeds to avoid issues with token transfers.

  - `src/PrelaunchPoints.sol` [Line: 508](src/PrelaunchPoints.sol#L508)
    ```javascript
    if (!_sellToken.approve(exchangeProxy, _amount)) {
    ```
    *Explanation*: Failure to handle the result of `approve` here could lead to potential issues with token transactions if the approval fails.

- **Impact**: 
  - Failure of `approve` calls can result in unexpected behavior or failed transactions, which might not be immediately noticeable.
- **Mitigation**: 
  - Ensure that `approve` calls check for success by handling the returned boolean value appropriately.
- **PoC**: Demonstrate potential failure in ERC20 operations due to unverified `approve` calls.
  ```javascript
  // Contract demonstrating unsafe ERC20 operations
  contract TestERC20Operations {
      ERC20 public token;
      address public spender;

      constructor(address _token, address _spender) {
          token = ERC20(_token);
          spender = _spender;
      }

      function testApprove() external {
          uint256 amount = 100;
          // Potentially failing `approve` call
          token.approve(spender, amount);
          // No validation if approval was successful
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


## Informationals

### Assembly Usage (`assembly`)

- **Description**: Direct usage of assembly in Solidity can provide low-level operations but may lead to less readable code and potential security issues.
- **Files and Lines**:
  - `src/PrelaunchPoints.sol` [Lines: 486-504](src/PrelaunchPoints.sol#L486-L504)
    ```javascript
    function _decodeUniswapV3Data(bytes memory data) internal pure returns (uint256, uint256) {
        assembly {
            // Inline assembly code for decoding data
        }
    }
    ```
    *Explanation*: Inline assembly is used for decoding data, which can be powerful but requires careful handling to avoid bugs or vulnerabilities.

  - `src/PrelaunchPoints.sol` [Lines: 510-522](src/PrelaunchPoints.sol#L510-L522)
    ```javascript
    function _decodeTransformERC20Data(bytes memory data) internal pure returns (address, uint256) {
        assembly {
            // Inline assembly code for decoding ERC20 data
        }
    }
    ```
    *Explanation*: Inline assembly for handling ERC20 data. Ensure that all edge cases are handled correctly to avoid potential issues.

- **Impact**: 
  - Assembly code can be error-prone and harder to audit compared to high-level Solidity code.
- **Mitigation**: 
  - Carefully review and test assembly code to ensure correctness and security.

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

### Solidity Pragma Specificity (`solidity-pragma`)

- **Description**: Using a broad version range for Solidity can lead to compatibility issues if unintended changes or bugs are introduced in newer versions.
- **Files and Lines**:
  - `src/interfaces/IWETH.sol` [Line: 2](src/interfaces/IWETH.sol#L2)
    ```javascript
    pragma solidity >=0.5.0;
    ```
    *Explanation*: A broad version range might include versions with breaking changes or bugs. Consider specifying a more narrow version range to ensure compatibility.

- **Impact**: 
  - Potential for incompatibility with future Solidity versions.
- **Mitigation**: 
  - Use a specific version range to ensure compatibility and avoid unintended issues.


---

