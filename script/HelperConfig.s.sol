// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {MockV3Aggregator} from "../test/mocks/MockV3Aggregator.sol";
import {Script} from "forge-std/Script.sol";

contract HelperConfig is Script {
    NetworkConfig public activeNetworkConfig;

    uint8 public constant DECIMALS = 8;
    int256 public constant INTITIAL_PRICE = 2000e8;

    struct NetworkConfig {
        address priceFeed;
    }

    event HelperConfig__CreatedMockPriceFeed(address priceFeed);

    constructor() {
        if (block.chainid == 11155111) {
            activeNetworkConfig = getSepoliaEthConfig();
        } else if (block.chainid == 1) {
            activeNetworkConfig = getEthMainnetConfig();
        } else {
            activeNetworkConfig = getOrCreateAnvilEthConfig();
        }
    }

    function getSepoliaEthConfig()
        public
        pure
        returns (NetworkConfig memory sepoliaNetworkConfig)
    {
        sepoliaNetworkConfig = NetworkConfig({
            priceFeed: 0x694AA1769357215DE4FAC081bf1f309aDC325306
        });
        return sepoliaNetworkConfig;
    }

    function getEthMainnetConfig() public pure returns (NetworkConfig memory) {
        NetworkConfig memory ethConfig = NetworkConfig({
            priceFeed: 0x5f4eC3Df9cbd43714FE2740f5E3616155c5b8419
        });
        return ethConfig;
    }

    function getOrCreateAnvilEthConfig()
        public
        returns (NetworkConfig memory anvilNetowrkConfig)
    {
        if (activeNetworkConfig.priceFeed != address(0)) {
            return activeNetworkConfig;
        }
        vm.startBroadcast();
        MockV3Aggregator mockPriceFeed = new MockV3Aggregator(
            DECIMALS,
            INTITIAL_PRICE
        );
        vm.stopBroadcast();

        NetworkConfig memory anvilNetowrkConfig = NetworkConfig({
            priceFeed: address(mockPriceFeed)
        });
        return anvilNetowrkConfig;
    }
}
