pragma solidity^0.6.0;

interface IUSER {

  //注册
    function register(string calldata username,string calldata passwd) external;
// 登录
    function login(string calldata username,string calldata passwd) external view returns(bool);


}