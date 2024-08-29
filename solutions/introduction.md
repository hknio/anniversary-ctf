# Introduction

This CTF seems to utilise a lot of OpenZeppilin libraries.

OpenZeppelin have one smart contract security puzzles called [Ethernaut](https://ethernaut.openzeppelin.com/). Exploring on the Ethernaut security puzzles before approaching this challenge might helps a lot.

Most of the strategy used inside Solution 1 are introduced inside the Ethernaut security puzzles project.

## How to run a forked mainnet environment for testing

```shell
anvil --fork-url https://rpc.ankr.com/eth --fork-block-number 20486120
forge test --rpc-url http://127.0.0.1:8545/ -w
```

(Example only: you can use other RPC endpoint)

## Warn: Solution 2 might be overcomplicated

Solution 2 might makes be overcomplicated for this CTF... It is purely build for fun purpose to demonstrate how the CTF can be done in a more "elegant" way.

If you are an artist, you might love the way how Solution 2 was built.
