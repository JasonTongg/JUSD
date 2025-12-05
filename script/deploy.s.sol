// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import "forge-std/Script.sol";
import "forge-std/console.sol";

import "../src/RateController.sol";
import "../src/MyUSD.sol";
import "../src/DEX.sol";
import "../src/Oracle.sol";
import "../src/MyUSDStaking.sol";
import "../src/MyUSDEngine.sol";

contract DeployScript is Script {
    function compute(address deployer, uint256 nonce) internal pure returns (address) {
        return computeCreateAddress(deployer, nonce);
    }

    function run() external {
        uint256 pk = vm.envUint("PRIVATE_KEY");
        address deployer = vm.rememberKey(pk);

        vm.startBroadcast(pk);

        // --- Fetch external data (replace with your own offchain script)
        // You cannot call JS inside Foundry, so set manual value:
        uint256 ethPrice = vm.envUint("ETH_PRICE");
        // Or hardcode:
        // uint256 ethPrice = 3000e8;

        // --- Nonce calculation
        uint256 nonce = vm.getNonce(deployer);

        // RateController = nonce + 0
        // MyUSD         = nonce + 1
        // DEX           = nonce + 2
        // Oracle        = nonce + 3
        // Staking       = nonce + 4
        // Engine        = nonce + 5

        address futureStakingAddress = compute(deployer, nonce + 4);
        address futureEngineAddress = compute(deployer, nonce + 5);

        console.log("Predicted Staking:", futureStakingAddress);
        console.log("Predicted Engine:", futureEngineAddress);

        // ---- Deploy contracts ----

        RateController rateController = new RateController(futureEngineAddress, futureStakingAddress);

        MyUSD stablecoin = new MyUSD(futureEngineAddress, futureStakingAddress);

        DEX dex = new DEX(address(stablecoin));

        Oracle oracle = new Oracle(address(dex), ethPrice);

        MyUSDStaking staking = new MyUSDStaking(address(stablecoin), futureEngineAddress, address(rateController));

        MyUSDEngine engine =
            new MyUSDEngine(address(oracle), address(stablecoin), address(staking), address(rateController));

        require(address(engine) == futureEngineAddress, "Engine address mismatch with predicted nonce!");

        console.log("RateController:", address(rateController));
        console.log("Stablecoin:", address(stablecoin));
        console.log("DEX:", address(dex));
        console.log("Oracle:", address(oracle));
        console.log("Staking:", address(staking));
        console.log("Engine:", address(engine));

        vm.stopBroadcast();
    }
}
