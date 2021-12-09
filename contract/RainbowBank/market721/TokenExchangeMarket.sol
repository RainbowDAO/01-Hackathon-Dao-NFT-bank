pragma solidity ^0.8.0;
import "../../lib/TransferHelper.sol";
import "../../interface/token721/IRbtDeposit721.sol";


contract TokenExchangeMarket{
    
  struct NFTRecording {
    address owner;//所有者地址
    uint tokenId;//令牌id
    uint  id;//交易市场上的序号
    uint price;//价格
    uint expireTime;//到期时间
    uint status;//状态  0未交易，1已交易
  }
  
  NFTRecording[] public list;
  
  address token;
  
  //第三方中介地址第三方中介地址
  address public agent;
  mapping (address=>uint)types;//address->types
  event SellToken(address from,uint tokenId,uint sellPrice,address _types);
  event BidToken(address  from,uint id, uint bid,address _types);
  event Revocation(uint indexed id,address indexed _types);
  //构造函数
  constructor(address user) public{}
    
  function init(address _agent,address _token) external {
    agent= _agent;
    token = _token;

    }
 
  //出售市场（设置令牌出售相关信息）
  function sellToken(address from,uint tokenId,uint sellPrice,address _types) public{
    //当前区块的时间，在unit32范围内
    uint32 blockTime = uint32(block.timestamp % 2 ** 32);
    //令牌有效期
    uint time=IRbtDeposit721(_types).expire(tokenId);
    //查看调用者是否是tokenid所有者以及令牌不能过期
    require(from == IRbtDeposit721(_types).ownerOf(tokenId) && time >= blockTime,'The address cannot be set');
    uint id=list.length+1;
    NFTRecording memory record = NFTRecording({
      owner:from,//出售者地址
      tokenId:tokenId,//出售令牌id
      id:id,//tokenId在数组中的位置
      price:sellPrice,//出售价格
      expireTime:time,//到期时间未交易是已交易啊
      status:0//未交易
    });
    list.push(record);
    //将令牌交给第三方中介
    IRbtDeposit721(_types).safeTransferFrom(from,agent, tokenId);
    emit SellToken(from,tokenId,sellPrice,_types);
  }

  //购买人出价  
  function bidToken(address from,uint id, uint bid,address _types) public {
    //保证出价和售价相等
    require(bid==list[id-1].price,'Can not buy');
    //将rbt转给商家
    TransferHelper.safeTransferFrom(token,from,list[id-1].owner, bid);
    //将令牌转移给购买人
    IRbtDeposit721(_types).safeTransferFrom(agent,from,list[id-1].tokenId);
    //更改凭证状态
    list[id-1].status=1;
    emit BidToken(from,id,bid,_types);
  }
 
  //撤销出售
  function revocation(uint id,address _types) public {
    require(msg.sender==list[id-1].owner&&list[id-1].status==0,"The current user has no permissions");
    //第三方中介归还将令牌归还贷款人
    IRbtDeposit721(_types).safeTransferFrom(agent,msg.sender, list[id-1].tokenId);
    //删除在list中的记录
    delete list[id-1];
    emit Revocation(id,_types);
  }
  
}