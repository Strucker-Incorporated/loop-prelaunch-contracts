
---

# Tooling and Recon Analysis Report

## Table of Contents

- [Summary](#summary)
  - [Files Summary](#files-summary)
  - [Files Details](#files-details)
  - [Issue Summary](#issue-summary)
- [High-Risk Issues](#high-risk-issues)
- [Medium-Risk Issues](#medium-risk-issues)
- [Low-Risk Issues](#low-risk-issues)

## Summary

### Files Summary

| Key | Value |
| --- | --- |
| .sol Files | 10 |
| Total nSLOC | 456 |

### Files Details

| Filepath | nSLOC |
| --- | --- |
| src/PrelaunchPoints.sol | 326 |
| src/interfaces/ILpETH.sol | 10 |
| src/interfaces/ILpETHVault.sol | 5 |
| src/interfaces/IWETH.sol | 7 |

| **Total** | **456** |

### Issue Summary

| Category | No. of Issues |
| --- | --- |
| High | 2 |
| Medium | 5 |
| Low | 9 |

## High-Risk Issues

### Arbitrary ETH Sending (`arbitrary-send-eth`)

- **Description**: The `_fillQuote` function sends ETH to an arbitrary user, which could be exploited if the recipient address is malicious.
- **Files and Lines**:
  - `src/PrelaunchPoints.sol` [Lines: 530-547](src/PrelaunchPoints.sol#L530-L547)
    ```solidity
    address(exchangeProxy).call{value: 0}(_swapCallData)
    ```

## Medium-Risk Issues

### Uninitialized Local Variables (`uninitialized-local`)

- **Description**: Local variables are used without proper initialization, which might lead to undefined behavior.
- **Files and Lines**:
  - `src/PrelaunchPoints.sol` [Line: 443](src/PrelaunchPoints.sol#L443)
    ```solidity
    inputToken
    ```
  - `src/PrelaunchPoints.sol` [Line: 444](src/PrelaunchPoints.sol#L444)
    ```solidity
    outputToken
    ```
  - `src/PrelaunchPoints.sol` [Line: 445](src/PrelaunchPoints.sol#L445)
    ```solidity
    inputTokenAmount
    ```

### Unused Return Values (`unused-return`)

- **Description**: Return values from functions are ignored, which might lead to potential issues or failed operations going unnoticed.
- **Files and Lines**:
  - `src/PrelaunchPoints.sol` [Lines: 260-298](src/PrelaunchPoints.sol#L260-L298)
    ```solidity
    WETH.approve(address(lpETH), claimedAmount)
    ```
  - `src/PrelaunchPoints.sol` [Lines: 336-352](src/PrelaunchPoints.sol#L336-L352)
    ```solidity
    WETH.approve(address(lpETH), totalSupply)
    ```
  - `src/PrelaunchPoints.sol` [Lines: 336-352](src/PrelaunchPoints.sol#L336-L352)
    ```solidity
    lpETH.deposit(totalSupply, address(this))
    ```
  - `src/PrelaunchPoints.sol` [Lines: 260-298](src/PrelaunchPoints.sol#L260-L298)
    ```solidity
    lpETH.deposit(claimedAmount, _receiver)
    ```
  - `src/PrelaunchPoints.sol` [Lines: 240-255](src/PrelaunchPoints.sol#L240-L255)
    ```solidity
    lpETH.approve(address(lpETHVault), claimedAmount)
    ```

## Low-Risk Issues

### Unsafe ERC20 Operations (`unsafe-erc20-operations`)

- **Description**: Lack of checks for ERC20 operations which could fail silently.
- **Files and Lines**:
  - `src/PrelaunchPoints.sol` [Line: 235](src/PrelaunchPoints.sol#L235)
    ```solidity
    lpETH.approve(address(lpETHVault), claimedAmount);
    ```
  - `src/PrelaunchPoints.sol` [Line: 272](src/PrelaunchPoints.sol#L272)
    ```solidity
    WETH.approve(address(lpETH), claimedAmount);
    ```
  - `src/PrelaunchPoints.sol` [Line: 320](src/PrelaunchPoints.sol#L320)
    ```solidity
    WETH.approve(address(lpETH), totalSupply);
    ```
  - `src/PrelaunchPoints.sol` [Line: 508](src/PrelaunchPoints.sol#L508)
    ```solidity
    if (!_sellToken.approve(exchangeProxy, _amount)) {
    ```

### Solidity Pragma Specificity (`solidity-pragma`)

- **Description**: Using a wide version of Solidity pragma.
- **Files and Lines**:
  - `src/interfaces/IWETH.sol` [Line: 2](src/interfaces/IWETH.sol#L2)
    ```solidity
    pragma solidity >=0.5.0;
    ```

### Missing Zero-Checks (`missing-zero-check`)

- **Description**: Checks for `address(0)` when assigning values are missing.
- **Files and Lines**:
  - `src/PrelaunchPoints.sol` [Line: 337](src/PrelaunchPoints.sol#L337)
    ```solidity
    proposedOwner = _owner;
    ```
  - `src/PrelaunchPoints.sol` [Line: 365](src/PrelaunchPoints.sol#L365)
    ```solidity
    lpETH = ILpETH(_loopAddress);
    ```
  - `src/PrelaunchPoints.sol` [Line: 366](src/PrelaunchPoints.sol#L366)
    ```solidity
    lpETHVault = ILpETHVault(_vaultAddress);
    ```

### Event Missing Indexed Fields (`event-missing-indexed-fields`)

- **Description**: Events are missing indexed fields for efficient querying.
- **Files and Lines**:
  - `src/PrelaunchPoints.sol` [Line: 58](src/PrelaunchPoints.sol#L58)
    ```solidity
    event StakedVault(address indexed user, uint256 amount, uint256 typeIndex);
    ```
  - `src/PrelaunchPoints.sol` [Line: 59](src/PrelaunchPoints.sol#L59)
    ```solidity
    event Converted(uint256 amountETH, uint256 amountlpETH);
    ```
  - `src/PrelaunchPoints.sol` [Line: 60](src/PrelaunchPoints.sol#L60)
    ```solidity
    event Withdrawn(address indexed user, address indexed token, uint256 amount);
    ```
  - `src/PrelaunchPoints.sol` [Line: 61](src/PrelaunchPoints.sol#L61)
    ```solidity
    event Claimed(address indexed user, address indexed token, uint256 reward);
    ```
  - `src/PrelaunchPoints.sol` [Line: 62](src/PrelaunchPoints.sol#L62)
    ```solidity
    event Recovered(address token, uint256 amount);
    ```
  - `src/PrelaunchPoints.sol` [Line: 63](src/PrelaunchPoints.sol#L63)
    ```solidity
    event OwnerProposed(address newOwner);
    ```
  - `src/PrelaunchPoints.sol` [Line: 64](src/PrelaunchPoints.sol#L64)
    ```solidity
    event OwnerUpdated(address newOwner);
    ```
  - `src/PrelaunchPoints.sol` [Line: 65](src/PrelaunchPoints.sol#L65)
    ```solidity
    event LoopAddressesUpdated(address loopAddress, address vaultAddress);
    ```
  - `src/PrelaunchPoints.sol` [Line: 66](src/PrelaunchPoints.sol#L66)
    ```solidity
    event SwappedTokens(address sellToken, uint256 sellAmount, uint256 buyETHAmount);
    ```

### PUSH0 Compatibility (`push0-compatibility`)

- **Description**: Use of `PUSH0` opcode which might not be supported by all chains.
- **Files and Lines**:
  - `src/PrelaunchPoints.sol` [Line: 2](src/PrelaunchPoints.sol#L2)
    ```solidity
    pragma solidity 0.8.20;
    ```
  - `src/interfaces/ILpETH.sol` [Line: 2](src/interfaces/ILpETH.sol#L2)
    ```solidity
    pragma solidity 0.8.20;
    ```
  - `src/interfaces/ILpETHVault.sol` [Line: 2](src/interfaces/ILpETHVault.sol#L2)
    ```solidity
    pragma solidity 0.8.20;
    ```

### Unused Custom Error

 (`unused-custom-error`)

- **Description**: Custom error defined but not used.
- **Files and Lines**:
  - `src/PrelaunchPoints.sol` [Line: 79](src/PrelaunchPoints.sol#L79)
    ```solidity
    error FailedToSendEther();
    ```

---
