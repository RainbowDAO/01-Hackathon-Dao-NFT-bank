// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/utils/Address.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";



contract RBT is ERC20{
    using SafeMath for uint256;
    address public admin;
    address public feeto;
    uint public fee = 30;
    mapping(address => bool) public freeUsers;
    struct Checkpoint {
        uint32 fromBlock;
        uint96 votes;
    }
    //Store the block number and number of votes for an address in a change
    mapping (address => mapping (uint32 => Checkpoint)) public checkpoints;
    //Several changes have been made to store an address
    mapping (address => uint32) public numCheckpoints;
    event DelegateVotesChanged(address indexed delegate, uint previousBalance, uint newBalance);
    event AdminChange(address indexed Admin, address indexed newAdmin);
    event FeetoChange(address indexed feeto, address indexed newFeeto);
    event FreeUserChange(address indexed userAddress, bool indexed flag);
    constructor(address manager)  public ERC20("Rainbow Token","RBT"){
        admin = manager;
        feeto = manager;

        _mint(manager, 5000_000_000 * 10 ** 18);
        
        _addDelegates(manager, safe96(5000_000_000 * 10 ** 18,"RBT: vote amount underflows"));
        
    }
    
    modifier  _isOwner() {
        require(msg.sender == admin);
        _;
    }
    /**
    * @notice Set up a manager
    * @param manager intendant
    */
    function changeOwner(address manager) external _isOwner {
        admin = manager;
        emit AdminChange(msg.sender,manager);
    }
    /**
    * @notice Set the tax rate
    * @param value tax rate
    */
    function modifyFee(uint value) external _isOwner {
        fee = value;
    }
    /**
    * @notice Set up a tax collector
    * @param guager Tax collector
    */
    function changeFeeTo(address guager) external _isOwner {
        feeto = guager;
        emit FeetoChange(msg.sender,guager);
    }
    /**
    * @notice Add to the tax-exempt list
    * @param userAddress The address to add
    */
    function addFreeUser(address userAddress) public _isOwner {
        freeUsers[userAddress] = true;
        emit FreeUserChange(userAddress,true);
    }
    /**
    * @notice Remove from the tax-exempt list
    * @param userAddress The address to remove
    */
    function removeFreeUser(address userAddress) public _isOwner {
        freeUsers[userAddress] = false;
        emit FreeUserChange(userAddress,false);
    }
    
    /**
    * @notice burn
    * @param account Burning account
    * @param amount The amount of fuel consumption
    */
    function burn(address account, uint256 amount) external _isOwner{
        _burn(account, amount);
    }
    /**
    * @notice Transfer
    * @param recipient Accepted person
    * @param amount The amount of the transfer
    */
    function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
       
       
        _transferRBT(msg.sender,recipient,amount);
        return true;
        
    }
    
    
    /**
    * @notice Authorize transfers
    * @param sender The sender
    * @param recipient
    * @param amount
    */
    function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
        
        _transferRBT(sender,recipient,amount);
        uint256 currentAllowance = allowance(sender,_msgSender());
        require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
        _approve(sender, _msgSender(), currentAllowance-amount);
        return true;
    }
    /**
    * @notice Get the current number of votes
    * @param account To check the gorgeous address
    */
    function getCurrentVotes(address account) external view returns (uint96) {
        uint32 nCheckpoints = numCheckpoints[account];
        return nCheckpoints > 0 ? checkpoints[account][nCheckpoints - 1].votes : 0;
    }
    /**
    * @notice Get a block vote
    * @param account To check the gorgeous address
    * @param blockNumber To check the gorgeous blocks
    */
    function getPriorVotes(address account, uint blockNumber) public view returns (uint96) {
         require(blockNumber <= block.number, "RBT: not yet determined");
    
         uint32 nCheckpoints = numCheckpoints[account];
         if (nCheckpoints == 0 || checkpoints[account][0].fromBlock > blockNumber) {
             return 0;
         }
         
         if (checkpoints[account][nCheckpoints - 1].fromBlock <= blockNumber) {
             return checkpoints[account][nCheckpoints - 1].votes;
         }
    
         uint32 lower = 0;
         uint32 upper = nCheckpoints - 1;
         while (upper > lower) {
             uint32 center = upper - (upper - lower) / 2; 
             Checkpoint memory cp = checkpoints[account][center];
             if (cp.fromBlock == blockNumber) {
                 return cp.votes;
             } else if (cp.fromBlock < blockNumber) {
                 lower = center;
             } else {
                 upper = center - 1;
             }
        }
        return checkpoints[account][lower].votes;
     }
     /**
    * @notice Transfer
    * @param sender
    * @param recipient
    * @param amount
    */
    function _transferRBT(address sender, address recipient, uint256 amount) internal {
          
        uint96 amount96 = safe96(amount,"vote: vote amount underflows");
         if (freeUsers[sender] == true) {
            _transfer(sender, recipient, amount);
            _addDelegates(recipient, amount96);
        } else {
            uint256 aa = 10000;
            uint256 amount1 = amount.mul(aa.sub(fee)).div(aa);
            _transfer(sender, recipient, amount1);
            uint256 amount2 = amount.mul(fee).div(aa);
            _transfer(sender, feeto, amount2);
            uint96 vote96 = safe96(amount1,"vote: vote amount underflows");
            uint96 fee96 = safe96(amount2,"vote: vote amount underflows");
            _addDelegates(recipient, vote96);
            _addDelegates(feeto, fee96);
            
            uint32 a = 11;

        }
        
        _devDelegates(sender, amount96);
    }
     /**
    * @notice Add votes
    * @param dstRep
    * @param amount
    */
    function _addDelegates(address dstRep, uint96 amount) internal {
          
        uint32 dstRepNum = numCheckpoints[dstRep];
        uint96 dstRepOld = dstRepNum > 0 ? checkpoints[dstRep][dstRepNum - 1].votes : 0;
        uint96 dstRepNew = add96(dstRepOld, amount, "RBT: vote amount overflows");
        _writeCheckpoint(dstRep, dstRepNum, dstRepOld, dstRepNew);
        
    }
    /**
    * @notice Reduce the number of votes
    * @param srcRep
    * @param amount
    */
    function _devDelegates(address srcRep,  uint96 amount) internal {
          
        uint32 srcRepNum = numCheckpoints[srcRep];
        uint96 srcRepOld = srcRepNum > 0 ? checkpoints[srcRep][srcRepNum - 1].votes : 0;
        uint96 srcRepNew = sub96(srcRepOld, amount, "RBT: vote amount underflows");
        _writeCheckpoint(srcRep, srcRepNum, srcRepOld, srcRepNew);
    }
    /**
    * @notice Change the number of votes
    * @param delegatee The address to change the number of votes
    * @param nCheckpoints The number of vote changes
    * @param oldVotes
    * @param newVotes
    */
    function _writeCheckpoint(address delegatee, uint32 nCheckpoints, uint96 oldVotes, uint96 newVotes) internal {
        uint32 blockNumber = safe32(block.number, "RBT: block number exceeds 32 bits");
    
        if (nCheckpoints > 0 && checkpoints[delegatee][nCheckpoints - 1].fromBlock == blockNumber) {
            checkpoints[delegatee][nCheckpoints - 1].votes = newVotes;
        } else {
            checkpoints[delegatee][nCheckpoints] = Checkpoint(blockNumber, newVotes);
            numCheckpoints[delegatee] = nCheckpoints + 1;
        }
    
        emit DelegateVotesChanged(delegatee, oldVotes, newVotes);
    }
    function safe32(uint n, string memory errorMessage) internal pure returns (uint32) {
        require(n < 2**32, errorMessage);
        return uint32(n);
    }
    
    function safe96(uint256 n, string memory errorMessage) internal pure returns (uint96) {
        require(n < 2**96, errorMessage);
        return uint96(n);
    }
    
    function add96(uint96 a, uint96 b, string memory errorMessage) internal pure returns (uint96) {
        uint96 c = a + b;
        require(c >= a, errorMessage);
        return c;
    }

    function sub96(uint96 a, uint96 b, string memory errorMessage) internal pure returns (uint96) {
        require(b <= a, errorMessage);
        return a - b;
    }
}
