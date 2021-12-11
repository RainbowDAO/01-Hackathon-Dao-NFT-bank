pragma solidity ^0.8.0;
import "../../interface/token721/IRbtDeposit721.sol";
import "../RainbowBank.sol";

contract LoanMarket {
    struct LoanRecording{
        uint tokenId;
        uint id;
        uint amount;
        uint money;
        uint day;
        uint dayRate;
        uint interest;
        uint contango;
        uint status;
        address owner;
        address lender;
    }
    
    LoanRecording[] public list;
    IRbtDeposit721 deposit;
    address to;
    address public manager;
    address token;
    //Third-party mediation address
    address agent;
    event MortgageMarket(uint  tokenId,uint amount ,uint day ,uint dayRate);
    event Repayment(uint indexed id,uint indexed day,uint indexed value);
    event RepealMortgage(uint indexed id);
    constructor(address user) public{
        manager = user;
    }

    //initialize
    function init(address _agent,address _deposits,address _token) public {
        agent=_agent;
        deposit=IRbtDeposit721(_deposits);
        token=_token;
    }

    //Mortgage voucher market
    function mortgageMarket(uint tokenId,uint amount ,uint day ,uint dayRate)public{
        require(deposit.ownerOf(tokenId)==msg.sender);
        uint32 blockTime = uint32(block.timestamp % 2 ** 32);
        //uint expireTime=blockTime+(day*86400);
        //Lending day days after the profit
        uint interest =amount*(dayRate*day);
        //Token deposit money
        uint mortgageAmount=deposit.amount(tokenId);
        //Overdue interest (set to be determined)
        uint contango=dayRate*2;
        uint id=list.length+1;
        LoanRecording memory record=LoanRecording({
             tokenId:tokenId,
             id:id,
             amount:mortgageAmount,
             money:amount,
             day:day,
             dayRate:dayRate,
             interest:interest,
             contango:contango,
             status:0,
             owner:deposit.ownerOf(tokenId),
             lender:address(0)
         });
         list.push(record);
        //The lender hands over the deposit token to a third-party intermediary
        deposit.safeTransferFrom(msg.sender,agent, tokenId);
        emit MortgageMarket(tokenId,amount,day,dayRate);
    }

    //Revoke the mortgage certificate on the market
    function repealMortgage(uint id)public{
        require(msg.sender==list[id-1].owner&&list[id-1].status==0,"The current user has no permissions");
        //Third-party intermediary return will return the token to the lender
        deposit.safeTransferFrom(agent,msg.sender, list[id-1].tokenId);
        //Delete the record in list
        delete list[id-1];
        emit RepealMortgage(id);
    }

    //The lender, if the borrowing time is exceeded, adds an additional deferred fee
    function lend(uint id,uint value)public{
        require(list[id-1].money==value,'Incorrect bid');
        //The funder calls the borrower about the rbt
        TransferHelper.safeTransferFrom(token,msg.sender,list[id-1].owner,value);
        //Change the credential status
        list[id-1].status=1;
        //Replace the zero address with the buyer's address
        list[id-1].lender=msg.sender;
    }
    
      function length() public view  returns (uint a){
        a = list.length;
    }


    function repayment(uint id,uint day,uint value)public{

        if(day <= list[id-1].day){
            require(value >= list[id-1].money + list[id-1].money*(list[id-1].dayRate/100)*day);
            TransferHelper.safeTransferFrom(token,msg.sender,list[id-1].lender ,list[id-1].money+list[id-1].money*(list[id-1].dayRate/100)*day);
            deposit.safeTransferFrom(agent, msg.sender, list[id-1].tokenId);
        }else if (day-list[id-1].day<=3){
            uint amount=list[id-1].money+list[id-1].interest+(day-list[id-1].day)*list[id-1].contango/100;
            require(value==amount);
            TransferHelper.safeTransferFrom(token,msg.sender, list[id-1].lender, amount);
            deposit.safeTransferFrom(agent, msg.sender, list[id-1].tokenId);
        }else if (day-list[id-1].day>3){
            deposit.safeTransferFrom(agent, list[id-1].lender, list[id-1].tokenId);
        }
        emit  Repayment(id,day,value);
    }
}