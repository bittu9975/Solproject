async function main() {
    const [deployer] = await ethers.getSigners();
    console.log("Deploying contracts with the account:", deployer.address);
  
    const ReverseAuction = await ethers.getContractFactory("ReverseAuction");
    const auction = await ReverseAuction.deploy(3, ethers.utils.parseEther("2"));
    console.log("ReverseAuction deployed to:", auction.address);
  }
  
  main()
    .then(() => process.exit(0))
    .catch((error) => {
      console.error(error);
      process.exit(1);
    });
  