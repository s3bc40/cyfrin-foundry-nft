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
        "data:application/json;base64,eyJuYW1lOiAiTW9vZCBORlQiLCBkZXNjcmlwdGlvbjogIkFuIE5GVCB0aGF0IHJlZmxlY3RzIHlvdXIgbW9vZCEiLCAiYXR0cmlidXRlcyI6IFt7InRyYWl0X3R5cGUiOiAiTW9vZCIsICJ2YWx1ZSI6IDEwMH1dLCAiaW1hZ2UiOiBkYXRhOmltYWdlL3N2Zyt4bWw7YmFzZTY0LFBITjJaeUIzYVdSMGFEMGlNVEF5TkhCNElpQm9aV2xuYUhROUlqRXdNalJ3ZUNJZ2RtbGxkMEp2ZUQwaU1DQXdJREV3TWpRZ01UQXlOQ0lnZUcxc2JuTTlJbWgwZEhBNkx5OTNkM2N1ZHpNdWIzSm5Mekl3TURBdmMzWm5JajRLSUNBOGNHRjBhQ0JtYVd4c1BTSWpNek16SWlCa1BTSk5OVEV5SURZMFF6STJOQzQySURZMElEWTBJREkyTkM0MklEWTBJRFV4TW5NeU1EQXVOaUEwTkRnZ05EUTRJRFEwT0NBME5EZ3RNakF3TGpZZ05EUTRMVFEwT0ZNM05Ua3VOQ0EyTkNBMU1USWdOalI2YlRBZ09ESXdZeTB5TURVdU5DQXdMVE0zTWkweE5qWXVOaTB6TnpJdE16Y3ljekUyTmk0MkxUTTNNaUF6TnpJdE16Y3lJRE0zTWlBeE5qWXVOaUF6TnpJZ016Y3lMVEUyTmk0MklETTNNaTB6TnpJZ016Y3llaUl2UGdvZ0lEeHdZWFJvSUdacGJHdzlJaU5GTmtVMlJUWWlJR1E5SWswMU1USWdNVFF3WXkweU1EVXVOQ0F3TFRNM01pQXhOall1Tmkwek56SWdNemN5Y3pFMk5pNDJJRE0zTWlBek56SWdNemN5SURNM01pMHhOall1TmlBek56SXRNemN5TFRFMk5pNDJMVE0zTWkwek56SXRNemN5ZWsweU9EZ2dOREl4WVRRNExqQXhJRFE0TGpBeElEQWdNQ0F4SURrMklEQWdORGd1TURFZ05EZ3VNREVnTUNBd0lERXRPVFlnTUhwdE16YzJJREkzTW1ndE5EZ3VNV010TkM0eUlEQXROeTQ0TFRNdU1pMDRMakV0Tnk0MFF6WXdOQ0EyTXpZdU1TQTFOakl1TlNBMU9UY2dOVEV5SURVNU4zTXRPVEl1TVNBek9TNHhMVGsxTGpnZ09EZ3VObU10TGpNZ05DNHlMVE11T1NBM0xqUXRPQzR4SURjdU5FZ3pOakJoT0NBNElEQWdNQ0F4TFRndE9DNDBZelF1TkMwNE5DNHpJRGMwTGpVdE1UVXhMallnTVRZd0xURTFNUzQyY3pFMU5TNDJJRFkzTGpNZ01UWXdJREUxTVM0MllUZ2dPQ0F3SURBZ01TMDRJRGd1TkhwdE1qUXRNakkwWVRRNExqQXhJRFE0TGpBeElEQWdNQ0F4SURBdE9UWWdORGd1TURFZ05EZ3VNREVnTUNBd0lERWdNQ0E1Tm5vaUx6NEtJQ0E4Y0dGMGFDQm1hV3hzUFNJak16TXpJaUJrUFNKTk1qZzRJRFF5TVdFME9DQTBPQ0F3SURFZ01DQTVOaUF3SURRNElEUTRJREFnTVNBd0xUazJJREI2YlRJeU5DQXhNVEpqTFRnMUxqVWdNQzB4TlRVdU5pQTJOeTR6TFRFMk1DQXhOVEV1Tm1FNElEZ2dNQ0F3SURBZ09DQTRMalJvTkRndU1XTTBMaklnTUNBM0xqZ3RNeTR5SURndU1TMDNMalFnTXk0M0xUUTVMalVnTkRVdU15MDRPQzQySURrMUxqZ3RPRGd1Tm5NNU1pQXpPUzR4SURrMUxqZ2dPRGd1Tm1NdU15QTBMaklnTXk0NUlEY3VOQ0E0TGpFZ055NDBTRFkyTkdFNElEZ2dNQ0F3SURBZ09DMDRMalJETmpZM0xqWWdOakF3TGpNZ05UazNMalVnTlRNeklEVXhNaUExTXpONmJURXlPQzB4TVRKaE5EZ2dORGdnTUNBeElEQWdPVFlnTUNBME9DQTBPQ0F3SURFZ01DMDVOaUF3ZWlJdlBnbzhMM04yWno0PSJ9";
    string public constant HAPPY_SVG_URI =
        "data:application/json;base64,eyJuYW1lOiAiTW9vZCBORlQiLCBkZXNjcmlwdGlvbjogIkFuIE5GVCB0aGF0IHJlZmxlY3RzIHlvdXIgbW9vZCEiLCAiYXR0cmlidXRlcyI6IFt7InRyYWl0X3R5cGUiOiAiTW9vZCIsICJ2YWx1ZSI6IDEwMH1dLCAiaW1hZ2UiOiBkYXRhOmltYWdlL3N2Zyt4bWw7YmFzZTY0LFBITjJaeUIyYVdWM1FtOTRQU0l3SURBZ01qQXdJREl3TUNJZ2QybGtkR2c5SWpRd01DSWdJR2hsYVdkb2REMGlOREF3SWlCNGJXeHVjejBpYUhSMGNEb3ZMM2QzZHk1M015NXZjbWN2TWpBd01DOXpkbWNpUGlBOFkybHlZMnhsSUdONFBTSXhNREFpSUdONVBTSXhNREFpSUdacGJHdzlJbmxsYkd4dmR5SWdjajBpTnpnaUlITjBjbTlyWlQwaVlteGhZMnNpSUhOMGNtOXJaUzEzYVdSMGFEMGlNeUl2UGlBOFp5QmpiR0Z6Y3owaVpYbGxjeUkrSUR4amFYSmpiR1VnWTNnOUlqY3dJaUJqZVQwaU9ESWlJSEk5SWpFeUlpOCtJRHhqYVhKamJHVWdZM2c5SWpFeU55SWdZM2s5SWpneUlpQnlQU0l4TWlJdlBpQThMMmMrSUR4d1lYUm9JR1E5SW0weE16WXVPREVnTVRFMkxqVXpZeTQyT1NBeU5pNHhOeTAyTkM0eE1TQTBNaTA0TVM0MU1pMHVOek1pSUhOMGVXeGxQU0ptYVd4c09tNXZibVU3SUhOMGNtOXJaVG9nWW14aFkyczdJSE4wY205clpTMTNhV1IwYURvZ016c2lMejRnUEM5emRtYysifQ==";

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
