const { expect } = require("chai");

describe("ReverseAuction", function () {
  let ReverseAuction, reverseAuction, owner, addr1, addr2;

  beforeEach(async function () {
    ReverseAuction = await ethers.getContractFactory("ReverseAuction");
    [owner, addr1, addr2, _] = await ethers.getSigners();
    reverseAuction = await ReverseAuction.deploy(3, ethers.utils.parseEther("2"));
    await reverseAuction.deployed();
  });

  it("should allow users to place bids", async function () {
    await reverseAuction.connect(addr1).placeBid({ value: ethers.utils.parseEther("1") });
    await reverseAuction.connect(addr2).placeBid({ value: ethers.utils.parseEther("1.5") });
    
    const bidAddr1 = await reverseAuction.bids(addr1.address);
    const bidAddr2 = await reverseAuction.bids(addr2.address);
    
    expect(bidAddr1).to.equal(ethers.utils.parseEther("1"));
    expect(bidAddr2).to.equal(ethers.utils.parseEther("1.5"));
  });

  it("should determine the correct winners", async function () {
    await reverseAuction.connect(addr1).placeBid({ value: ethers.utils.parseEther("1") });
    await reverseAuction.connect(addr2).placeBid({ value: ethers.utils.parseEther("1.5") });
    await reverseAuction.connect(owner).placeBid({ value: ethers.utils.parseEther("0.5") });

    await network.provider.send("evm_increaseTime", [7 * 24 * 60 * 60]); // Simulate 1 week
    await network.provider.send("evm_mine");

    await expect(reverseAuction.connect(owner).endAuction())
      .to.emit(reverseAuction, "AuctionEnded")
      .withArgs([addr1.address, addr2.address], ethers.utils.parseEther("1.5"));
  });
});
