// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.0;

contract Voting {
    address public chef; 
    // Mappings
    mapping(address => RoomMate) public mappingToRoomMates;
    mapping(uint => FoodOption) public foods;
    // Structs
    struct FoodOption { //Food
        string foodName;
        int8 voteCount;
    }
    struct RoomMate {   //Voter
        string votersName;
        bool voted; 
    }

    string[] default_food = ["Pizza","Burger", "Salad"];
    uint amountFoods;

    address[] public rmAddr;
 
    constructor () { 
        chef = (msg.sender);                       //whoever deploys the smart contract, is the chef
        addDefault();
    }


    function addDefault() public {
        require(msg.sender == chef, "Only Chef can add defaults!");

        for (uint i = 0; i< default_food.length;i++){    //fill foods with default food options
           foods[i] = FoodOption(default_food[i],0);
           amountFoods++;
       }
    }
    function addFood(string memory _foodName) public{   //add more food options
        require(msg.sender == chef, "Only Chef can add food!");
        uint j = amountFoods+1;
        foods[j] = FoodOption(_foodName,0);
    }
    //error?
    // function foodListing() public returns (string[] memory foodList){
    //     for (uint i=0; i< amountFoods;i++){
    //         foodList[i] = foods[i].foodName;
    //     }
    // }
    function checkVotedFood (string memory _foodName) internal returns(bool){
        for (uint i=0; i<amountFoods;i++){
            if(keccak256(abi.encodePacked(_foodName)) == keccak256(abi.encodePacked(foods[i].foodName))){
                return true;
            }
        }
        return false;
    }
    function checkVote (string memory _votersName, address _voterAddr) internal returns (bool) {
        if (mappingToRoomMates[_voterAddr].voted == false){
            mappingToRoomMates[_voterAddr].voted = true;
            return true;
        }
        return false;
    }

    function vote(string memory _votersName,string memory _foodName) public{
        address _voterAddr = msg.sender;
        require(checkVotedFood(_foodName), "Your choosen food is not available for voting! :(");
        require(checkVote(_votersName, _voterAddr), "You already voted! >:(");
        //Vote eligable 
        for (uint i=0; i<amountFoods;i++){  //increase votecount by 1
            if(keccak256(abi.encodePacked(_foodName)) == keccak256(abi.encodePacked(foods[i].foodName))){
                foods[i].voteCount++;
            }
        }
    }

//TODO: find more elegant solution for tie

    function result () public returns (string memory winner){
        string memory currentWinner = foods[0].foodName;
        int8 currentWinnerVotes = foods[0].voteCount;
        for (uint i=0; i<amountFoods;i++){  
            if(foods[i].voteCount> currentWinnerVotes){
                currentWinner = foods[i].foodName;
                currentWinnerVotes = foods[i].voteCount;
            }
            if(foods[i].voteCount == currentWinnerVotes){   // 
                return winner="There is a tie. Consult chef.";
            }
        }
        return winner;
    }
//TODO: End of voting
} // end of contract
