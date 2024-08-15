// SPDX-License-Identifier: MIT
pragma solidity 0.8.17;

contract Election {
    //defining structure with mutliple candidate variables

    struct Candidate {
        bool supported;
        address id;
        uint256 voteCount;
        string candidateName;
    }

    event Registered(
        address candidateId,
        uint256 candidateNum,
        string candidateName
    );
    event Supported(address voter, address candidate);
    event Voted(address voter, address candidate);

    //Giving references using mapping
    mapping(address => bool) public voters;

    mapping(uint256 => Candidate) public candidates;

    address ecadmin;

    uint256 public candidatesCount;
    uint256 public startTime;
    uint256 public stopTime;

    constructor() {
        ecadmin = msg.sender;
    }

    function addCandidate(string memory _name) public payable {
        require(msg.value == 1 ether, "Appropraite ether not next");

        // is the candidate already registered.
        candidatesCount++;

        candidates[candidatesCount] = Candidate(false, msg.sender, 0, _name);

        emit Registered(msg.sender, candidatesCount, _name);
    }

    function supportCandidate(uint256 _candidateId) external {
        require(candidates[_candidateId].id != address(0x00), "Not registered");
        require(
            candidates[_candidateId].id != msg.sender,
            "Self Support not allowed"
        );
        require(
            candidates[_candidateId].supported == false,
            "Already supported"
        );
        candidates[_candidateId].supported = true;
        emit Supported(msg.sender, candidates[_candidateId].id);
    }

    modifier ecAdminOnly() {
        require(msg.sender == ecadmin, "EC admin only operation");
        _;
    }

    function setStop(uint256 num) external ecAdminOnly {
        require(num > block.timestamp && num > startTime, "Stop at later time");
        stopTime = num;
    }

    function setStart(uint256 num) external ecAdminOnly {
        require(num >= block.timestamp, "Start at earliler time");
        startTime = num;
    }
    
    function vote(uint _candidateld) public{
        require(block .timestamp > startTime, "Election not started" );
        require(block .timestamp <= stopTime, "Election over" );
        require(voters[msg.sender] == false, "Already voted");
        require(candidates[_candidateld].id != address(0x00), "Not registered condidate");
        require(candidates[_candidateld].supported == true, "Dont vote not supported" ) ;

        voters[msg. sender] == true;
        candidates[_candidateld].voteCount++ ;
        
        emit Voted(msg.sender, candidates[_candidateld].id);
    }

    function getResults() public  view returns (Candidate memory candidate) {
    require(block.timestamp >= stopTime, "Election yet to Finish");
    uint256 c;
    uint256 max=0;
    for (uint i=1; i<candidatesCount; i++){
        if(candidates[i].voteCount > max){
            max = candidates[i].voteCount ;
            c = i ;
         }
    }
         return candidates[c] ;
    
    }
}