pragma solidity ^0.6.0;

contract AccountsDemo {

    address public whoDeposited;//存入账户
    uint public depositeAmount;//存入金额
    uint public accountBalance;//账户余额

    function deposit() public payable {///0x417Bf7C9dc415FEEb693B6FE313d1186C692600F
        whoDeposited = msg.sender;//存入账户
        depositeAmount = msg.value;//存入金额
        accountBalance = address(this).balance;//账户余额 

    }
}