// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.4.22 <0.8.8;
contract ballot 
{
    struct voter
    {
        uint weight;
        bool voted;
        address delegate;
        uint vote;
    }
    struct proposal {
        bytes32 name ;
        uint voteCount;
    }
    address public chairperson;
    mapping (address => voter) public voters;
    proposal[] public proposals;
    constructor(bytes32[] memory proposalNames) public {
        chairperson = msg.sender;
        voters[chairperson].weight = 1;
        for (uint i=0;i<proposalNames.length;i++)
        {
            proposals.push(proposal({
                name : proposalNames[i],
                voteCount : 0
            }));
        }
    }
    function giveRightVoter(address voter) public
    {
        require(msg.sender == chairperson);
        require(!voters[voter].voted,"only chairperson can give right to vote"); 
        require(voters[voter].weight == 0);
        voters[voter].weight = 1;  
    }
    function delegate(address _to) public 
    {
        voter storage sender = voters[msg.sender];
        require(!sender.voted,"you already voted");
        require(_to !=msg.sender,"self delegation is disallowed.");
        while(voters[_to].delegate != address(0))
        {
            _to = voters[_to].delegate;
            require (_to != msg.sender, "found loop in delegation");
        }
        sender.voted = true;
        sender.delegate = _to;
        voter storage delegate_ = voters[_to];
        if (delegate_.voted)
        {
            proposals[delegate_.vote].voteCount += sender.weight;
        }
        else
        { 
            delegate_.weight += sender.weight;
        }
    
    }
    
    function vote(uint proposal) public
    {
        voter storage sender = voters[msg.sender];
        require(sender.weight != 0,"Has no right to vote");
        require(!sender.voted,"Already voted");
        sender.voted = true;
        sender.vote = proposal;
        proposals[proposal].voteCount += sender.weight;
    }

    function winningProposal() public view returns (uint winningProposal_)
    {
        uint winningVoteCount = 0;
        for (uint p= 0 ; p < proposals.length ; p++)
        {
            if(proposals[p].voteCount > winningVoteCount){
                winningVoteCount = proposals[p].voteCount;
                winningProposal_ = p;
            }
        }
    }
    function winnerName() public view returns (bytes32 winnerName_)
    {
        winnerName_ = proposals[winningProposal()].name;
    }

}
