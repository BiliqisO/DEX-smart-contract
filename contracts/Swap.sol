// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

import "./interface.sol";

contract Swap{
    ISwap tokenA;
    ISwap tokenB;
    uint ReserveA;
    uint ReserveB;
    address user;
    uint liquidity;
    uint k;
    struct LiquidityProvider{
        uint AmountA;
        uint AmountB;
    }
mapping (address => LiquidityProvider) mapLiquidityProvider;
mapping (address => uint) public Liquidity;
    constructor (address _TokenA, address _TokenB) {
        tokenA = ISwap(_TokenA);
        tokenB = ISwap(_TokenB);
        // user = msg.sender;
    }
   function addLiquidity(uint _amountA, uint _amountB) external {
        tokenA.transferFrom(msg.sender, address(this), _amountA);
        tokenB.transferFrom(msg.sender, address(this), _amountB);
        ReserveA += _amountA;
        ReserveB += _amountB;
      LiquidityProvider storage liquidityProvider =  mapLiquidityProvider[msg.sender];
      liquidityProvider.AmountA += _amountA;
      liquidityProvider.AmountB += _amountB;
      Liquidity[msg.sender] =  _amountA * _amountB;
      k =  Liquidity[msg.sender];
      user = msg.sender;

    }
   function removeLiquidity(uint _amountA, uint _amountB) external {
  require (user == msg.sender, "you are not authorised to remove liquisity");
        tokenA.transfer(user, _amountA);
        tokenB.transfer(user, _amountB);
        ReserveA -= _amountA;
        ReserveB -= _amountB;
      LiquidityProvider storage liquidityProvider =  mapLiquidityProvider[msg.sender];
      liquidityProvider.AmountA -= _amountA;
      liquidityProvider.AmountB -= _amountB;
        Liquidity[user] =  _amountA * _amountB;
      k =  Liquidity[user];

    }
    function swapAforB(uint amounta, address receiver) external{
         LiquidityProvider storage liquidityProvider =  mapLiquidityProvider[msg.sender];
         uint amountA= liquidityProvider.AmountA;
         uint amountB = liquidityProvider.AmountB;
        uint amountb = amountB - (k / (amountA + amounta));
        tokenA.transfer( receiver, amountb);
        mapLiquidityProvider[msg.sender].AmountA -= amounta;
        mapLiquidityProvider[receiver].AmountB += amountb;
    }
    function swapBforA(uint  amountb, address receiver) external{
         LiquidityProvider storage liquidityProvider =  mapLiquidityProvider[msg.sender];
         uint amountA = liquidityProvider.AmountA;
          uint amountB = liquidityProvider.AmountB;
        uint amounta = amountA - (k / (amountB - amountb));
         tokenB.transfer(receiver, amounta);
          mapLiquidityProvider[msg.sender].AmountB -= amountb;
               mapLiquidityProvider[receiver].AmountA += amounta;
    }
    function returnvalues( address _address) external view returns (uint){
  return(  Liquidity[_address] );
    }
}

