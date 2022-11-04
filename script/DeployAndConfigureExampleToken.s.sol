// SPDX-License-Identifier: MIT
pragma solidity 0.8.17;

import "forge-std/Script.sol";

import { ERC721SeaDrop } from "../src/ERC721SeaDrop.sol";

import { ISeaDrop } from "../src/interfaces/ISeaDrop.sol";

import { PublicDrop } from "../src/lib/SeaDropStructs.sol";

contract DeployAndConfigureExampleToken is Script {
    // Addresses
    address seadrop = 0x00005EA00Ac477B1030CE78506496e8C2dE24bf5;
    address creator = 0x39e493CA97dC6320210c5F83A1473b85b7Ac45BA;  // my OS employee wallet
    address feeRecipient = 0xD18F24611D033268fBD91f71F8F688aA766178C0; // The Hundreds creator fee address

    // Token config
    uint256 maxSupply = 5000;

    // Drop config
    uint16 feeBps = 500; // 5%
    uint80 mintPrice = 0.25 ether;
    uint16 maxTotalMintableByWallet = 10;

    function run() external {
        vm.startBroadcast();

        address[] memory allowedSeadrop = new address[](1);
        allowedSeadrop[0] = seadrop;

        // This example uses ERC721SeaDrop. For separate Owner and
        // Administrator privileges, use ERC721PartnerSeaDrop.
        ERC721SeaDrop token = new ERC721SeaDrop(
            "Badam Bomb Squad",
            "ExTKN",
            allowedSeadrop
        );

        // Configure the token.
        token.setMaxSupply(maxSupply);

        // Configure the drop parameters.
        token.updateCreatorPayoutAddress(seadrop, creator);
        token.updateAllowedFeeRecipient(seadrop, feeRecipient, true);
        token.updatePublicDrop(
            seadrop,
            PublicDrop(
                mintPrice,
                1668110400, // start time
                1676059200, // end time
                maxTotalMintableByWallet,
                feeBps,
                true
            )
        );

        // We are ready, let's mint the first 3 tokens!
        ISeaDrop(seadrop).mintPublic{ value: mintPrice * 3 }(
            address(token),
            feeRecipient,
            address(0),
            3 // quantity
        );
    }
}
