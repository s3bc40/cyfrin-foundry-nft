// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {Test} from "forge-std/Test.sol";
import {BasicNft} from "src/BasicNft.sol";

contract BasicNftTest is Test {
    BasicNft basicNft;
    address public USER = makeAddr("user");
    string public constant SHIBA =
        "ipfs://bafybeibzgwqnmozdahzfuxrhytb7w5ovb5ncs2sf5slb35gt7u3kqodj2q/?filename=shiba-inu-metadata.json";

    function setUp() public {
        vm.startBroadcast();
        basicNft = new BasicNft();
        vm.stopBroadcast();
    }

    /*===============================================
                     INIT BASIC NFT          
    ===============================================*/
    function testNameIsCorrect() public view {
        string memory expectedName = "Doggie";
        string memory actualName = basicNft.name();
        // array of bytes is not equal to array of bytes
        // abi encode and keccak to compare two strings
        assert(keccak256(abi.encodePacked(actualName)) == keccak256(abi.encodePacked(expectedName)));
    }

    /*===============================================
                     MINT BASIC NFT          
    ===============================================*/
    function testCanMintAndHaveABalance() public {
        vm.prank(USER);
        basicNft.mintNft(SHIBA);

        assert(basicNft.balanceOf(USER) == 1);
        assert(keccak256(abi.encodePacked(SHIBA)) == keccak256(abi.encodePacked(basicNft.tokenURI(0))));
    }
}
