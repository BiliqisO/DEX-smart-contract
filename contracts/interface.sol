// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

interface ISwap{
    function balanceOf(address _owner) external returns (uint256 balance);
function transfer(address _to, uint256 _value) external returns (bool success);
function transferFrom(address _from, address _to, uint256 _value) external returns (bool success);
}