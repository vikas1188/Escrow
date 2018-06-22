pragma solidity 0.4.24;

import "./ERC20.sol";



contract Ownable {
  address public owner;

  event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);

  function Ownable() public {
    owner = msg.sender;
  }

  modifier onlyOwner() {
    require(msg.sender == owner);
    _;
  }

  function transferOwnership(address newOwner) onlyOwner public {
    require(newOwner != address(0));
    emit OwnershipTransferred(owner, newOwner);
    owner = newOwner;
  }
}


contract Escrow is Ownable {
    
    
    event TokensLocked(address indexed userAddress,uint256 value,uint256 timeStamp,string notes);
    
    event TokensUnlocked(address indexed userAddress,uint256 value,uint256 timeStamp,string notes);
    
    ERC20 tokenContract;
    
    
    function setTokenContractAddress(address _tokenContractAddress) onlyOwner public {
        
        tokenContract = ERC20(_tokenContractAddress);
    }
     
    
    
    //Here we will write the code to submit the tokens to the escrow contract.
    
    function lockTokens(uint256 _value,string _notes) public onlyOwner {
        
        require(_value <= tokenContract.allowance(msg.sender, address(this)));
        require(tokenContract.transferFrom(msg.sender, address(this), _value));
        
        emit TokensLocked(msg.sender,_value,now,_notes);
        
        
    }
    
       function unlockTokens(uint256 _value,string _notes) public onlyOwner {
        
        require(_value<=tokenContract.balanceOf(owner));
        
        tokenContract.transfer(owner,_value);
        
        emit TokensUnlocked(msg.sender,_value,now,_notes);
        
        
    }
 
