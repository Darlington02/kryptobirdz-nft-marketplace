// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
import './ERC721.sol';
import './interfaces/IERC721Enumerable.sol';

contract ERC721Enumerable is ERC721, IERC721Enumerable {

    uint256[] private _allTokens;

    mapping(uint256 => uint256) private _allTokensIndex;
    mapping(address => uint256[]) private _ownedTokens;
    mapping(uint256 => uint256) private _ownedTokensIndex;

    constructor() {
        _registerInterface(bytes4(keccak256('totalSupply(bytes4)')^keccak256('tokenByIndex(bytes4)')^keccak256('tokenOfOwnerByIndex(bytes4)')));
    }

    // count NFTs tracked by this contract
    function totalSupply() public view override returns (uint256){
        return _allTokens.length;
    }

    function _mint(address to, uint256 tokenId) internal override(ERC721) {
        super._mint(to, tokenId);

        _addTokensToAllTokensEnumeration(tokenId);
        _addTokensToOwnerEnumeration(to, tokenId);
    }

    // add tokens to the _alltokens array and set the position of the token indexes
    function _addTokensToAllTokensEnumeration(uint256 tokenId) private {
        _allTokensIndex[tokenId] = _allTokens.length;
        _allTokens.push(tokenId);
    }

    function _addTokensToOwnerEnumeration(address to, uint256 tokenId) public {
        // add address and token id to the _ownedtokens
        _ownedTokensIndex[tokenId] = _ownedTokens[to].length;
         _ownedTokens[to].push(tokenId);
    }

    function tokenByIndex(uint256 index) public view override returns(uint256) {
        // make sure that the index is not out of bounds of the total supply
        require(index < totalSupply(), "Index is out of bounds");
        return _allTokens[index];
    }

    function tokenOfOwnerByIndex(address owner, uint256 index) public view override returns(uint256) {
        // make sure that the index is not out of bounds of the owner balance
        require(index < balanceOf(owner), "Index is out of bounds");
        return _ownedTokens[owner][index];
    }
}