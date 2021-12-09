pragma solidity ^0.8.0;

import "../interface/token721/IRbtDeposit721.sol";
import "../lib/TransferHelper.sol";
import "../interface/token20/IERC20.sol";


contract RainbowBank{
    IRbtDeposit721 deposit;
    //Recording the last bank balance There is a lack of a way to get bank balances here
    uint private reserve;
    address token20;
    address manager;
    uint amount;
    mapping(address => bool) public allowTken;
    
    event DepositToken(address to , uint indexed month ,uint indexed value);
    event Withdrawa(address indexed to,uint indexed tokenId);
    constructor(address user) public{
        manager = user;
    }

    modifier onlyAdmin(){
        require(msg.sender == manager, "u are not manager");
        _;
    }
    function init(address token , address _deposits)  external {
        token20 = token;
        deposit=IRbtDeposit721(_deposits);
    }

    function depositToken(address to,uint month,uint value) external {
        require(month==0||month==3||month==6||month==12||month==24||month==36,"Deposit month error");
        TransferHelper.safeTransferFrom(token20,to,address(this), value);
        deposit.mint(to, value, month);
        uint balance=IERC20(token20).balanceOf(address(this));
        amount=balance-reserve;
        reserve = balance;
        emit DepositToken(to,month,value);
    }

    function withdrawa(address token,address to,uint tokenId) external {
        uint32 blockTime = uint32(block.timestamp % 2 ** 32);
        uint value=amount;
        require(blockTime>=deposit.expire(tokenId),'unable to extract');
        TransferHelper.safeTransfer(token20, to, value);
        deposit.burn(tokenId);
        uint balance=IERC20(token20).balanceOf(address(this));
        reserve =balance ;       
        emit Withdrawa(to,tokenId);
    }
}