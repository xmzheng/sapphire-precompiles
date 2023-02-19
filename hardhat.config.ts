import { HardhatUserConfig } from "hardhat/config";
import "@nomicfoundation/hardhat-toolbox";

const config: HardhatUserConfig = {
  solidity: "0.8.17",
  networks: {
    sapphire: {
      url: 'https://testnet.sapphire.oasis.dev',
      accounts: ['47e179ec197488593b187f80a00eb0da91f1b9d0b13f8733639f19c30a34926a'],
      chainId: 0x5aff
    }
  }
};

export default config;
