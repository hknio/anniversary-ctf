# Solution 3

Please read [Solution 2](Solution%202.md) before continue reading on this.

## This is a failed solution that I originally planned, I will explain what I tried to do, and why it failed

In this solution, I am tyring to think how to hack without even need to use ERC721 Token Receiver

```solidity
function claimTrophy(address receiver, uint256 amount) public {
    require(msg.sender.code.length == 0, "No contractcs.");
    // 1. Contract balanace is checked here
    require(address(this).balance == 0, "No treasury.");
    require(simpleStrategy.usdcAddress() == 0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48, "Only real USDC.");

    try AnniversaryChallenge(address(this)).externalSafeApprove(amount) returns (bool) {
        simpleStrategy.deployFunds(amount);
    } catch {
        // 3. Then after the try block finished executing, and entering catch block, the contract already have balance.
        trophyNFT.safeTransferFrom(address(this), receiver, 1);

        // 4. Thus this line won't failed
        require(address(this).balance > 0 wei, "Nothing is for free.");
    }
}

function externalSafeApprove(uint256 amount) external returns (bool) {
    assert(msg.sender == address(this));
    // 2. If we could send ether to the contract inside this line
    IERC20(simpleStrategy.usdcAddress()).safeApprove(address(simpleStrategy), amount);
    return true;
}
```

## Unluckily, this attempt is not working

In order to send ether to contract inside the `simpleStrategy.usdcAddress()`, then the usdcAddress will be a function that change state.

However, this line would means that the simpleStrategy.usdcAddress can't must be either a view function or view property

```solidity
SimpleStrategy public simpleStrategy;
```

SimpleStrategy was written by the original author, and at the time it was written, `usdcAddress` was an immutable view property.

Although we can "upgrade" the contract by using UUPSUpgradable library, however, if we change usdcAddress from a "view" property to become a "state changing function", then EVM will revert.

## Conclusion

Thus, solution 2 is already the most "artistic" way to crack the CTF that I could think of.
