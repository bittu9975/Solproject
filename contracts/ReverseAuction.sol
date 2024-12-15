// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract ReverseAuction {
    address public auctionCreator;
    uint public maxBidAmount;
    uint public numWinners;
    uint public auctionEndTime;
    mapping(address => uint) public bids;
    address[] public bidders;

    event BidPlaced(address indexed bidder, uint amount);
    event AuctionEnded(address[] winners, uint reward);

    constructor(uint _numWinners, uint _maxBidAmount) {
        auctionCreator = msg.sender;
        numWinners = _numWinners;
        maxBidAmount = _maxBidAmount;
        auctionEndTime = block.timestamp + 7 days; // 1-week auction duration
    }

    modifier onlyCreator() {
        require(msg.sender == auctionCreator, "Only creator can perform this action.");
        _;
    }

    modifier auctionActive() {
        require(block.timestamp < auctionEndTime, "Auction has ended.");
        _;
    }

    modifier auctionEnded() {
        require(block.timestamp >= auctionEndTime, "Auction is still active.");
        _;
    }

    function placeBid() external payable auctionActive {
        require(msg.value > 0 && msg.value <= maxBidAmount, "Invalid bid amount.");
        bids[msg.sender] = msg.value;
        bidders.push(msg.sender);
        emit BidPlaced(msg.sender, msg.value);
    }

    function endAuction() external onlyCreator auctionEnded {
        uint[] memory sortedBids = sortBids();
        address[] memory winners = new address[](numWinners);

        uint totalReward = sortedBids[numWinners - 1];

        for (uint i = 0; i < numWinners; i++) {
            winners[i] = bidders[i];
            payable(winners[i]).transfer(totalReward);
        }

        uint remainingFunds = address(this).balance - (totalReward * numWinners);
        payable(auctionCreator).transfer(remainingFunds);

        emit AuctionEnded(winners, totalReward);
    }

    function sortBids() internal view returns (uint[] memory) {
        uint[] memory bidAmounts = new uint[](bidders.length);
        for (uint i = 0; i < bidders.length; i++) {
            bidAmounts[i] = bids[bidders[i]];
        }

        // Sort the bid amounts (simple bubble sort for demonstration, use a better sorting algorithm for production)
        for (uint i = 0; i < bidAmounts.length; i++) {
            for (uint j = i + 1; j < bidAmounts.length; j++) {
                if (bidAmounts[i] > bidAmounts[j]) {
                    uint temp = bidAmounts[i];
                    bidAmounts[i] = bidAmounts[j];
                    bidAmounts[j] = temp;
                }
            }
        }

        return bidAmounts;
    }
}
