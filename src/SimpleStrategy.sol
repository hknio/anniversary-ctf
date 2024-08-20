// SPDX-License-Identifier: AGPL-3.0
pragma solidity ^0.8.20;

import {SafeERC20} from "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts-upgradeable/proxy/utils/UUPSUpgradeable.sol";
import {IERC4626} from "@openzeppelin/contracts/interfaces/IERC4626.sol";

contract SimpleStrategy is UUPSUpgradeable {
    using SafeERC20 for IERC20;

    address public owner;
    mapping(address => uint) public balances;
    address immutable public vault;
    address immutable public usdcAddress;

    constructor() {
        vault = 0xBe53A109B494E5c9f97b9Cd39Fe969BE68BF6204;
        usdcAddress = 0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48;
    }

    function initialize(address _owner) public initializer {
        owner = _owner;
        __UUPSUpgradeable_init();
    }

    function deployFunds(uint256 amount) external returns (uint256 shares) {
        require(amount > 0, "Zero amount not allowed.");
        balances[msg.sender] += amount;
        IERC20(usdcAddress).safeTransferFrom(msg.sender, address(this), amount);

        IERC20(usdcAddress).safeApprove(vault, amount);
        shares = IERC4626(vault).deposit(amount, address(this));
    }

    function freeFunds(uint256 amount) external {
        revert("Not implemented");
    }

    function harvestAndReport()
        external
        returns (uint256 totalAssets) {
        revert("Not implemented");
    }

    function _authorizeUpgrade(address newImplementation) internal override {
        require(owner != msg.sender, "Not an owner.");
    }

}
