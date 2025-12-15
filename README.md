<img width="1439" height="892" alt="image" src="https://github.com/user-attachments/assets/fa0d75a0-8177-494e-a010-1d188e3b7999" />

# JUSD Stablecoin Engine

This project is the implementation of the core engine for **JUSD**, a decentralized, crypto-backed stablecoin designed to maintain a soft peg to **$1 USD**.

This system is modeled after the original "single collateral Dai" (MakerDAO) architecture, focusing on the essential mechanisms required for a robust, over-collateralized lending and stablecoin protocol.

- **Live Product:** [JUSD](https://jusd-stablecoin.vercel.app/).
- **Smart Contract using Foundry:** [JUSD FrontEnd](https://github.com/JasonTongg/JUSD_Frontend)

### Key Concepts Explored

* **Over-Collateralization:** Users lock up collateral (ETH) to mint JUSD.
* **Share-Based Debt System:** An efficient mechanism for tracking debt and accruing dynamic interest without updating every user's balance.
* **Dynamic Interest Rates:** The protocol uses adjustable **Borrow Rates** and **Savings Rates** as levers to influence supply and demand, helping to maintain the $1 peg.
* **Liquidations:** Mechanisms to protect the protocol by allowing the liquidation of under-collateralized debt positions.

## Features & Functionality

The completed system allows users to:

* **Deposit Collateral:** Lock up ETH as collateral in the `JUSDEngine`.
* **Mint JUSD:** Borrow the JUSD stablecoin against their deposited collateral, subject to a minimum collateralization ratio.
* **Repay Debt:** Repay their outstanding JUSD debt (which accrues interest).
* **Withdraw Collateral:** Retrieve their ETH once all associated debt is cleared.
* **Liquidate Positions:** Users can liquidate under-collateralized positions, maintaining the system's solvency.
* **Stake JUSD:** Users can stake JUSD in the `JUSDStaking` contract to earn a yield from the interest paid by borrowers.

## Core Contract Architecture

The system is composed of several inter-connected Solidity smart contracts, located in `packages/hardhat/contracts`.

| Contract | Purpose |
| :--- | :--- |
| `Engine.sol` | **The Core Logic.** Manages collateral deposits, controls the minting/burning of JUSD, calculates accrued debt/interest, and enforces liquidation requirements. |
| `MyUSD.sol` | The **ERC20 stablecoin** token, mintable and burnable exclusively by the `Engine`. |
| `RateController.sol` | Manages the adjustment of the global **Borrow Rate** (on `Engine`) and **Savings Rate** (on `Staking`) to stabilize the peg. |
| `Staking.sol` | Allows users to stake JUSD and earn yield from the borrowing interest. |
| `Oracle.sol` | Provides the necessary **ETH/USD** and **ETH/JUSD** price feeds for debt valuation and liquidation checks. |
| `DEX.sol` | A simple ETH/JUSD Decentralized Exchange used to determine the market price of the stablecoin for peg monitoring. |

## Network & Demo Notes:
* The protocol is currently deployed and running on the Sepolia testnet.
* The live demo operates with limited liquidity, as it is intended for demonstration and educational purposes rather than production use.

## Author  

**Jason Tong**  

- **Product:** [JUSD](https://jusd-stablecoin.vercel.app/)
- **GitHub:** [JasonTongg](https://github.com/JasonTongg).
- **Linkedin:** [Jason Tong](https://www.linkedin.com/in/jason-tong-42600319a/).
