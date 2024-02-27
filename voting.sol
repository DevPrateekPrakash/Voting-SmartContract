// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;
contract vote{
    address electiondirector;
    address public winnerCandidate;

    struct voter{
        string name;
        uint age;
        uint voterId;
        string gender;
        uint VoterCandidateId;
        address voterAddress;
    }

    struct candidate{
        string name;
        string party;
        uint age;
        string gender;
        uint candidateId;
        address candidiateAddress;
        uint votes;
    }

    uint nextVoterId=1;
    uint nextCandidateId= 1;

    uint startTime;
    uint endTime;

    mapping(uint => voter) voterDetail;
    mapping(uint => candidate) candidateDetail;
    bool stopVoting;

    constructor(){
        electiondirector=msg.sender;
    }

    modifier isVotingOver(){
        require(block.timestamp > endTime || stopVoting==false, "voting is not over");
        _;
    }
    modifier onlyDirector(){
        require(electiondirector==msg.sender, "voting is not over");
        _;
    }

    function candidateRegister(string calldata _name, string calldata _party, uint _age, string calldata _gender) external{
        require(msg.sender!=electiondirector,"you are election director");
        require(_age>18, "andidate must be over 18");
        require(candidateVerification(msg.sender),"candidates registered already");
        require(nextCandidateId<3,"candidates full");
        candidateDetail[nextCandidateId]=candidate(_name, _party, _age, _gender, nextCandidateId,msg.sender, 0);
        nextCandidateId++;
    }

    function candidateVerification(address _person) public view returns(bool){
        for(uint i=0;i<nextCandidateId;i++){
            if(candidateDetail[i].candidiateAddress==_person){
                return false;
            }
        }
        return true;
    }









}