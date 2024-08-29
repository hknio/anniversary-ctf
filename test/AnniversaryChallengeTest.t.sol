// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.20;

import {Test, console} from "forge-std/Test.sol";
import {AnniversaryChallenge} from "../src/AnniversaryChallenge.sol";
import {SimpleStrategy} from "../src/SimpleStrategy.sol";
import {IERC721} from "@openzeppelin/contracts/token/ERC721/IERC721.sol";
import {ERC1967Proxy} from "@openzeppelin/contracts/proxy/ERC1967/ERC1967Proxy.sol";
import {Solution1} from "../src/Solutions/Solution1/Solution1.sol"; 
import {Solution2} from "../src/Solutions/Solution2/Solution2.sol";

// Rules:
// 1. Use Ethernet fork.
// 2. Use 20486120 block.
// 3. No deal() and vm.deal() allowed.
// 4. No setUp() amendmends allowed.
// 5. The exploit must be executed in single transaction. 
// 6. Your task is to claim trophy and get Trophy NFT as player account.
contract AnniversaryChallengeTest is Test {
    address player;
    AnniversaryChallenge challenge;

    //Rules: No setUp changes are allowed.
    function setUp() public {
        player = vm.addr(42);
        vm.deal(player, 1 ether);

        address simpleStrategyImplementation = address(new SimpleStrategy());
        bytes memory data = abi.encodeCall(SimpleStrategy.initialize, address(challenge));
        address proxy = address(new ERC1967Proxy(simpleStrategyImplementation, data));
        SimpleStrategy simpleStrategy = SimpleStrategy(proxy);

        challenge = new AnniversaryChallenge(simpleStrategy);

        deal(simpleStrategy.usdcAddress(), address(challenge), 1e6);
    }

    function test_claimTrophy() public {
        vm.startPrank(player);
        //Execute exploit here.

        new Solution1{ value: 1 wei }(address(challenge));

        //No execution of exploit after this point.
        vm.stopPrank();
        assertEq(challenge.trophyNFT().ownerOf(1), player);
    }

    function test_claimTrophy2() public {
        vm.startPrank(player);
        //Execute exploit here.

        new Solution2{ value: 1 wei }(address(challenge));

        //No execution of exploit after this point.
        vm.stopPrank();
        assertEq(challenge.trophyNFT().ownerOf(1), player);
    }
}
