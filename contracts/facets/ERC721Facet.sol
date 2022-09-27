// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import { LibERC } from "../libraries/LibERC.sol";

contract ERC721Facet {
  LibERC.AppStorage ns;
  event Transfer(address indexed from, address indexed to, uint256 indexed id);

  event Approval(
    address indexed owner,
    address indexed spender,
    uint256 indexed id
  );

  event ApprovalForAll(
    address indexed owner,
    address indexed operator,
    bool approved
  );

  /*//////////////////////////////////////////////////////////////
                         METADATA STORAGE/LOGIC
    //////////////////////////////////////////////////////////////*/

  function nName() public pure returns (string memory) {
    return "Diamond NFT";
  }

  function nSymbol() public pure returns (string memory) {
    return unicode"💎";
  }

  function tokenURI(uint256 tokenId) public view returns (string memory) {
    string memory _tokenURI = ns._tokenURIs[tokenId];

    // If there is a baseURI but no tokenURI, concatenate the tokenID to the baseURI.
    return _tokenURI;
  }

  function ownerOf(uint256 id) public view returns (address owner) {
    require((owner = ns._ownerOf[id]) != address(0), "NOT_MINTED");
  }

  function balanceOf(address owner) public view returns (uint256) {
    require(owner != address(0), "ZERO_ADDRESS");

    return ns._balanceOf[owner];
  }

  /*//////////////////////////////////////////////////////////////
                               CONSTRUCTOR
    //////////////////////////////////////////////////////////////*/

  // constructor(string memory _name, string memory _symbol) {
  //   name = _name;
  //   symbol = _symbol;
  // }

  function nApprove(address spender, uint256 id) internal {
    approve(spender, id);
  }

  function approve(address spender, uint256 id) internal {
    address owner = ns._ownerOf[id];

    require(
      msg.sender == owner || ns.isApprovedForAll[owner][msg.sender],
      "NOT_AUTHORIZED"
    );

    ns.getApproved[id] = spender;

    emit Approval(owner, spender, id);
  }

  function setApprovalForAll(address operator, bool approved) public {
    ns.isApprovedForAll[msg.sender][operator] = approved;

    emit ApprovalForAll(msg.sender, operator, approved);
  }

  function nTransferFrom(
    address from,
    address to,
    uint256 id
  ) public {
    transferFrom(from, to, id);
  }

  function transferFrom(
    address from,
    address to,
    uint256 id
  ) internal {
    require(from == ns._ownerOf[id], "WRONG_FROM");

    require(to != address(0), "INVALID_RECIPIENT");

    require(
      msg.sender == from ||
        ns.isApprovedForAll[from][msg.sender] ||
        msg.sender == ns.getApproved[id],
      "NOT_AUTHORIZED"
    );

    // Underflow of the sender's balance is impossible because we check for
    // ownership above and the recipient's balance can't realistically overflow.
    unchecked {
      ns._balanceOf[from]--;

      ns._balanceOf[to]++;
    }

    ns._ownerOf[id] = to;

    delete ns.getApproved[id];

    emit Transfer(from, to, id);
  }

  function nMint(address to, uint256 id) public {
    _mint(to, id);
  }

  // function supportsInterface(bytes4 interfaceId) public pure returns (bool) {
  //   return
  //     interfaceId == 0x01ffc9a7 || // ERC165 Interface ID for ERC165
  //     interfaceId == 0x80ac58cd || // ERC165 Interface ID for ERC721
  //     interfaceId == 0x5b5e139f; // ERC165 Interface ID for ERC721Metadata
  // }

  /*//////////////////////////////////////////////////////////////
                        INTERNAL MINT/BURN LOGIC
    //////////////////////////////////////////////////////////////*/

  function _mint(address to, uint256 id) internal {
    require(to != address(0), "INVALID_RECIPIENT");

    require(ns._ownerOf[id] == address(0), "ALREADY_MINTED");

    // Counter overflow is incredibly unrealistic.
    unchecked {
      ns._balanceOf[to]++;
    }

    ns._ownerOf[id] = to;

    emit Transfer(address(0), to, id);
  }

  function _burn(uint256 id) internal {
    address owner = ns._ownerOf[id];

    require(owner != address(0), "NOT_MINTED");

    // Ownership check above ensures no underflow.
    unchecked {
      ns._balanceOf[owner]--;
    }

    delete ns._ownerOf[id];

    delete ns.getApproved[id];

    emit Transfer(owner, address(0), id);
  }
}
