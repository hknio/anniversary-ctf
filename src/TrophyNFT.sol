// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.20;

import {ERC721} from "@openzeppelin/contracts/token/ERC721/ERC721.sol";

contract TrophyNFT is ERC721  {
    constructor() ERC721("Hacken Trophy NFT", "HTN")  {
        _mint(msg.sender, 1);
    }
}
