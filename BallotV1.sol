pragma solidity ^0.6.0;

//角色
//主席，选民，任何人

contract BallotV1 {
    address public chairperson;

    struct  Voter  {
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

}