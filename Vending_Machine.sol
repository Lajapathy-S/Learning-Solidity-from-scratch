// SPDX-License-Identifier: GPL-3.
pragma solidity >=0.4.22 <0.8.8;
contract vending_machine
{
    address public owner ;
    mapping (address => uint) public balances;

constructor()
 {
    owner = msg.sender;
    balances[address(this)] = 100;
}

function getVendingMachineBalance() public view returns (uint)
{
    return balances[address(this)];
}

function restock(uint amount) public {
    require(msg.sender == owner, "only owner can do the restock");
    balances[address(this)] +=amount;
}

function purchase(uint amount) public payable {
    require(balances[address(this)] >= amount);
    require(msg.value >= amount * 2 ether," min you need 2 ether for purchasing a donut" );
    balances[address(this)] -=amount;
    balances[msg.sender]  += amount;
}
}
