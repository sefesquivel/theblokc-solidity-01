// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import "@openzeppelin/contracts@4.9.1/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts@4.9.1/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts@4.9.1/security/Pausable.sol";
import "@openzeppelin/contracts@4.9.1/access/Ownable.sol";
import "@openzeppelin/contracts@4.9.1/utils/Counters.sol";

contract FinalToken is ERC721, ERC721Enumerable, Pausable, Ownable {
    //Property Variables
    using Counters for Counters.Counter;

    Counters.Counter private _tokenIdCounter;

    uint256 public MINT_PRICE;
    //uint256 public MAX_SUPPLY = 10000;

    //Lifecycle methods
    constructor() ERC721("FinalToken", "FTK") {
        _tokenIdCounter.increment();
    }

    function withdraw() public onlyOwner{
        require(address(this).balance > 0, "Balance is zero");
        payable(owner()).transfer(address(this).balance);
    }

    function setPrice(uint256 price) public onlyOwner{
        //We declare that the current price is similar to what is inputted
        MINT_PRICE = price; 
    }

    function getPrice() public view returns (uint256){
        //declares the current placed price
        return MINT_PRICE;
    }

    //Pausable Methods
    function pause() public onlyOwner {
        _pause();
    }

    function unpause() public onlyOwner {
        _unpause();
    }

    //Minting methods
    function safeMint(address to) public payable{
        //require(totalSupply() < MAX_SUPPLY, "Can't mint anymore tokens.");

        //require(msg.value >= MINT_PRICE, "Not enough ether sent.");
        uint256 tokenId = _tokenIdCounter.current();
        _tokenIdCounter.increment();
        _safeMint(to, tokenId);
    }

    //Other functions
      function _baseURI() internal pure override returns (string memory) {
        return "ipfs://FinalTokenBaseURI/";
    }

    function _beforeTokenTransfer(address from, address to, uint256 tokenId, uint256 batchSize)
        internal
        whenNotPaused
        override(ERC721, ERC721Enumerable)
    {
        super._beforeTokenTransfer(from, to, tokenId, batchSize);
    }

    // The following functions are overrides required by Solidity.

    function supportsInterface(bytes4 interfaceId)
        public
        view
        override(ERC721, ERC721Enumerable)
        returns (bool)
    {
        return super.supportsInterface(interfaceId);
    }
}