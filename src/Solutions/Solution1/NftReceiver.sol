// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC721/IERC721Receiver.sol";
import {ERC721} from "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import {Force} from "./Force.sol";

contract NftReceiver is IERC721Receiver {
    address public owner;

    constructor(address _owner) payable {
        owner = _owner;
    }

    function onERC721Received(
        address operator,
        address from,
        uint256 tokenId,
        bytes calldata data
    ) external returns (bytes4) {
        new Force{value: 1 wei}(from);

        ERC721(msg.sender).safeTransferFrom(address(this), owner, tokenId);

        return IERC721Receiver.onERC721Received.selector;
    }
}