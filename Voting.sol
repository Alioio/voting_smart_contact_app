// SPDX-License-Identifier: MIT

// Specify the Solidity version to be used
pragma solidity ^0.8.17;


// Define the contract structure
contract Voting {
  // Define an array to store the names of the candidates
  string[] public candidates;

  // Define a mapping to store the number of votes for each candidate
  mapping(string => uint) public votes;

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

    // Increment the number of votes for the selected candidate
    votes[_candidate] += 1;
  }

  // Define a struct to store the voting results
  struct Result {
    string name;
    uint votes;
  }

  // Function to retrieve the voting results
  function results() public view returns (Result[] memory) {
    // Create an array to store the voting results
    Result[] memory results = new Result[](candidates.length);

    // Store the candidate names and vote counts in the array
    for (uint i = 0; i < candidates.length; i++) {
      results[i].name = candidates[i];
      results[i].votes = votes[candidates[i]];
    }

    // Return the array
    return results;
  }
}