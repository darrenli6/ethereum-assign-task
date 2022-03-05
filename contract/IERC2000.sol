pragma solidity^0.6.0;

//https://eips.ethereum.org/EIPS/eip-20

interface IERC2000 {

  // 总供应
   function totalSupply() external view returns (uint256);

   // 余额
   function transfer(string calldata from,string calldata _to, uint256   _value) external returns (bool success);
   
   // 转账

   function balanceOf(string calldata _owner) external view returns (uint256 balance);

   event Transfer(string indexed _from, string indexed _to, uint256 _value);

}