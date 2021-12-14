pragma solidity ^0.8.0;
import "../../lib/TransferHelper.sol";
import "../../interface/token721/IRbtDeposit721.sol";


contract TokenExchangeMarket{
    
  struct NFTRecording {
    address owner;
    uint tokenId;
    uint  id;
    uint price;
    uint expireTime;
    uint status;
  }
  
  NFTRecording[] public list;
  
  address token;
  
  //Third-party intermediary addressThe third-party intermediary address
  address public agent;
  mapping (address=>uint)types;//address->types
  event SellToken(address from,uint tokenId,uint sellPrice,address _types);
  event BidToken(address  from,uint id, uint bid,address _types);
  event Revocation(uint indexed id,address indexed _types);
  
  constructor(address user) public{}
    
  function init(address _agent,address _token) external {
    agent= _agent;
    token = _token;

    }
 
  //Sell market (set token sale related information)
  function sellToken(address from,uint tokenId,uint sellPrice,address _types) public{
    //The time of the current block, in the unit32 range
    uint32 blockTime = uint32(block.timestamp % 2 ** 32);
    
    uint time=IRbtDeposit721(_types).expire(tokenId);
    
    require(from == IRbtDeposit721(_types).ownerOf(tokenId) && time >= blockTime,'The address cannot be set');
    uint id=list.length+1;
    NFTRecording memory record = NFTRecording({
      owner:from,
      tokenId:tokenId,
      id:id,
      price:sellPrice,
      expireTime:time,
      status:0
    });
    list.push(record);

    IRbtDeposit721(_types).safeTransferFrom(from,agent, tokenId);
    emit SellToken(from,tokenId,sellPrice,_types);
  }
      function listLength() public view  returns (uint lengthList){
        lengthList = list.length;
}

  function bidToken(address from,uint id, uint bid,address _types) public {
    require(bid==list[id-1].price,'Can not buy');
    TransferHelper.safeTransferFrom(token,from,list[id-1].owner, bid);
    IRbtDeposit721(_types).safeTransferFrom(agent,from,list[id-1].tokenId);
    list[id-1].status=1;
    emit BidToken(from,id,bid,_types);
  }
 
  function revocation(uint id,address _types) public {
    require(msg.sender==list[id-1].owner&&list[id-1].status==0,"The current user has no permissions");
    IRbtDeposit721(_types).safeTransferFrom(agent,msg.sender, list[id-1].tokenId);
    delete list[id-1];
    emit Revocation(id,_types);
  }
  
}