// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

import "./interface.sol";



contract Swap{
    ISwap tokenA;
    ISwap tokenB;
     uint  ReserveA;
    uint  ReserveB;
    struct LiquidityProvider{
        uint AmountA;
        uint AmountB;
    }
mapping (address => LiquidityProvider) public  mapLiquidityProvider;
    constructor (address _TokenA, address _TokenB) {
        tokenA = ISwap(_TokenA);
        tokenB = ISwap(_TokenB);
        // user = msg.sender;
    }
 //add liquidity into the contract
    function addLiquidity(uint _amountA, uint _amountB) external {
        tokenA.transferFrom(msg.sender, address(this), _amountA);
        tokenB.transferFrom(msg.sender, address(this), _amountB);
        ReserveA += _amountA;
        ReserveB += _amountB;
      LiquidityProvider storage liquidityProvider =  mapLiquidityProvider[msg.sender];
      liquidityProvider.AmountA += _amountA;
      liquidityProvider.AmountB += _amountB;
      
    }


    function removeLiquidity(uint _amountA, uint _amountB) external {
      LiquidityProvider storage liquidityProvider =  mapLiquidityProvider[msg.sender];
      require(liquidityProvider.AmountA >= _amountA, "Insuffiecient Token A Balance for provider");
      require(liquidityProvider.AmountB >= _amountB, "Insuffiecient Token B Balance for provider");

      liquidityProvider.AmountA -= _amountA;
      liquidityProvider.AmountB -= _amountB;
      ReserveA -= _amountA;
      ReserveB -= _amountB;
      
      tokenA.transfer(msg.sender, _amountA);
      tokenB.transfer(msg.sender, _amountB);
    }


    function K() public view returns(uint){
      return   ReserveA * ReserveB;
    }

    
    function swapAforB(uint amounta) external{
      require(tokenA.balanceOf(msg.sender) >= amounta, "Insufficient funds ");
       uint amountb = ReserveB - (K() / (ReserveA + amounta));
 
      tokenA.transferFrom(msg.sender, address(this), amounta);  
      LiquidityProvider storage liquidityProvider =  mapLiquidityProvider[msg.sender];
      liquidityProvider.AmountA += amounta;
      liquidityProvider.AmountB -= amountb;
       
      tokenB.transfer(msg.sender, amountb);
    }
    function swapBforA(uint  amountb) external{
      require(tokenB.balanceOf(msg.sender) >= amountb, "Insufficient funds ");
       uint amounta = ReserveA - (K() / (ReserveB + amountb));
  LiquidityProvider storage liquidityProvider =  mapLiquidityProvider[msg.sender];
      tokenB.transferFrom(msg.sender, address(this), amounta);  
       liquidityProvider.AmountA += amountb;
      liquidityProvider.AmountB  -= amounta;

      tokenA.transfer(msg.sender, amountb);
    }

}