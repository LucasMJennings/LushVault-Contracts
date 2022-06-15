pragma solidity ^0.7.0;

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

    EnumerableSet.UintSet public tokensForSale;

    constructor(string memory name, string memory symbol) ERC721(name, symbol) {

    }


/* Consider adding additional function to allow withdrawal to an address other than the contract owner */
    function withdraw() public onlyOwner {
        uint balance = address(this).balance;
        msg.sender.transfer(balance);
    }

    function setBaseURI(string memory baseURI) public onlyOwner {
        _setBaseURI(baseURI);
    }

    function setTokenPrice (uint256 memory tokenPrice, uint256 memory tokenId) public onlyOwner {
        tokenPrices[tokenId] = tokenPrice;
        tokensForSale.add(tokenId);
    }

    function updateTokenPrice (uint256 memory tokenPrice, uint256 memory tokenId) public onlyOwner {
        tokenPrices[tokenId] = tokenPrice;
    }

    function getTokenPrice (uint256 memory tokenId) public view {
        return tokenPrices[tokenId];
    }

    function delistToken (uint256 memory tokenId) public onlyOwner {
        tokensForSale.remove(tokenId);
    }

    function buyToken (uint256 tokenId) public payable {
        uint256 memory tokenPrice = tokenPrices[tokenId];
        require(tokenPrice <= msg.value, "Ether value sent is not correct");
        require(tokensForSale.contains(tokenId), "Token is not for sale");
        tokensForSale.remove(tokenId);
        _safeMint(_msgSender(), tokenId);
    }

    function getTokensForSale () public view {
        return tokensForSale;
    }

}