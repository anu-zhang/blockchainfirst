pragma solidity ^0.6.0;

//角色
//主席，选民，任何人

contract BallotV3 {
    address public chairperson;//默认storage

    struct  Voter  {//默认memory
        uint  weight;
        bool  voted;
        uint vote;
    }
    mapping  (address => Voter) public voters;

    struct Proposal {//每个选项的投票票数
        uint voteCount;
    }

    Proposal[] public proposals;//投票的选项

    enum  Phase {Init,Regs,Vote,Done}

    Phase public state = Phase.Init;

    //构造函数让合约部署者为主席
    //提案数量是构造函数的参数
    constructor(uint proposalsNum) public {
        chairperson = msg.sender;
        voters[chairperson].weight = 2;
        for(uint prop = 0; prop < proposalsNum; prop ++){
            proposals.push(Proposal(0));
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
   
   modifier validPhase(Phase reqPhase)
   {
        require(state == reqPhase,"投票阶段不对");
        _;
   }

    //主席将每个人，注册进入系统
    //验证投票阶段，只能在注册阶段调用
    function register(address voter)public validPhase(Phase.Regs){
        if(chairperson!=msg.sender||voters[voter].voted) revert("注册失败");
        voters[voter].weight = 1;//注册默认权重是2
        voters[voter].voted = false;

    }

    //每个人进行投票，投自己的权重，验证只能在投票阶段
    //普通人权重是1，并将权重增加到每个选项里面
    function vote(uint toPropost)public validPhase(Phase.Vote){
        Voter memory sender = voters[msg.sender];

        if(sender.voted || toPropost>proposals.length)revert("投票失败");

        voters[msg.sender].voted = true;
        voters[msg.sender].vote = toPropost;

        proposals[toPropost].voteCount += sender.weight;



    }
    //轮训所有选项
    //获得权重数，最高的选项和票数
    function reqWinnProp()public validPhase(Phase.Done) view returns (uint winningProposal,uint count){

        for(uint posal = 0;posal<proposals.length;posal++){
            if(proposals[posal].voteCount>count){
                winningProposal =posal;
                count = proposals[posal].voteCount;
            }
           
        }
    }
}