// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import {Test, console} from "forge-std/Test.sol";
import "../src/voting.sol";

contract votingTest is Test {
    decentralisedVoting decentoVote;

    function setUp() external {
        vm.prank(address(1));
        decentoVote = new decentralisedVoting(1704892329, 1804892329);
    }

    /**
     * @notice the flow of check is as follows-
     * 1. admin (address(1)) add 3 candidates- address(10), address(11), address(12).
     * 2. admin adds 10 voters with 4 details- voter's address, name, age and gender (0: male, 1: female).
     * 3. 10 voters vote to their choiced candidates.
     * 4. revert case is checked, voter who is not added by admin tries to vote.
     * 5. after voting time is elapsed, admin calls declareWinner() function to declare winner.
     * 6. the winner is declared.
     */

    function testVoting() external {
        vm.startPrank(address(1));
        decentoVote.addCandidate(address(10)); // 0x000000000000000000000000000000000000000A
        decentoVote.addCandidate(address(11)); // 0x000000000000000000000000000000000000000b
        decentoVote.addCandidate(address(12)); // 0x000000000000000000000000000000000000000C

        decentoVote.addVoter(address(100), "gaurav sharma", 32, 0);
        decentoVote.addVoter(address(101), "rahul kumar", 40, 0);
        decentoVote.addVoter(address(102), "garima verma", 29, 1);
        decentoVote.addVoter(address(103), "abhishek parmar", 27, 0);
        decentoVote.addVoter(address(104), "prithi k", 45, 1);
        decentoVote.addVoter(address(105), "srinivasana M.A.", 53, 0);
        decentoVote.addVoter(address(106), "jatin gulati", 22, 0);
        decentoVote.addVoter(address(107), "puja sharma", 25, 1);
        decentoVote.addVoter(address(108), "bharati verma", 42, 1);
        decentoVote.addVoter(address(109), "farhan qureshi", 37, 0);
        decentoVote.addVoter(address(110), "roshan chhabra", 21, 0);

        vm.stopPrank();
        vm.warp(1704892330);

        vm.prank(address(100)); // gaurav sharma would cast vote
        decentoVote.voteForCandidate(address(11));

        vm.prank(address(101)); // rahul kumar would cast vote
        decentoVote.voteForCandidate(address(11));

        vm.prank(address(102)); // garima verma would cast vote
        decentoVote.voteForCandidate(address(12));

        vm.prank(address(103)); // abhishek parmar would cast vote
        decentoVote.voteForCandidate(address(10));

        vm.prank(address(104)); // prithi k would cast vote
        decentoVote.voteForCandidate(address(11));

        vm.prank(address(105)); // srinivasana M.A. would cast vote
        decentoVote.voteForCandidate(address(11));

        vm.prank(address(106)); //jatin gulati would cast vote
        decentoVote.voteForCandidate(address(12));

        vm.prank(address(107)); // puja sharma would cast vote
        decentoVote.voteForCandidate(address(11));

        vm.prank(address(108)); // bharati verma would cast vote
        decentoVote.voteForCandidate(address(11));

        vm.prank(address(109)); // farhan qureshi would cast vote
        decentoVote.voteForCandidate(address(10));

        vm.prank(address(110)); // roshan chhabra would cast vote
        decentoVote.voteForCandidate(address(11));

        // Declaration of winner by admin (address(1))
        vm.warp(1804892330); // time after voting period is ended
        vm.prank(address(1));
        (address winner, uint256 votes) = decentoVote.declareWinner();
        console.log("<----- winner of the election is ----->", winner);
        console.log("<----- votes of the winner is ----->", votes);
    }

    function testUnsuccessfulVoting() external {
        vm.startPrank(address(1));
        decentoVote.addCandidate(address(10)); // 0x000000000000000000000000000000000000000A

        decentoVote.addVoter(address(100), "gaurav sharma", 32, 0);
        decentoVote.addVoter(address(101), "rahul kumar", 40, 0);

         // **TEST 1** trying to add voter who is already added
        vm.expectRevert(bytes("voter is already added"));
        decentoVote.addVoter(address(101), "rahul kumar", 40, 0);

        vm.stopPrank();
        vm.warp(1704892330);

        vm.prank(address(100)); // gaurav sharma would cast vote
        decentoVote.voteForCandidate(address(10));

         // **TEST 2** trying to vote by person who is not added by admin
        vm.expectRevert(bytes("voter is not added by admin"));
        vm.prank(address(111)); 
        decentoVote.voteForCandidate(address(10));

         // **TEST 3** trying to vote 2 times
        vm.expectRevert(bytes("already voted"));
        vm.prank(address(100)); 
        decentoVote.voteForCandidate(address(10));

        // **TEST 4** trying to vote after election time is over 
        vm.warp(1804892331);
        vm.expectRevert(bytes("election time is either not started or ended"));
        vm.prank(address(101)); // rahul kumar would cast vote
        decentoVote.voteForCandidate(address(10));

        // **TEST 5** trying to vote before election time is over 
        vm.warp(1704892310);
        vm.expectRevert(bytes("election time is either not started or ended"));
        vm.prank(address(101)); // rahul kumar would cast vote
        decentoVote.voteForCandidate(address(10));
    }
}
