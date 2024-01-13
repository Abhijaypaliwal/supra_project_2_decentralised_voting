# README for decentralisedVoting Smart Contract

## 1. Solidity Code:

The provided Solidity code (`decentralisedVoting.sol`) implements a decentralized voting smart contract. This contract allows specified users to vote for candidates in an election. It includes functionalities for adding candidates and voters, as well as the ability to vote for candidates during a specified election period. The contract is owned by an administrator who can declare the winner after the election has ended.

## 2. Design Choices:

### 2.1 Candidate and Voter Structure:

- The use of a `struct` named `voterInfo` is chosen to store details about each voter. This structure includes fields such as voter's name, age, gender, and whether the voter has already voted.

### 2.2 Election Period:

- The contract includes a start and end timestamp for the election period. Voters can only cast their votes within this time frame, adding a time-bound aspect to the election.

### 2.3 Winner Declaration:

- The contract owner can declare the winner after the election ends. The winner is determined based on the candidate with the highest number of votes.

### 2.4 Event Emission:

- Events are emitted for crucial actions such as candidate addition, voter addition, and candidate voting. This allows external systems to listen for these events and respond accordingly.

## 3. Security Considerations:

### 3.1 Access Control:

- The contract uses the OpenZeppelin `Ownable` contract to ensure that only the contract owner (administrator) can add candidates, add voters, and declare the winner. This prevents unauthorized access to critical functionalities.

### 3.2 Voting Validation:

- The `voteForCandidate` function includes validations to ensure that voting can only occur during the specified election period, voters can only vote once, and voters can only vote for valid candidates.

### 3.3 Winner Declaration:

- The `declareWinner` function includes checks to ensure that the election has ended before declaring the winner. This prevents premature winner declaration and ensures a fair process.

### 3.4 Visibility of Candidate Votes:

- The mapping of candidate votes is intentionally not made public to prevent real-time access to voting results during the election. This design choice enhances the integrity of the voting process.

### 3.5 Timestamp Validation:

- The contract checks timestamps to ensure that actions are performed within the appropriate time frames. This guards against actions occurring before or after the specified election period.

# Test Script

The testing of contract is made via "Foundry" framework
The test smart contract is located in the ./test folder 

To launch the test script, if foundry is not installed in the system, install foundry by typing the command-
`curl -L https://foundry.paradigm.xyz | bash`

then, install openzeppelin dependencies by typing command-
`forge install OpenZeppelin/openzeppelin-contracts`

if there is problem "Openzeppelin-contracts" not found, type- 
`forge remappings > remappings.txt`
which creates a remappings.txt file inside the root directory of the project

Now to launch the script, simply type-
`forge test -vvv`
The above script would show the outputs and pass conditions of the test, if you want to see the transaction traces, simply add an extra "v" in the script at last.