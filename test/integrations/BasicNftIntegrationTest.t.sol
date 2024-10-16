// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {Test, console} from "forge-std/Test.sol";
import {DeployBasicNft} from "script/DeployBasicNft.s.sol";
import {BasicNft} from "src/BasicNft.sol";
import {MintBasicNft} from "script/Interactions.s.sol";
import {DevOpsTools} from "lib/foundry-devops/src/DevOpsTools.sol";

contract BasicNftIntegrationTest is Test {
    DeployBasicNft deployer;
    BasicNft basicNft;
    MintBasicNft mintBasicNft;

    address public USER = makeAddr("user");
    string public constant SHIBA =
        "ipfs://bafybeibzgwqnmozdahzfuxrhytb7w5ovb5ncs2sf5slb35gt7u3kqodj2q/?filename=shiba-inu-metadata.json";

    function setUp() public {
        deployer = new DeployBasicNft();
        mintBasicNft = new MintBasicNft();
        basicNft = deployer.run();
    }

    /*===============================================
                     INIT BASIC NFT          
    ===============================================*/
    function testNameIsCorrectIntegration() public view {
        string memory expectedName = "Doggie";
        string memory actualName = basicNft.name();
        // array of bytes is not equal to array of bytes
        // abi encode and keccak to compare two strings
        assert(keccak256(abi.encodePacked(actualName)) == keccak256(abi.encodePacked(expectedName)));
    }

    /*===============================================
                     MINT BASIC NFT          
    ===============================================*/
    function testMintBasicNftOnContract() public {
        // Arrange / Act
        mintBasicNft.mintNftOnContract(address(basicNft));
        // Assert
        assert(basicNft.balanceOf(msg.sender) == 1);
        assert(keccak256(abi.encodePacked(SHIBA)) == keccak256(abi.encodePacked(basicNft.tokenURI(0))));
    }
}
