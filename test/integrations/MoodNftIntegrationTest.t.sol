// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {MoodNft} from "src/MoodNft.sol";
import {Test, console} from "forge-std/Test.sol";
import {DeployMoodNft} from "script/DeployMoodNft.s.sol";
import {MintMoodNft, FlipMoodNft} from "script/Interactions.s.sol";

contract MoodNftIntegrationTest is Test {
    MoodNft moodNft;
    DeployMoodNft deployer;
    MintMoodNft mintMoodNft;
    FlipMoodNft flipMoodNft;

    string sadSvgImgUri;
    string happySvgImgUri;

    // from lib/forge-std/src/Base.sol
    address USER = makeAddr("user");
    string public constant SAD_SVG_URI =
        "data:application/json;base64,eyJuYW1lIjogIk1vb2QgTkZUIiwgImRlc2NyaXB0aW9uIjogIkFuIE5GVCB0aGF0IHJlZmxlY3RzIHlvdXIgbW9vZCEiLCAiYXR0cmlidXRlcyI6IFt7InRyYWl0X3R5cGUiOiAiTW9vZCIsICJ2YWx1ZSI6IDEwMH1dLCAiaW1hZ2UiOiAiZGF0YTppbWFnZS9zdmcreG1sO2Jhc2U2NCxQSE4yWnlCM2FXUjBhRDBpTVRBeU5IQjRJaUJvWldsbmFIUTlJakV3TWpSd2VDSWdkbWxsZDBKdmVEMGlNQ0F3SURFd01qUWdNVEF5TkNJZ2VHMXNibk05SW1oMGRIQTZMeTkzZDNjdWR6TXViM0puTHpJd01EQXZjM1puSWo0S0lDQThjR0YwYUNCbWFXeHNQU0lqTXpNeklpQmtQU0pOTlRFeUlEWTBRekkyTkM0MklEWTBJRFkwSURJMk5DNDJJRFkwSURVeE1uTXlNREF1TmlBME5EZ2dORFE0SURRME9DQTBORGd0TWpBd0xqWWdORFE0TFRRME9GTTNOVGt1TkNBMk5DQTFNVElnTmpSNmJUQWdPREl3WXkweU1EVXVOQ0F3TFRNM01pMHhOall1Tmkwek56SXRNemN5Y3pFMk5pNDJMVE0zTWlBek56SXRNemN5SURNM01pQXhOall1TmlBek56SWdNemN5TFRFMk5pNDJJRE0zTWkwek56SWdNemN5ZWlJdlBnb2dJRHh3WVhSb0lHWnBiR3c5SWlORk5rVTJSVFlpSUdROUlrMDFNVElnTVRRd1l5MHlNRFV1TkNBd0xUTTNNaUF4TmpZdU5pMHpOeklnTXpjeWN6RTJOaTQySURNM01pQXpOeklnTXpjeUlETTNNaTB4TmpZdU5pQXpOekl0TXpjeUxURTJOaTQyTFRNM01pMHpOekl0TXpjeWVrMHlPRGdnTkRJeFlUUTRMakF4SURRNExqQXhJREFnTUNBeElEazJJREFnTkRndU1ERWdORGd1TURFZ01DQXdJREV0T1RZZ01IcHRNemMySURJM01tZ3RORGd1TVdNdE5DNHlJREF0Tnk0NExUTXVNaTA0TGpFdE55NDBRell3TkNBMk16WXVNU0ExTmpJdU5TQTFPVGNnTlRFeUlEVTVOM010T1RJdU1TQXpPUzR4TFRrMUxqZ2dPRGd1Tm1NdExqTWdOQzR5TFRNdU9TQTNMalF0T0M0eElEY3VORWd6TmpCaE9DQTRJREFnTUNBeExUZ3RPQzQwWXpRdU5DMDROQzR6SURjMExqVXRNVFV4TGpZZ01UWXdMVEUxTVM0MmN6RTFOUzQySURZM0xqTWdNVFl3SURFMU1TNDJZVGdnT0NBd0lEQWdNUzA0SURndU5IcHRNalF0TWpJMFlUUTRMakF4SURRNExqQXhJREFnTUNBeElEQXRPVFlnTkRndU1ERWdORGd1TURFZ01DQXdJREVnTUNBNU5ub2lMejRLSUNBOGNHRjBhQ0JtYVd4c1BTSWpNek16SWlCa1BTSk5Namc0SURReU1XRTBPQ0EwT0NBd0lERWdNQ0E1TmlBd0lEUTRJRFE0SURBZ01TQXdMVGsySURCNmJUSXlOQ0F4TVRKakxUZzFMalVnTUMweE5UVXVOaUEyTnk0ekxURTJNQ0F4TlRFdU5tRTRJRGdnTUNBd0lEQWdPQ0E0TGpSb05EZ3VNV00wTGpJZ01DQTNMamd0TXk0eUlEZ3VNUzAzTGpRZ015NDNMVFE1TGpVZ05EVXVNeTA0T0M0MklEazFMamd0T0RndU5uTTVNaUF6T1M0eElEazFMamdnT0RndU5tTXVNeUEwTGpJZ015NDVJRGN1TkNBNExqRWdOeTQwU0RZMk5HRTRJRGdnTUNBd0lEQWdPQzA0TGpSRE5qWTNMallnTmpBd0xqTWdOVGszTGpVZ05UTXpJRFV4TWlBMU16TjZiVEV5T0MweE1USmhORGdnTkRnZ01DQXhJREFnT1RZZ01DQTBPQ0EwT0NBd0lERWdNQzA1TmlBd2VpSXZQZ284TDNOMlp6ND0ifQ==";
    string public constant HAPPY_SVG_URI =
        "data:application/json;base64,eyJuYW1lIjogIk1vb2QgTkZUIiwgImRlc2NyaXB0aW9uIjogIkFuIE5GVCB0aGF0IHJlZmxlY3RzIHlvdXIgbW9vZCEiLCAiYXR0cmlidXRlcyI6IFt7InRyYWl0X3R5cGUiOiAiTW9vZCIsICJ2YWx1ZSI6IDEwMH1dLCAiaW1hZ2UiOiAiZGF0YTppbWFnZS9zdmcreG1sO2Jhc2U2NCxQSE4yWnlCMmFXVjNRbTk0UFNJd0lEQWdNakF3SURJd01DSWdkMmxrZEdnOUlqUXdNQ0lnSUdobGFXZG9kRDBpTkRBd0lpQjRiV3h1Y3owaWFIUjBjRG92TDNkM2R5NTNNeTV2Y21jdk1qQXdNQzl6ZG1jaVBpQThZMmx5WTJ4bElHTjRQU0l4TURBaUlHTjVQU0l4TURBaUlHWnBiR3c5SW5sbGJHeHZkeUlnY2owaU56Z2lJSE4wY205clpUMGlZbXhoWTJzaUlITjBjbTlyWlMxM2FXUjBhRDBpTXlJdlBpQThaeUJqYkdGemN6MGlaWGxsY3lJK0lEeGphWEpqYkdVZ1kzZzlJamN3SWlCamVUMGlPRElpSUhJOUlqRXlJaTgrSUR4amFYSmpiR1VnWTNnOUlqRXlOeUlnWTNrOUlqZ3lJaUJ5UFNJeE1pSXZQaUE4TDJjK0lEeHdZWFJvSUdROUltMHhNell1T0RFZ01URTJMalV6WXk0Mk9TQXlOaTR4TnkwMk5DNHhNU0EwTWkwNE1TNDFNaTB1TnpNaUlITjBlV3hsUFNKbWFXeHNPbTV2Ym1VN0lITjBjbTlyWlRvZ1lteGhZMnM3SUhOMGNtOXJaUzEzYVdSMGFEb2dNenNpTHo0Z1BDOXpkbWMrIn0=";

    function setUp() public {
        deployer = new DeployMoodNft();
        mintMoodNft = new MintMoodNft();
        flipMoodNft = new FlipMoodNft();
        moodNft = deployer.run();
        sadSvgImgUri = deployer.svgToImageURI(vm.readFile("./img/sad.svg"));
        happySvgImgUri = deployer.svgToImageURI(vm.readFile("./img/happy.svg"));
    }

    /*===============================================
                     INIT MOOD          
    ===============================================*/
    function testMoodStateInitIntegration() public view {
        // Arrange / Act / Assert
        assertEq(moodNft.getHappySvgImgUri(), happySvgImgUri);
        assertEq(moodNft.getSadSvgImgUri(), sadSvgImgUri);
        assertEq(moodNft.getTokenCounter(), 0);
    }

    /*===============================================
                     DEPLOYER CONVERTER          
    ===============================================*/
    function testConvertSvgToUri() public view {
        string memory expectedUri =
            "data:image/svg+xml;base64,PHN2ZyB2aWV3Qm94PSIwIDAgMjAwIDIwMCIgd2lkdGg9IjQwMCIgIGhlaWdodD0iNDAwIiB4bWxucz0iaHR0cDovL3d3dy53My5vcmcvMjAwMC9zdmciPiA8Y2lyY2xlIGN4PSIxMDAiIGN5PSIxMDAiIGZpbGw9InllbGxvdyIgcj0iNzgiIHN0cm9rZT0iYmxhY2siIHN0cm9rZS13aWR0aD0iMyIvPiA8ZyBjbGFzcz0iZXllcyI+IDxjaXJjbGUgY3g9IjcwIiBjeT0iODIiIHI9IjEyIi8+IDxjaXJjbGUgY3g9IjEyNyIgY3k9IjgyIiByPSIxMiIvPiA8L2c+IDxwYXRoIGQ9Im0xMzYuODEgMTE2LjUzYy42OSAyNi4xNy02NC4xMSA0Mi04MS41Mi0uNzMiIHN0eWxlPSJmaWxsOm5vbmU7IHN0cm9rZTogYmxhY2s7IHN0cm9rZS13aWR0aDogMzsiLz4gPC9zdmc+";
        string memory svg =
            '<svg viewBox="0 0 200 200" width="400"  height="400" xmlns="http://www.w3.org/2000/svg"> <circle cx="100" cy="100" fill="yellow" r="78" stroke="black" stroke-width="3"/> <g class="eyes"> <circle cx="70" cy="82" r="12"/> <circle cx="127" cy="82" r="12"/> </g> <path d="m136.81 116.53c.69 26.17-64.11 42-81.52-.73" style="fill:none; stroke: black; stroke-width: 3;"/> </svg>';
        string memory actualUri = deployer.svgToImageURI(svg);
        console.log(actualUri);
        assertEq(keccak256(abi.encodePacked(expectedUri)), keccak256(abi.encodePacked(actualUri)));
    }

    /*===============================================
                     INTERACTION MINT MOOD      
    ===============================================*/
    function testMintMoodWithMintNftOnContract() public {
        // Arrange / Act
        mintMoodNft.mintNftOnContract(address(moodNft));
        // Assert
        assert(moodNft.balanceOf(msg.sender) == 1);
        console.log(moodNft.tokenURI(0));
        assert(keccak256(abi.encodePacked(HAPPY_SVG_URI)) == keccak256(abi.encodePacked(moodNft.tokenURI(0))));
    }

    /*===============================================
                     INTERACTION FLIP MOOD          
    ===============================================*/
    function testFlipMoodRevertIfNoMoodMinted() public {
        // Arrange / Act / Assert
        vm.expectRevert();
        flipMoodNft.flipMoodOnContract(address(moodNft));
    }

    function testFlipMoodWithFlipNftOnContract() public {
        // Arrange
        mintMoodNft.mintNftOnContract(address(moodNft));
        // Act
        flipMoodNft.flipMoodOnContract(address(moodNft));
        // Assert
        assert(keccak256(abi.encodePacked(SAD_SVG_URI)) == keccak256(abi.encodePacked(moodNft.tokenURI(0))));
    }
}
