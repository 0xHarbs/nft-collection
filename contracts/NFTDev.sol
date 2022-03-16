//SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "./IWhitelist.sol";

contract NFTDev is ERC721, Ownable {
    string _baseTokenURI;
    uint256 public _price = 0.05 ether;
    bool public _paused;
    uint256 public maxTokenIds = 40;
    uint256 public tokenIds;
    IWhitelist whitelist;
    bool public presaleStarted;
    uint256 public preSaleEnded;

    modifier onlyWhenNotPaused() {
        require(!_paused, "Contract is paused");
        _;
    }

    constructor(string memory baseURI, address whitelistContract)
        ERC721("NFT Devs", "NFTDev")
    {
        _baseTokenURI = baseURI;
        whitelist = IWhitelist(whitelistContract);
    }

    function startPresale() public onlyOwner {
        presaleStarted = true;
        preSaleEnded = block.timestamp + 2 hours;
    }

    function presaleMint() public payable onlyWhenNotPaused {
        require(presaleStarted && block.timestamp < preSaleEnded);
        require(
            whitelist.whitelistedAddresses(msg.sender),
            "You are not whitelisted"
        );
        require(
            tokenIds < maxTokenIds,
            "The max number of tokens have been minted"
        );
        require(msg.value > _price, "Send more ether to purchase");
        tokenIds += 1;
        _safeMint(msg.sender, tokenIds);
    }

    function mint() public payable onlyWhenNotPaused {
        require(
            presaleStarted && block.timestamp >= preSaleEnded,
            "Presale not finished yet"
        );
        require(
            tokenIds < maxTokenIds,
            "The max number of tokens have been minted"
        );
        require(msg.value > _price, "Send more ether to purchase");
        tokenIds += 1;
        _safeMint(msg.sender, tokenIds);
    }

    function _baseURI() internal view virtual override returns (string memory) {
        return _baseTokenURI;
    }

    function setPaused(bool value) public onlyOwner {
        _paused = value;
    }

    function withdraw() public onlyOwner {
        address _owner = msg.sender;
        uint256 _amount = address(this).balance;
        (bool success, ) = _owner.call{value: _amount}("");
        require(success, "Failed to send funds");
    }

    receive() external payable {}

    fallback() external payable {}
}
