# Solproject
This project implements a Reverse Auction Smart Contract using Solidity and Hardhat. The contract allows multiple participants to submit bids, determines the winners based on the lowest bids, and distributes rewards to the winners.

Key Features

Auction creator sets:

  N: The number of winners.

  M: The maximum bid amount.

The creator locks an amount equal to N x M upon auction creation.

Participants can submit bids below the maximum bid amount.

The contract identifies the N lowest bids as winners.

Rewards:

  The highest bid among the winners is distributed equally to all winners.

  Remaining funds are returned to the auction creator.

Prerequisites

Node.js (v16 or higher)

npm (comes with Node.js)

Hardhat

Installation

Clone the Repository:
git clone https://github.com/bittu9975/Solproject
cd Solproject

Install Dependencies:
npm install

Compile the Smart Contract:
npx hardhat compile

Run Tests:
npx hardhat test

Deployment

Start a Local Blockchain:
Use Hardhat Network for local development:
npx hardhat node

Deploy the Contract:
Deploy the smart contract to the local blockchain:
npx hardhat run scripts/deploy.js --network localhost

Note the deployed contract address for further interactions.


Interaction with the Contract

Using Scripts

Create an Auction:
Run the script to create an auction:
npx hardhat run scripts/createAuction.js --network localhost
Example Input:

N: 3 (number of winners)

M: 1 ETH (maximum bid amount)

Place Bids:
Participants can place bids using:
npx hardhat run scripts/placeBid.js --network localhost
Example Input:

Bid amount: 0.8 ETH


Finalize Auction:
After the bidding period ends, finalize the auction to determine winners and distribute rewards:
npx hardhat run scripts/finalizeAuction.js --network localhost

Check Results:
Use a script or Hardhat console to query the winners and the rewards distributed.


Using Hardhat Console

You can interact with the deployed contract directly:
npx hardhat console --network localhost

Example commands:
const auction = await ethers.getContractAt("ReverseAuction", "<deployed_contract_address>");
await auction.getWinners();
await auction.getCreatorBalance();



Example Workflow

Auction Creator locks 3 ETH (N x M = 3 x 1 ETH).

Participants submit bids:

Bid 1: 0.9 ETH

Bid 2: 0.8 ETH

Bid 3: 0.7 ETH

Bid 4: 1.1 ETH (rejected, exceeds max bid M).

The N=3 lowest bids are selected as winners: 0.7 ETH, 0.8 ETH, 0.9 ETH.

Rewards distributed:

Each winner receives the highest winning bid (0.9 ETH).

Remaining funds (0.3 ETH) are returned to the auction creator.

