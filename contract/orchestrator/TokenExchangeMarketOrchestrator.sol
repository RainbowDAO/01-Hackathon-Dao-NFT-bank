// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
pragma experimental ABIEncoderV2;
import "@openzeppelin/contracts/access/Ownable.sol";
import "../RainbowBank/market721/TokenExchangeMarket.sol";

contract TokenExchangeMarketOrchestrator is  Ownable{
    address public tokenExchange;
    address public agent;
    function init(address user,address token ,address agent) public  onlyOwner{
      tokenExchange=address(new TokenExchangeMarket(user));
      TokenExchangeMarket(tokenExchange).init(agent,token);
    }
    function detonate() public  onlyOwner {
      selfdestruct(payable(owner()));
    }
    
}