// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
contract TokenA is ERC20 {
    constructor() ERC20("myTokenA", "MTA") {
        _mint(msg.sender,  1_000_000e18 );
    }
}