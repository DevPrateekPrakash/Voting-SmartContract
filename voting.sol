// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;
contract voting{
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
        for(uint i=0;i<=nextCandidateId;i++){
            if(candidateDetail[i].candidiateAddress==_person){
                return false;
            }
        }
        return true;
    }

    function candidateList() public view returns (candidate[] memory){
        candidate[]memory array= new candidate[](nextCandidateId-1);
        for(uint i=1;i<nextCandidateId;i++){
            array[i-1]=candidateDetail[i];
        }
        return array;
    }

    function voterRegistration(string calldata _name, string calldata _party, uint _age, string calldata _gender) external{
        require(_age>18, "andidate must be over 18");
        require(voterVerification(msg.sender),"candidates registered already");
        voterDetail[nextVoterId]= voter(_name, _age, nextVoterId,_gender,0, msg.sender);
        nextVoterId++;
    }
    function voterVerification(address _person) public view returns(bool){
        for(uint i=0;i<=nextVoterId;i++){
            if(voterDetail[i].voterAddress==_person){
                return false;
            }
        }
        return true;
    }

    function voterList() public view returns (voter[] memory){
        voter[]memory array= new voter[](nextVoterId-1);
        for(uint i=1;i<nextVoterId;i++){
            array[i-1]=voterDetail[i];
        }
        return array;
    }

    function vote(uint _voterId, uint _id) external{
        require(voterDetail[_voterId].VoterCandidateId==0, "you already voted, done");
        require(voterDetail[_voterId].voterAddress==msg.sender, "not your wallet");
        require(startTime!=0, "voting not started");
        require(nextCandidateId==3,"candiate has not registered");
        voterDetail[_voterId].VoterCandidateId= _id;
        candidateDetail[_id].votes++;
        
    }


}
