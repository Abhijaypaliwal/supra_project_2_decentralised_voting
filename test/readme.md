
## Test Cases:

### 1. Successful Voting Flow:

- **Description:** The test simulates a complete voting flow, including the addition of candidates and voters, casting votes by voters, and declaring the winner by the admin.

- **Steps:**
  1. Admin (address(1)) adds 3 candidates.
  2. Admin adds 10 voters with their details.
  3. 10 voters cast votes for their chosen candidates.
  4. After the voting period ends, the admin declares the winner.

- **Expected Outcome:** The winner is correctly declared based on the highest number of votes received by a candidate.

### 2. Unsuccessful Voting Scenarios:

- **Description:** This set of test cases covers various scenarios where voting should fail, including attempts to add duplicate voters, voting by non-added voters, voting more than once, and voting outside the specified election period.

- **Steps:**
  1. Attempt to add a voter who is already added.
  2. Attempt to vote by a person who is not added by the admin.
  3. Attempt to vote twice by the same voter.
  4. Attempt to vote after the election time is over.
  5. Attempt to vote before the election time starts.

- **Expected Outcome:** Each of these scenarios should result in the expected revert messages, ensuring that the contract handles these situations appropriately.

## Note:

These test cases are designed to cover a wide range of scenarios and ensure the robustness of the `decentralisedVoting` smart contract. Reviewers can use these test cases to validate the correct implementation and behavior of the contract under different conditions.