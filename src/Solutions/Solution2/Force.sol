// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.20;

contract Force {
    constructor(address _beneficiary) payable {
        selfdestruct(payable(_beneficiary));
    }
}