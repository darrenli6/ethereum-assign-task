pragma solidity ^0.6.0;

import "./IUSER.sol";


import "./strings.sol";
contract User is IUSER{

    mapping(string=>string) _users;

    address admin;


    using strings for string ;


    constructor () public {
        admin = msg.sender;
    }

    // 注册接口
    function register(string calldata username,string calldata passwd) override external{
       // 检测 用户没有注册过,用户名不能为空,密码不能为空
       require(!username.isEqual(""),"username is not null");
       require(!passwd.isEqual(""),"password is not null");
       require(_users[username].isEqual(""),"user must   no exists ");
       _users[username]=passwd;

    }

    // 登录接口
    function login(string calldata username,string calldata passwd) override external view returns (bool){

    //   require(!username.isEqual(""),"username is not null");
    //    require(!passwd.isEqual(""),"password is not null");
      if(username.isEqual("") || passwd.isEqual("")){
          return false;
      }
       return _users[username].isEqual(passwd);
    }
}