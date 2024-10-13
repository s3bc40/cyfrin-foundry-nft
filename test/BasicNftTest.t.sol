// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {Test} from "forge-std/Test.sol";
import {DeployBasicNft} from "script/DeployBasicNft.s.sol";
import {BasicNft} from "src/BasicNft.sol";

contract BasicNftTest is Test {
    DeployBasicNft deployer;
    BasicNft basicNft;
    address public USER = makeAddr("user");
    string public constant SHIBA =
        "ipfs://QmSByNquRYDrrwu9wngfSxe2e5UeZQewAAGS25djj2GW3d?filename=shiba-inu-metadata.json";

    function setUp() public {
        deployer = new DeployBasicNft();
        basicNft = deployer.run();
    }

    function testNameIsCorrect() public view {
        string memory expectedName = "Doggie";
        string memory actualName = basicNft.name();
        // array of bytes is not equal to array of bytes
        // abi encode and keccak to compare two strings
        assert(keccak256(abi.encodePacked(actualName)) == keccak256(abi.encodePacked(expectedName)));
    }

    function testCanMintAndHaveABalance() public {
        vm.prank(USER);
        basicNft.mintNft(SHIBA);

        assert(basicNft.balanceOf(USER) == 1);
        assert(keccak256(abi.encodePacked(SHIBA)) == keccak256(abi.encodePacked(basicNft.tokenURI(0))));
    }
}
