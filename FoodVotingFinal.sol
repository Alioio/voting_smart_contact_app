// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.0;
pragma abicoder v2;

contract Voting {
    address private chef; 
    // Mappings
    mapping(address => RoomMate) internal mappingToRoomMates;
    mapping(uint => FoodOption) internal foods;
    // Structs
    struct FoodOption { //Food
        string foodName;
        int8 voteCount;
    }
    struct RoomMate {   //Voter
        bool voted; 
    }
    bool internal stillGoing; //Vote 
    bool internal voteEnded;
    bool internal voteStarted;

    string[] default_food = ["Pizza","Burger", "Salad"];
    uint public amountFoods;
    string[] foodList;
    FoodOption[] internal tieList;
    uint internal tieFoods;
    string[] internal tiedFoods;
 
    constructor () { 
        chef = (msg.sender);                       //whoever deploys the smart contract, is the chef
    }
    function startVote() public{
        require(msg.sender == chef, "You can not start the vote!");
        stillGoing = true;
        voteStarted = true;
    }


    function addDefault() public {
        require(msg.sender == chef, "Only Chef can add defaults!");

        for (uint i = 0; i< default_food.length;i++){    //fill foods with default food options
           foods[i] = FoodOption(default_food[i],0);
           foodList.push(default_food[i]);
           amountFoods++;
       }
    }
    function addFood(string memory _foodName) public{   //add more food options
        require(msg.sender == chef, "Only Chef can add food!");
        require(voteStarted == false, "You can only add food before the voting process starts.");
        uint j = amountFoods;
        foods[j] = FoodOption(_foodName,0);
        amountFoods++;
        foodList.push(_foodName);
    }
    function foodListing() public view returns (string[] memory _foodList){ //shows list of available foods to vote for
        _foodList = foodList;
        return _foodList;
    }
    function checkVotedFood (string memory _foodName) internal returns (bool){   //does voted food exist as an option?
        for (uint i=0; i<amountFoods;i++){
            if(keccak256(abi.encodePacked(_foodName)) == keccak256(abi.encodePacked(foods[i].foodName))){
                return true;
            }
        }
        return false;
    }
    function checkVote (address _voterAddr) internal returns (bool) {   //already voted or not?
        if (mappingToRoomMates[_voterAddr].voted == false){
            mappingToRoomMates[_voterAddr].voted = true;
            return true;
        }
        return false;
    }

    function vote(string memory _foodName) public{          //voting function
        address _voterAddr = msg.sender;
        require(stillGoing == true, "Vote is already closed or not opened yet!");
        require(checkVotedFood(_foodName), "Your choosen food is not available for voting! :(");
        require(checkVote(_voterAddr), "You already voted! >:(");
        //Vote eligable 
        for (uint i=0; i<amountFoods;i++){  //increase votecount by 1
            if(keccak256(abi.encodePacked(_foodName)) == keccak256(abi.encodePacked(foods[i].foodName))){
                foods[i].voteCount++;
            }
        }
    }
    function tieHandler() internal{
        int8 biggestTieVoteNumber = tieList[0].voteCount;
        for (uint i = 1; i< tieFoods;i++){
            if(biggestTieVoteNumber < tieList[i].voteCount){
                biggestTieVoteNumber = tieList[i].voteCount;
            }
        }
        for(uint i = 0; i<tieFoods;i++){
            if(biggestTieVoteNumber == tieList[i].voteCount){
                tiedFoods.push(tieList[i].foodName);
            }
        }
    }
    // function tieListing() public view returns (FoodOption[] memory _tieList){ //shows list of tied foods
    //     require(msg.sender == chef, "Dinner will be a surprise!");
    //     _tieList = tieList;
    //     return _tieList;
    // }
function result () public returns (string memory winner){
        require(voteEnded == true, "Result will be revealed after the voting process ended.");
        string memory winnerText = "The winner is ";
        string memory currentWinner = foods[0].foodName;
        int8 currentWinnerVotes = foods[0].voteCount;
        for (uint i=1; i<amountFoods;i++){  
            if(foods[i].voteCount> currentWinnerVotes){
                currentWinner = foods[i].foodName;
                currentWinnerVotes = foods[i].voteCount;
            }
            if(foods[i].voteCount==currentWinnerVotes){
                tieList.push(foods[i]);
                tieList.push(foods[i-1]);
                tieFoods++;
            }
        }
        if (tieFoods!=0){
            tieHandler();
            winner = "There is a tie! The chef will decide what food will be cooked tonight :)";
            return winner;
        }

        winner = string.concat(winnerText, currentWinner);
        return winner;
    }

    function endVote() public{
        require(msg.sender == chef, "You can NOT end the vote.");
        require(voteStarted == true, "You can't end the vote before it started.");
        require(stillGoing == true);

        stillGoing = false;
        voteEnded = true;
    }
} // end of contract
