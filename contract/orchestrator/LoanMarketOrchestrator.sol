
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
pragma experimental ABIEncoderV2;
import "@openzeppelin/contracts/access/Ownable.sol";
import "../RainbowBank/market721/LoanMarket.sol";

contract LoanMarketOrchestrator is  Ownable{
    address public loanMarket;
    address public agent;
    function init(address user,address _token,address _deposit) public  onlyOwner{
        loanMarket=address(new LoanMarket(user));
        LoanMarket(loanMarket).init(user,_token, _deposit);
    }
    function detonate() public  onlyOwner {
        selfdestruct(payable(owner()));
    }
    
}