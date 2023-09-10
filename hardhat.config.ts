import { HardhatUserConfig } from "hardhat/config";
import "@nomicfoundation/hardhat-toolbox";
import "dotenv/config";
require("dotenv").config();
// import "@nomicfoundation/hardhat-verify";

const config: HardhatUserConfig = {
  solidity: "0.8.19",
  networks: {
    goerli: {
      url: process.env.URL,
      //@ts-ignore
      accounts: [process.env.GOERLI_PRIVATE_KEY],
    },
  },
  etherscan: {
    // Your API key for Etherscan
    // Obtain one at https://etherscan.io/

    apiKey: process.env.YOUR_ETHERSCAN_API_KEY,
  },
};

export default config;
