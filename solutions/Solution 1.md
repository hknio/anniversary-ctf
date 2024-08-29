# Solution 1

```solidity
function _authorizeUpgrade(address newImplementation) internal override {
    require(owner != msg.sender, "Not an owner.");
}
```

There is a typo inside the simple strategy contract, the "==" is mistyped as "!=".

It will allow us to call "challenge.simpleStrategy().upgradeTo()", which opens up an opportunity for the attack.

---

Reading Material: [How to Implement an Upgradeable Smart Contract with UUPS](https://medium.com/@pearliboy1/how-to-implement-an-upgradeable-smart-contract-with-uups-242c57f671ee)

Using the reading material above, we can build a smart contract and update the proxy to point to our new contract

The next thing is to look for what we can achieve by taking control of the simpleStrategy proxy

---

```solidity
try AnniversaryChallenge(address(this)).externalSafeApprove(amount) returns (bool) {
    simpleStrategy.deployFunds(amount);
} catch {
    trophyNFT.safeTransferFrom(address(this), receiver, 1);
    require(address(this).balance > 0 wei, "Nothing is for free.");
}
```

Our aim is to run the catch block, because we want to get the trophy.

Thus, our aim is to make the `externalSafeApprove` to fail/revert

---

By looking at the `externalSafeApprove` method, we found out that:

```solidity
function externalSafeApprove(uint256 amount) external returns (bool) {
    assert(msg.sender == address(this));
    IERC20(simpleStrategy.usdcAddress()).safeApprove(address(simpleStrategy), amount);
    return true;
}
```

This function have a few potential way to fail/revert

1. If the sender of this call is not the contract itself.
2. If there is any unspent previous approved amount.
3. If the USDC address is not a valid FT address, and don't have the safeApprove function signature.

Since we found an exploit inside the simpleStrategy contract, the easiest way is to edit the `deployFunds` method inside the simpleStrategy contract. If we delete all the code that spending the previous approved amount, then the next time it tries to call safeApprove, it will fail, thus triggering the catch block to run.

---

The next catch in the CTF is that there is a check after sending the NFT to make sure that the contract have some balance.

There is a check in the beginning of `claimTrophy` to make sure that the contract doesn't have any balance, but after sending the NFT, there is another check to make sure that the contract have some balance.

If we try to send ether to the contract inside the `deployFunds` method, then we won't be able to reenter the `claimTrophy` method again, because this time we will be blocked at the entrance...

But we can try to send ether to the contract by using the NFT transfer. We can use IERC721TokenReceiver to do something in response to the NFT transfer.

---

To solve the problem that `AnniversaryChallenge` doesn't have any way for us to send ether, we can use this approach: [Ethernaut Lvl 7 Force Walkthrough — How to selfdestruct and create an Ether blackhole](https://medium.com/coinmonks/ethernaut-lvl-7-walkthrough-how-to-selfdestruct-and-create-an-ether-blackhole-eb5bb72d2c57)

---

Up to now, we have found ways to penetrate through the contracts, and claim trophy.

However, the CTF rules seems to mentioned that it wants the hack to be perform in one transaction.

To perform multiple contract calls inside one transaction, the best way is to write a smart contract and put all the instruction into it... If any of the instruction is failed, due to atomic nature, everything will be reverted.

However, there is a check to make sure that the sender's code length is zero inside the `claimTrophy` method.

To bypass this check, we can use constructor, as explained inside [Ethernaut Level 14 - Gatekeeper Two](https://blog.dixitaditya.com/ethernaut-level-14-gatekeeper-two)
