// SPDX-License-Identifier: MIT

// Specify the Solidity version to be used
pragma solidity ^0.8.17;


// Define the contract structure
contract Poll {
  // Define an array to store the names of the candidates
  string[] private candidates;

  // Define a mapping to store the number of votes for each candidate
  Vote[] private votes;

  // Define the constructor function to initialize the contract
  constructor() public {
    // Add initial candidates
    //candidates.push("Candidate 1");
    //candidates.push("Candidate 2");
  }

  // Function to add a new candidate
  function addCandidate(string memory _candidate) public {
    // Add the new candidate to the candidates array
    candidates.push(_candidate);
  }

  // Function to cast a vote for a candidate
  function vote(string memory _candidate) public {

    //TODO Check if the voting period has expired!

    //TODO Check if the voter has already cast a vote
    for(uint i = 0; i < votes.length; i++) {
      if(votes[i].voter == msg.sender) { 
        return;
      } 
    }

    // Enter the vote for the senders address
    if(candidateExists(_candidate)) {
      votes.push(Vote(msg.sender, _candidate));
    }
  }

  function candidateExists(string memory _candidate) private returns(bool) {
    for(uint i = 0; i < candidates.length; i++) {
      if(compareStrings(candidates[i],_candidate)) { 
        return true; 
      }
    }
    return false;
  }

  struct Vote {
    address voter;
    string candidate;
  }

  // Define a struct to store the voting results
  struct Result {
    string name;
    uint votes;
  }

  // Function to retrieve the voting results
  function results() public returns (Result[] memory) {
    // Create an array to store the voting results
    Result[] memory results = new Result[](candidates.length);
    for (uint i = 0; i < results.length; i++) {
      results[i] = Result(candidates[i], 0);
    }

    for (uint i = 0; i < votes.length; i++) {
      for (uint j = 0; j < results.length; j++) {
        if(compareStrings(results[j].name, votes[i].candidate)) {
          results[j].votes += 1;
          break;
        }
      }
    }

    // Return the array
    return results;
  }

  function compareStrings(string memory a, string memory b) private returns (bool) {
    return (keccak256(abi.encodePacked((a))) == keccak256(abi.encodePacked((b))));
  }
}

