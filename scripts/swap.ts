import { ethers } from "hardhat";

async function main() {
  const [account1, account2] = await ethers.getSigners();
  const TokenA = "0xcEA38fac44aeb835b6b8719dE84FB471471b264f";
  const TokenB = "0x06d1E46ca659936f8A85522D3bf7A72AAd8D187b";
  const addresses = [TokenA, TokenB];
  const swap = await ethers.deployContract("Swap", addresses);
  await swap.waitForDeployment();
  console.log(`deployed to ${swap.target}`);
  const swapTarget = swap.target;
  const interactWithswap = await ethers.getContractAt("Swap", swapTarget);
  const interactWithTokenA = await ethers.getContractAt("IERC20", TokenA);
  const interactWithTokenB = await ethers.getContractAt("IERC20", TokenB);

  await interactWithTokenA.transfer(account2, ethers.parseUnits("90000"));
  await interactWithTokenB.transfer(account2, ethers.parseUnits("80000"));

  // user1 approves swapping contract
  await interactWithTokenA
    .connect(account2)
    .approve(swapTarget, ethers.parseUnits("90000"));
  await interactWithTokenB
    .connect(account2)
    .approve(swapTarget, ethers.parseUnits("80000"));
  //user1 put in 3000 token1
  await interactWithswap
    .connect(account2)
    .addLiquidity(ethers.parseUnits("200"), ethers.parseUnits("500"));
  const balanceofUser1A = await interactWithTokenA.balanceOf(account2);
  const balanceofUser1B = await interactWithTokenB.balanceOf(account2);
  console.log(`balanceofUser1A :${balanceofUser1A}`);
  console.log(`balanceofUser1B :${balanceofUser1B}`);
  // await interactWithswap
  //   .connect(buyer)
  //   .userGetTokenAorB(ethers.parseUnits("0"), ethers.parseUnits("400"));
  await interactWithswap.connect(account2).swapAforB(ethers.parseUnits("50"));
  const balanceofUser1AfterSwap = await interactWithTokenA.balanceOf(account2);
  const balanceofUser1BAfterSwap = await interactWithTokenB.balanceOf(account2);
  console.log(`balanceofUser1A :${balanceofUser1AfterSwap}`);
  console.log(`balanceofUser1B :${balanceofUser1BAfterSwap}`);
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
