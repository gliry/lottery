// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity 0.8.13;

contract Lottery 
{
    address public owner;
    address payable public winner;
    uint public startTime;
    address[] public participants;

    constructor() 
    {
        owner = msg.sender; 
        startTime = block.timestamp;   
    }

    modifier checkOwner
    {
        require(msg.sender == owner, "You're not a owner!");
        _;                              
    } 

    modifier checkDate 
    {
        require(block.timestamp >= startTime + 1 * 30 days, "Month has not passed");
        _;    
    }

    function participate() public payable 
    {
        require(msg.value >= .1 ether, "Not enough ethereum");
        participants.push(msg.sender);
    }

    function randomNumber() public view returns (uint) 
    {
        return uint(keccak256(abi.encodePacked(owner, block.timestamp)));
    }

    function makeLottery() checkOwner public
    {
        uint index = randomNumber() % participants.length;
        winner = payable(participants[index]);
    }

    function checkWinner() checkDate public
    {
        require(msg.sender == winner, "Sorry, you're not a winner. Good luck next Time!");
        winner.transfer(address(this).balance);
    }
}
