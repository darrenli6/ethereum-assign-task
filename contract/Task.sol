pragma solidity ^0.6.0;
pragma experimental ABIEncoderV2;
import "./Token.sol";

import "./User.sol";

import "./strings.sol";

struct TaskInfo{
    string issue;
    string worker;

    string desc;

    uint256 bonus;

    uint8 status; // 0 已经发布 1 已接受 2 已提交 3 已经确认

    uint256 timestamp;

    string comment ; //评论
}

contract Task{


     Token _token;

     User _user;

     address _admin;

     address _owner;

     TaskInfo[] _tasks;

     using strings for string;


     constructor(address owner) public {
        _admin=msg.sender ;

        _owner =owner ;

        _token =new Token();
        _user =new User();

     }
 // 总供应
   function totalSupply()  external view returns (uint256){
       return _token.totalSupply();
   }

      // 余额
   function transfer(string calldata _from , string calldata _to, uint256  _value)  external returns (bool success){
        _token.transfer(_from,_to,_value);
   }

   //挖矿
   function mint(string calldata _to,uint256 _value) external{
       require(_admin==msg.sender  || _owner == msg.sender ,"admin == msg.send ");
       _token.mint(_to,_value);
   }
   
   // 转账

   function balanceOf(string calldata _owner)  external view returns (uint256 balance){

      return _token.balanceOf(_owner);
   }


  // 注册接口
    function register(string calldata username,string calldata passwd)  external{
       
       _user.register(username,passwd);

    }

    // 登录接口
    function login(string calldata username,string calldata passwd)  external view returns (bool){

     
       return _user.login(username,passwd);
    }

    // 发布任务
    function issue(string calldata issue,string calldata passwd,string calldata desc,uint256 bonus) external{

              require(_user.login(issue,passwd),"issue must have his right");
              require(bonus >0,"bonus must >0");
              require(_token.balanceOf(issue) >= bonus , "issuer's balance must enough" );
              TaskInfo memory task = TaskInfo(issue,"",desc,bonus,0,now,"");
              _tasks.push(task);
 

    }

    // 接受任务

    function take(string calldata worker,string calldata passwd,uint256 taskId) external {
       require(_user.login(worker,passwd),"work must have his right");
       require(_tasks[taskId].timestamp > 0,"task must exists");

       require(_tasks[taskId].status == 0 ,"task's status must =0");

       _tasks[taskId].worker =worker;
       _tasks[taskId].status=1;


    }

    // 提交任务

    function commit(string calldata worker,string calldata passwd,uint256 taskId) external {
       require(_user.login(worker,passwd),"work must have his right");
       require(_tasks[taskId].timestamp > 0,"task must exists");

       require(_tasks[taskId].status == 1 ,"task's status must =0");
       require(worker.isEqual(_tasks[taskId].worker),"task's work必须同一个人");

       _tasks[taskId].worker =worker;
       _tasks[taskId].status=2;  // 任务已经提交


    }

    // 确认任务
     function confirm(string calldata issue,string calldata passwd,uint256 taskId,string calldata comment ,uint8 status) external {
       require(_user.login(issue,passwd),"issue must have his right");
       require(_tasks[taskId].timestamp > 0,"task must exists");

       require(_tasks[taskId].status == 2 ,"task's status must =0");
       require(issue.isEqual(_tasks[taskId].issue),"task's issuer必须同一个人");

       require(status ==3 || status ==1 ,"status must in (1,3)");
   
     
       _tasks[taskId].status=status;

       if(status==3){
          _token.transfer(issue,_tasks[taskId].worker,_tasks[taskId].bonus);
       }
     }

       // 查询接口

       function qryOneTask(uint256 taskID) external view returns(string memory,string memory,uint256,string memory,uint8  ){
           
           return (_tasks[taskID].issue,_tasks[taskID].desc,_tasks[taskID].bonus,_tasks[taskID].worker,_tasks[taskID].status);
       }

       // 查询所有的任务
       function qryAllTasks() external view returns(TaskInfo[] memory){
          return _tasks;
       }


    }




