// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.4.22 <0.8.8;
contract lottery
{
    address public owner;
    address payable[] players;

constructor() {
    owner = msg.sender;

}
modifier onlyOwner()
{
    require(msg.sender == owner);
    _;
}

function enterGame() public payable
{
    require(msg.value >= 1 ether," not enough ether to enter the game");
    players.push(payable (msg.sender));
}

function randowNumberGenerator() public view returns(uint)
{
    uint randomNumber = uint(keccak256(abi.encodePacked(owner,block.timestamp)));
    return randomNumber;
}

function winner() public onlyOwner
{
    uint index = randowNumberGenerator() % players.length;
    players[index].transfer(address(this).balance);
   // return players[index];
    players = new address payable[](0);
}

function getBalance() public view returns(uint)
{
    return address(this).balance;
}

function getPlayer() public view returns(address payable[] memory )
{
    return players;
}

}
