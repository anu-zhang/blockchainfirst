pragma solidity ^0.6.0;

//角色
//主席，选民，任何人

contract BallotV2 {
    address public chairperson;//默认storage

    struct  Voter  {//默认memory
        uint  weight;
        bool  voted;
        uint note;
    }
    mapping  (address => Voter) public voters;

    struct Proposal {
        uint voteCount;
    }

    Proposal[] public proposals;

    enum  Phase {Init,Regs,Vote,Done}

    Phase public state = Phase.Init;

    //构造函数让合约部署者为主席
    //提案数量是构造函数的参数
    constructor(uint proposalsNum) public {
        chairperson = msg.sender;
        voters[chairperson].weight = 2;
        for(uint prop = 0; prop < proposalsNum; prop ++){
            proposals.push(Proposal(prop));
        }
    }
     //状态改变函数
    //只有主席可以改变状态，否则回复原状，而且状态必须按照0，1，2，3顺序进行
    function changeStates(Phase changestate)public{
        if (msg.sender != chairperson){
            revert("只有主席才可以改变投票状态");
        }
        if(  changestate <= state){
               revert("只能设置下一个状态");
        }
        if(state == Phase.Done){
            revert("投票已结束");
        }
         state = changestate;
    }
   

}