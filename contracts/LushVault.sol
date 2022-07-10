// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;
pragma abicoder v2;

import "./Ownable.sol";
import "./ERC721.sol";

import "./utils/SafeMath.sol";
import "./utils/Address.sol";
import "./utils/EnumerableSet.sol";
import "./utils/EnumerableMap.sol";
import "./utils/Strings.sol";

/**
 * @title LushVault contract
 * @dev Extends ERC721 Non-Fungible Token Standard basic implementation
 */
contract LushVault is ERC721, Ownable {
    using SafeMath for uint256;
    using Address for address;
    using EnumerableSet for EnumerableSet.UintSet;
    using EnumerableMap for EnumerableMap.UintToAddressMap;
    using Strings for uint256;

    mapping (uint256 => uint256) public tokenPrices;

    EnumerableSet.UintSet private tokensForSale;

    constructor(string memory name, string memory symbol) ERC721(name, symbol) {

    }


/* Consider adding additional function to allow withdrawal to an address other than the contract owner */
    function withdraw() public onlyOwner {
        uint balance = address(this).balance;
        payable(msg.sender).transfer(balance);
    }

    function setBaseURI(string memory baseURI) public onlyOwner {
        _setBaseURI(baseURI);
    }

    function setTokenPrice (uint256 tokenPrice, uint256 tokenId) public onlyOwner {
        tokenPrices[tokenId] = tokenPrice;
        tokensForSale.add(tokenId);
    }

    function updateTokenPrice (uint256 tokenPrice, uint256 tokenId) public onlyOwner {
        tokenPrices[tokenId] = tokenPrice;
    }

    function getTokenPrice (uint256 tokenId) public view returns(uint256) {
        return tokenPrices[tokenId];
    }

    function delistToken (uint256 tokenId) public onlyOwner {
        tokensForSale.remove(tokenId);
    }

    function buyToken (uint256 tokenId) public payable {
        uint256 tokenPrice = tokenPrices[tokenId];
        require(tokenPrice <= msg.value, "Ether value sent is not correct");
        require(tokensForSale.contains(tokenId), "Token is not for sale");
        tokensForSale.remove(tokenId);
        _safeMint(_msgSender(), tokenId);
    }

    function getTokensForSale () public view returns (uint256[] memory) {
        uint256[] memory tokenReturn = new uint256[](tokensForSale.length());
        for (uint i = 0; i < tokensForSale.length(); i++) {
            tokenReturn[i] = tokensForSale.at(i);
        }
        return tokenReturn;
    }

    function isTokenForSale (uint256 tokenId) public view returns (bool) {
        return tokensForSale.contains(tokenId);
    }

}