pragma solidity ^0.8.0;

import "../interface/token721/IERC721Receiver.sol";
import "../lib/TokenSet.sol";

    contract RbtDeposit721 {
        using Set for Set.TokenIdSet;
        
        string public name = "RBD";
        string public symbol = "RBD";

        
        address manger;
        struct Deposit{
            address owner;
            uint tokenId;
            uint startTime;
            uint expireTime;
            uint amount;
    }
    
    constructor(address user) public {
        manger = user;

    }
    modifier onlyAdmin(){
        require(msg.sender == manger , "u are not manger");
        _;
    }
    modifier onlyBank {
        require(msg.sender==bank, "u are not bank");
        _;
    }
    
    event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
    
    event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
    
    event ApprovalForAll(address indexed owner, address indexed operator, bool approved);

    function init(address _bank) external  {
        bank =_bank;
    }


    address bank;
    uint Lengths;
    Deposit[] private list ;
    mapping(address=>Set.TokenIdSet) userToken ;
    mapping (uint256 => address) private _tokenApprovals;// tokenId----The authorized address
    //When reauthorizing, the mapping from the owner to the operator
    mapping (address => mapping (address => bool)) private _operatorApprovals;
   
    /*
    * Issue additional tokens, restricting only banks from issuing additional tokens (_isBank) to obtain credentials.
    */
    function mint(address to,  uint amounts, uint month) onlyBank external  returns(uint) {
        //The time of the current block, within the unit32 range
        uint32 blockTime = uint32(block.timestamp % 2 ** 32);
        //A new token is issued, and the address orders the number of cards to be plus 1
        uint256 tokenId = list.length+1;
        uint expireTime=blockTime +(month*2592000);
        Deposit memory record = Deposit({
            owner : to,
            tokenId : tokenId,
            startTime:blockTime,
            expireTime:expireTime,
            amount: amounts
        });
        list.push(record);
        Lengths=list.length;
        userToken[to].add(tokenId);
        return  tokenId;
    }

    function burn(uint256 tokenId) onlyBank external  virtual {
        address owner = ownerOf(tokenId);
        userToken[owner].remove(tokenId);
        delete list[tokenId-1];
        Lengths=list.length-1;
        emit Transfer(owner, address(0), tokenId);
    }
    
    function ownerOf(uint256 _tokenId) public view  returns (address owner){
        owner=list[_tokenId-1].owner;
    }
    function totalSupply() public view returns (uint256 totalSupply){
        totalSupply=Lengths;
    }

    function balanceOf(address _owner) public view  returns (uint balance){
        balance=userToken[_owner].length();
    }

    function amount(uint256 tokenId) public view  returns(uint){
        return  list[tokenId-1].amount;
    }
    
    function expire(uint256 tokenId) public view  returns(uint){
        return  list[tokenId-1].expireTime;
    }
    
    function _exists(uint256 tokenId) public view  returns (bool) {
        return list[tokenId].owner != address(0);
    }
     function tokenOfOwnerByIndex(address owner, uint256 index) public view  returns (uint256) {
        return userToken[owner].at(index);
    }
    function tokenMetadata(uint _tokenId) public view  returns (Deposit memory ) {
        return list[_tokenId-1];
    }

    function transfer(address _from, address _to, uint256 _tokenId) public  {
        require(ownerOf(_tokenId) == _from, "ERC721: transfer of token that is not own");
        require(_to != address(0), "ERC721: transfer to the zero address");
        userToken[_from].remove(_tokenId);
        userToken[_to].add(_tokenId);
        list[_tokenId-1].owner=_to;
        emit Transfer(_from, _to, _tokenId);
    }
    
    function approve(address _to, uint256 _tokenId)public  {
        require(msg.sender == list[_tokenId].owner);
        require(msg.sender != _to);//授权的目标不是自己
        _tokenApprovals[_tokenId] = _to;
        emit Approval(list[_tokenId].owner, _to, _tokenId);
    }
    
    function _isApprovedOrOwner(address spender, uint256 tokenId) internal view returns (bool) {
        require(_exists(tokenId), "ERC721: operator query for nonexistent token");
        address owner = ownerOf(tokenId);
        return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
    }
    
    function getApproved(uint256 tokenId) public view  returns (address) {
        require(_exists(tokenId), "ERC721: approved query for nonexistent token");
        return _tokenApprovals[tokenId];
    }
    
    function setApprovalForAll(address operator, bool approved) public  virtual  {
        require(operator != msg.sender, "ERC721: approve to caller");
        _operatorApprovals[msg.sender][operator] = approved;
        emit ApprovalForAll(msg.sender, operator, approved);
    }
    
    function isApprovedForAll(address owner, address operator) public view  returns (bool) {
        return _operatorApprovals[owner][operator];
    }
    
     function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory _data) public  virtual   {
        transfer(from, to, tokenId);
        require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
    }
    
    function safeTransferFrom(address from, address to, uint256 tokenId) public  virtual  {
        safeTransferFrom(from, to, tokenId, "");
    }
    
     function _checkOnERC721Received(address from, address to, uint256 tokenId, bytes memory _data)
        private returns (bool)
    {
        if (isContract(to)) {
            try IERC721Receiver(to).onERC721Received(msg.sender, from, tokenId, _data) returns (bytes4 retval) {
                return retval == IERC721Receiver(to).onERC721Received.selector;
            } catch (bytes memory reason) {
                if (reason.length == 0) {
                    revert("ERC721: transfer to non ERC721Receiver implementer");
                } else {
                    assembly {
                        revert(add(32, reason), mload(reason))
                    }
                }
            }
        } 
         return true;
    }

    function isContract(address account) internal view returns (bool) {
        uint256 size;
        assembly { size := extcodesize(account) }
        return size > 0;
    }
}