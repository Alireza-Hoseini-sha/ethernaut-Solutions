Submit level txnHash: 0xd34ab0021190cf0c1ad68e866797c8d61dc14b1440238cd75342b8a42a80c7fd
Instance address: 0x2E80eA6E80583997Df0720808DE835eF07595F4D
Level address: 0x4209f564b6fDB63B34866CEa4B43BF333BcAAAD9

the contract has 1 public boolean at slot #0, and a byte32 private password at slot#1.
so for finding the password  we should use this command with foundry in terminal:
```
cast storage "0x2E80eA6E80583997Df0720808DE835eF07595F4D" 1 --rpc-url $ARBITRUM_SEPOLIA
=> 0x412076657279207374726f6e67207365637265742070617373776f7264203a29

cast --to-ascii 0x412076657279207374726f6e67207365637265742070617373776f7264203a29
=> A very strong secret password :)
```
we can use the bytes32 version or the string version.