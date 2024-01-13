// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "openzeppelin-contracts/contracts/access/Ownable.sol";

/**
 * @title decentralisedVoting
 * @notice decentralised voting contract where specified user can vote to the specified candidates
 * @author Abhijay Paliwal
 */

contract decentralisedVoting is Ownable {
    receive() external payable {}

    struct voterInfo {
        address voterAddress;
        string name;
        uint128 age;
        uint128 gender;
        bool isVoted;
    }

    /**
     * @notice winner of the election. only used when admin declares result
     */
    address public winner;

    /**
     * @notice start timestamp of the election
     */
    uint256 public electionStart;

    /**
     * @notice end timestamp of the election
     */
    uint256 public electionEnd;

    /**
     * @notice number of candidates who stands in election
     */
    uint256 public candidateNum;

    /**
     * @notice mapping of addresses who are added by admin for voting
     * @dev checked when voting of candidates by the voters
     */
    mapping(address => bool) public isCandidateAdded;

    /**
     * @notice mapping of numbers associated with addresses of candidates
     * @dev used when winner is declared by admin
     */
    mapping(uint256 => address) public candidateNumMapping;

    /**
     * @notice mapping of addresses of candidates with their respective votes by voters
     * @notice the mapping is knowingly "NOT PUBLIC" as to not get real time votes during voting period
     * @dev used when winner is declared by admin
     */
    mapping(address => uint256) candidateVotes;

    /**
     * @notice mapping of voter addresses associated with their details (stored in struct)
     * @dev used when winner is declared by admin
     */
    mapping(address => voterInfo) public voterInfoMapping;

    /**
     * @dev contract constructor
     * @param _electionStart uint256 time to start election
     * @param _electionEnd uint256 time to end election
     */
    constructor(uint256 _electionStart, uint256 _electionEnd) Ownable(msg.sender) {
        electionStart = _electionStart;
        electionEnd = _electionEnd;
    }

    /**
     * @notice Emitted when admin adds candidate for election.
     * @param _candidateAddress address indexed Address of the candidate.
     */
    event candidateAddition(address indexed _candidateAddress);

    /**
     * @notice Emitted when admin adds voter and its detailsfor election.
     * @param _voter address indexed Address of the voter.
     * @param _voterName string name of the voter.
     * @param _voterAge uint256 age of the voter.
     * @param _voterGender uint8 gender of the voter.
     */
    event voterAddition(address indexed _voter, string _voterName, uint128 _voterAge, uint128 _voterGender);

    /**
     * @notice Emitted when voter votes to an candidate.
     * @param _candidate address indexed Address of the candidate.
     */
    event candidateVoting(address indexed _candidate);

    /**
     * @notice function to add candidate of election by owner.
     * @dev can only be called by owner.
     * @param _candidateAddr address address of candidate.
     */
    function addCandidate(address _candidateAddr) external onlyOwner {
        require(isCandidateAdded[_candidateAddr] == false, "candidate is already added");
        candidateNum++;
        candidateNumMapping[candidateNum] = _candidateAddr;
        isCandidateAdded[_candidateAddr] = true;
        emit candidateAddition(_candidateAddr);
    }

    /**
     * @notice function to add voter of election by owner.
     * @dev can only be called by owner.
     * @param _voterAddress address address of the voter to be added
     * @param _name string memory name of the candidate.
     * @param _age uint256 age of the candidate.
     * @param _gender uint8 gender of the voter.
     */
    function addVoter(address _voterAddress, string memory _name, uint128 _age, uint128 _gender) external onlyOwner {
        require(voterInfoMapping[_voterAddress].voterAddress == address(0), "voter is already added");
        voterInfo memory voterDetails;
        voterDetails.name = _name;
        voterDetails.age = _age;
        voterDetails.gender = _gender;
        voterDetails.voterAddress = _voterAddress;
        voterDetails.isVoted = false;
        voterInfoMapping[_voterAddress] = voterDetails;
        emit voterAddition(_voterAddress, _name, _age, _gender);
    }

    /**
     * @notice function to vote for candidate by the voter
     * @dev voting can only be done between specified start an end times
     * @param _candidate address of candidate to vote
     */
    function voteForCandidate(address _candidate) external {
        require(
            electionStart < block.timestamp && electionEnd > block.timestamp,
            "election time is either not started or ended"
        );
        require(voterInfoMapping[msg.sender].isVoted == false, "already voted");
        require(voterInfoMapping[msg.sender].voterAddress != address(0), "voter is not added by admin");
        require(isCandidateAdded[_candidate] == true, "Candidate is not added by admin");
        voterInfoMapping[msg.sender].isVoted = true;
        candidateVotes[_candidate] += 1;
        emit candidateVoting(_candidate);
    }

    /**
     * @notice function to declare election winner
     * @dev can only be called after election is over and by admin
     */

    function declareWinner() external onlyOwner returns (address, uint256) {
        require(electionEnd < block.timestamp, "election is not ended yet");
        address tempWinner;
        uint256 tempVotes;
        for (uint256 i = 1; i <= candidateNum; i++) {
            uint256 votes = candidateVotes[candidateNumMapping[i]];
            if (votes > tempVotes) {
                tempWinner = candidateNumMapping[i];
                tempVotes = votes;
            }
        }
        winner = tempWinner;
        return (tempWinner, tempVotes);
    }
}
