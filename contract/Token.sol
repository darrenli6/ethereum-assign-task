pragma solidity^0.6.0;

//https://eips.ethereum.org/EIPS/eip-20

import "./IERC2000.sol";
import "./strings.sol";
import "./SafeMath.sol";

 contract  Token is IERC2000 {

   uint256 _totalSuply;  
   address admin;

   using strings for string;
   using SafeMath for uint256;


   mapping(string => uint256) _balances;

   constructor() public {
       _totalSuply=0;
       admin= msg.sender;
   }

  // 总供应
   function totalSupply() override external view returns (uint256){
       return _totalSuply;
   }

   // 余额
   function transfer(string calldata _from , string calldata _to, uint256  _value) override external returns (bool success){
       require(!_to.isEqual(""),"must exists");
       require(_value>0,"value >0");
       require(_balances[_from]>=_value,"balance must enough");
       _balances[_from]=_balances[_from].sub(_value);
       _balances[_to]=_balances[_to].add(_value);
     
       emit Transfer(_from,_to,_value);
    
  
   }

   //挖矿
   function mint(string calldata _to,uint256 _value) external{
       require(admin==msg.sender,"admin == msg.send ");
       require(!_to.isEqual(""),"must exists");
       require(_value>0,"value >0");
       _totalSuply=_totalSuply.add(_value);
         _balances[_to]=_balances[_to].add(_value);
        emit Transfer("system",_to,_value);
   }
   
   // 转账

   function balanceOf(string calldata _owner) override external view returns (uint256 balance){

    return _balances[_owner];
   }

   event Transfer(string indexed _from, string indexed _to, uint256 _value);

}