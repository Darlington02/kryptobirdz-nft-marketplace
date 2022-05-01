// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
import "./ERC165.sol";
import "./interfaces/IERC721.sol";
import "./libraries/Counters.sol";

contract ERC721 is ERC165, IERC721 {

    using SafeMath for uint256; 
    using Counters for Counters.Counter;

    // mapping from token id to owner
    mapping(uint256 => address) private _tokenOwner;

    // mapping from owner to number of owned tokens
    mapping(address => Counters.Counter) private _OwnedTokensCount;

    // mapping from token id to approved addresses
    mapping(uint256 => address) private _tokenApprovals;

    constructor() {
        _registerInterface(bytes4(keccak256('balanceOf(bytes4)')^keccak256('ownerOf(bytes4)')^keccak256('transferFrom(bytes4)')));
    }

    // Count all NFTs assigned to an owner
    function balanceOf(address _owner) public override view returns(uint256) {

        require(_owner != address(0), "NFTs assigned to the zero address are considered invalid!");
        return _OwnedTokensCount[_owner].current();

    }

    // Find the owner of an NFT
    function ownerOf(uint256 _tokenId) public override view returns(address) {

        address owner = _tokenOwner[_tokenId];
        require(owner != address(0), "NFTs assigned to the zero address are considered invalid!");
        return owner;
    }

    // function to check if token exists
    function _exists(uint256 tokenId) internal view returns(bool){

        address owner = _tokenOwner[tokenId];
        // return truthiness that address is not zero
        return owner != address(0);
    }

    // function for minting token
    function _mint(address to, uint256 tokenId) internal virtual {

        // requires that the address is not zero
        require(to != address(0), "ERC721: minting to the zero address");
        // requires that the token does not already exist
        require(!_exists(tokenId), "ERC721: token already minted");

        _tokenOwner[tokenId] = to;
        _OwnedTokensCount[to].increment();

        emit Transfer(address(0), to, tokenId);

    }

    // function for transferring NFTs
    function _transferFrom(address _from, address _to, uint256 _tokenId) internal {

        require(_to != address(0), "Error - ERC721 Transfer to the zero address");
        require(ownerOf(_tokenId) == _from, "Transfer failed");

        _OwnedTokensCount[_from].decrement();
        _OwnedTokensCount[_to].increment();

        _tokenOwner[_tokenId] = _to;

        emit Transfer(_from, _to, _tokenId);
    }

    function transferFrom(address _from, address _to, uint256 _tokenId) public override {
        
        require(isApprovedOrOwner(msg.sender, _tokenId));
        _transferFrom(_from, _to, _tokenId);

    }

    function approve(address _to, uint256 tokenId) public {

        address owner = ownerOf(tokenId);
        require(_to != owner, "Error - approval to current owner");
        require(msg.sender == owner, "Current caller is not the owner of the token");
        _tokenApprovals[tokenId] = _to;
        
        emit Approval(owner, _to, tokenId);

    }

    function isApprovedOrOwner(address spender, uint256 tokenId) internal view returns(bool) {

        require(_exists(tokenId), "token does not exist");
        address owner = ownerOf(tokenId);
        return(spender == owner);

    }
}