# Solution 2

Please read [Solution 1](Solution%201.md) before continue reading on this.

## New changes

We noticed that `simpleStrategy.usdcAddress()` was called twice inside the `AnniversryChallenge`

If we could find a way to make `usdcAddress` to return different value when being called at different timing, then we might be able to bypass this check

```solidity
require(simpleStrategy.usdcAddress() == 0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48, "Only real USDC.");
```

## Using gasLeft()

gasLeft() can be used to calculate how much gas code is remaining, using this info and do a few trial and error, we could be able to know whether the `usdcAddress()` was called inside `claimTrohy`, or inside the `externalSafeApprove`

## Benefits of Solution 2 compared to Solution 1

1. No need to reenter, thus saving gas.
2. Even if the challenge is using `approve` instead of `safeApprove`, this approach can still make it fail
3. Even if inside the try block is having some code that we don't want it to be executed, we still can perform the hack, because we bypassed the entired try block. Example:

```solidity
try AnniversaryChallenge(address(this)).externalSafeApprove(amount) returns (bool) {
    // let's say we don't want this block to be run
    // Solution 1 will fail, but Solution 2 can still success
    trophyNFT.safeTransferFrom(address(this), anotherReceiver, 1);
} catch {
    trophyNFT.safeTransferFrom(address(this), receiver, 1);
    require(address(this).balance > 0 wei, "Nothing is for free.");
}
```
