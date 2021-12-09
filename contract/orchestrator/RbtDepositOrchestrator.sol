pragma solidity ^0.8.0;
pragma experimental ABIEncoderV2;

import "@openzeppelin/contracts/access/Ownable.sol";
import "../token721/RbtDeposit721.sol";


contract RbtDepositOrchestrator is  Ownable{
    address public deposit;
    function init( address user) public  onlyOwner{
        deposit= address(new RbtDeposit721(user));
    }
    function input(address _bank) public onlyOwner {
        RbtDeposit721(deposit).init(_bank);
    }
    function detonate() public  onlyOwner {
        selfdestruct(payable(owner()));
    }
    
}