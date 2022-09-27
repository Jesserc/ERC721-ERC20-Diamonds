// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

library LibERC {
  bytes32 constant ERC721FACET_STORAGE_POSITION =
    keccak256("erc721.standard.app.storage");

  struct AppStorage {
    //ERC20 facet storage starts here
    string tName;
    string tSymbol;
    uint256 totalSupply;
    mapping(address => uint256) balanceOf;
    mapping(address => mapping(address => uint256)) allowance;
    mapping(address => uint256) nonces;
    //ERC20 facet storage ends here

    mapping(uint256 => address) _ownerOf;
    mapping(address => uint256) _balanceOf;
    mapping(uint256 => string) _tokenURIs;
    mapping(uint256 => address) getApproved;
    mapping(address => mapping(address => bool)) isApprovedForAll;
  }
}
