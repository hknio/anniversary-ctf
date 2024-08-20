// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.20;

import {TrophyNFT} from "./TrophyNFT.sol";
import {SimpleStrategy} from "./SimpleStrategy.sol";
import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import {SafeERC20} from "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";

contract AnniversaryChallenge {
    using SafeERC20 for IERC20;
    TrophyNFT public trophyNFT;
    SimpleStrategy public simpleStrategy;

    constructor (SimpleStrategy _simpleStrategy) {
        trophyNFT = new TrophyNFT();
        simpleStrategy = _simpleStrategy;
    }

    function claimTrophy(address receiver, uint256 amount) public {
        require(msg.sender.code.length == 0, "No contractcs.");
        require(address(this).balance == 0, "No treasury.");
        require(simpleStrategy.usdcAddress() == 0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48, "Only real USDC.");

        try AnniversaryChallenge(address(this)).externalSafeApprove(amount) returns (bool) {
            simpleStrategy.deployFunds(amount);
        } catch {
            trophyNFT.safeTransferFrom(address(this), receiver, 1);
            require(address(this).balance > 0 wei, "Nothing is for free.");
        }
    }

    function externalSafeApprove(uint256 amount) external returns (bool) {
        assert(msg.sender == address(this));
        IERC20(simpleStrategy.usdcAddress()).safeApprove(address(simpleStrategy), amount);
        return true;
    }
}
