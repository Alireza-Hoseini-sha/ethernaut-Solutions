### Ethernaut 23 — Dex Two (Foundry)

This repository contains a Foundry solution for Ethernaut Level 23: Dex Two.

### Level details

```
Submit level txnHash: 0xc1182d89def3bda5fd05e47e877019b114b1dabb46e2b2b8a8fd386b8941d0cb
Instance address: 0x75Bf3E1bD5c3C34558A7eB8b6F4c6CF06f87fB6a
Level address: 0x473c8dF98DFd41304Bff2c5945B9f73e30f5c013
```

### Challenge summary

- **Goal**: Drain all balances of `token1` and `token2` from the `DexTwo` contract.
- **Quirk**: `DexTwo.swap` does not restrict swaps to the two official tokens; any ERC20 can be used.
- **Pricing formula**: `swapAmount = amount * balance(to) / balance(from)` enables manipulation by seeding a malicious token into Dex liquidity.

### Vulnerability and exploit

- **Vulnerability**: `swap(address from, address to, uint256 amount)` accepts arbitrary token addresses and transfers based on the pool balances. There is no check that `from`/`to` are `token1`/`token2`.
- **Exploit idea**: Mint attacker-controlled tokens, transfer some to the DEX to influence the ratio, then swap 1:1 against each legit token to drain them.

Key lines in `src/DexTwo.sol`:

- `getSwapAmount` uses DEX balances to determine output, regardless of token identity.
- The contract approves itself and then `transferFrom`s from its own address, completing the swap for any ERC20 that follows the interface.

### Solution approach

Implemented in `script/Solve.s.sol`:

1. Read `token1` and `token2` from the on-chain instance.
2. Deploy two fresh `SwappableTokenTwo` tokens: `tokenX`, `tokenY`.
3. Seed the DEX with `tokenX` and `tokenY` liquidity (e.g., 100 each).
4. Perform two swaps using the custom tokens as `from` to drain `token1` and `token2`.

After execution, the DEX balances of both `token1` and `token2` should be `0`.

### Repository layout

- `src/DexTwo.sol`: Level contract and `SwappableTokenTwo` implementation.
- `script/Solve.s.sol`: Attack helper contract and broadcastable script.
- `lib/openzeppelin-contracts`: OZ interfaces and ERC20 implementation (via submodule/forge install).

### Prerequisites

- Foundry installed (`forge`, `cast`). See Foundry docs if needed.
- An RPC URL with the target network where your Ethernaut instance is deployed.
- A funded private key in your Foundry wallet for broadcasting.

### How to run

Replace `YOUR_RPC_URL` with your endpoint (e.g., Ankr/Alchemy/Infura), and ensure your default key is funded for gas. The script targets the deployed instance at the address embedded in `Solve.s.sol`.

```bash
forge script script/Solve.s.sol:Solve \
  --rpc-url YOUR_RPC_URL \
  --broadcast -vvvv
```

Expected console output at the end should show both DEX token balances as zero:

```text
token 1 dex balance: 0
token 2 dex balance: 0
```

If your addresses differ, edit `instanceAddr` in `script/Solve.s.sol`:

```solidity
address instanceAddr = 0x75Bf3E1bD5c3C34558A7eB8b6F4c6CF06f87fB6a;
```

### Notes

- The attack leverages unrestricted token pairs and a manipulable constant-product-like formula without invariant enforcement. By introducing an attacker token with controlled supply/liquidity, the swap rate can be skewed to drain reserves.
- `SwappableTokenTwo.approve` forbids the DEX from approving on its own behalf, but this does not mitigate the issue since swaps move DEX funds via its own `transferFrom` after it sets approval to itself for the output token.

### Screenshot

![**alt text**](<Screenshot .png>)
