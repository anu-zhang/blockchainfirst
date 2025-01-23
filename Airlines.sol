pragma solidity ^0.6.0;

contract Airlines {
    address public chairperson;

    struct details{
        uint escrow;//
        uint status;
        uint hashOfDetails;
    }

    mapping (address => details) public balanceDetails;//航空公司账号支付详情
    mapping (address => uint) public membership; //航空公司会员映射

    //modifiers or rules
    modifier chairPersonOnly() {
        require(msg.sender == chairperson);
        _;
    }

    modifier onlyMembership(){
        require(membership[msg.sender]==1);
        _;
    }
    constructor () public payable {
        chairperson = msg.sender;//  chairPerson is the address of the contract
       membership[msg.sender]=1;       //自动注册
        balanceDetails[msg.sender].escrow = msg.value; //初始化空余额为零
        

    }

    function register() public payable{
    //    address AirlineA = msg.sender;
    //    membership[AirlineA] = 1;
    //    balanceDetails[msg.sender].escrow = msg.value;
        
    } 
    

    function unregister(address payable AirlineZ) chairPersonOnly public {
        if(chairperson!=msg.sender) {
            revert();
        }
        membership[AirlineZ] = 0;
        AirlineZ.transfer(balanceDetails[AirlineZ].escrow);
        balanceDetails[AirlineZ].escrow=0;
    }

    function request(address toAirline,uint hashOfDetails) onlyMembership public {
        if(membership[toAirline] !=1){
            revert();
        }
        balanceDetails[msg.sender].status = 0;
         balanceDetails[msg.sender].hashOfDetails = hashOfDetails;// 
    }
    function respone(address fromAirline,uint hashOfDetails,uint done) onlyMembership public {
        if (membership[fromAirline] != 1){
            revert();
        }
        balanceDetails[msg.sender].status = done;
        balanceDetails[fromAirline].hashOfDetails = hashOfDetails;

    }

    //1 消息发送者，就是fromAirline
    //2 修改B航空公司的余额
    //3 修改A航空公司的余额
    //4 给B航空公司转钱
    function settlePayment(address payable toAirline) onlyMembership payable public {

        address fromAirline = msg.sender;
        uint amount = msg.value;
        balanceDetails[toAirline].escrow = balanceDetails[toAirline].escrow + amount;
        balanceDetails[fromAirline].escrow = balanceDetails[fromAirline].escrow - amount;
        toAirline.transfer(amount);
    }
    
}