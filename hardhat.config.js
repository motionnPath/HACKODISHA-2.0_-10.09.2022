require("@nomiclabs/hardhat-waffle")
require("hardhat-gas-reporter")
require("@nomiclabs/hardhat-etherscan")
require("dotenv").config()
require("solidity-coverage")
require("hardhat-deploy")


const API_URL = process.env.API_URL ||"";
const PRIVATE_KEY = process.env.PRIVATE_KEY || "";


/** @type import('hardhat/config').HardhatUserConfig */
module.exports = {
  solidity: "0.8.9",
  defaultNetwork: "hardhat",
    networks: {
        hardhat: {
            chainId: 31337,
            // gasPrice: 130000000000,
        },
        polygon_mumbai: {
          url:API_URL,
          accounts:[PRIVATE_KEY],
          ChainID: 80001,
              
        },
    },
  namedAccounts: {
      deployer: {
          default: 0, 
          1: 0,
      }
  }
}
