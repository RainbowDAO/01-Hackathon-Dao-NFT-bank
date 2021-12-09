pragma solidity ^0.8.0;
pragma experimental ABIEncoderV2;

import "@openzeppelin/contracts/access/Ownable.sol";
import "../RainbowBank/RainbowBank.sol";

contract RbBankOrchestrator is  Ownable{
    address  public bank;
    
    mapping(address => address) public bankOwner;
    
    function init(address user)public  onlyOwner{
        bank = address(new RainbowBank(user));
        bankOwner[user] =bank;
    }
    
     function  input(address tokenAddr,address _deposits) public{
         RainbowBank(bank).init(tokenAddr, _deposits);
    }
    
    function detonate() public  onlyOwner {
        selfdestruct(payable(owner()));
    }

}
