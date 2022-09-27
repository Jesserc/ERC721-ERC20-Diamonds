// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
import { LibERC } from "../libraries/LibERC.sol";

contract ERC20Facet {
  LibERC.AppStorage internal ap;

  //Events
  event Transfer(address indexed from, address indexed to, uint256 amount);

  event Approval(
    address indexed owner,
    address indexed spender,
    uint256 amount
  );

  /*  constructor(
    string memory _name,
    string memory _symbol,
    uint8 _decimals
  ) {
    name = _name;
    symbol = _symbol;
    decimals = _decimals;

  } */

  function name() public pure returns (string memory) {
    return "Diamond Token";
  }

  function symbol() public pure returns (string memory) {
    return unicode"💎";
  }

  function approve(address spender, uint256 amount) public returns (bool) {
    ap.allowance[msg.sender][spender] = amount;

    emit Approval(msg.sender, spender, amount);

    return true;
  }

  function transfer(address to, uint256 amount) public returns (bool) {
    ap.balanceOf[msg.sender] -= amount;

    // Cannot overflow because the sum of all user
    // balances can't exceed the max uint256 value.
    unchecked {
      ap.balanceOf[to] += amount;
    }

    emit Transfer(msg.sender, to, amount);

    return true;
  }

  function transferFrom(
    address from,
    address to,
    uint256 amount
  ) public returns (bool) {
    uint256 allowed = ap.allowance[from][msg.sender]; // Saves gas for limited approvals.

    if (allowed != type(uint256).max)
      ap.allowance[from][msg.sender] = allowed - amount;

    ap.balanceOf[from] -= amount;

    // Cannot overflow because the sum of all user
    // balances can't exceed the max uint256 value.
    unchecked {
      ap.balanceOf[to] += amount;
    }

    emit Transfer(from, to, amount);

    return true;
  }

  function tMint(address to, uint256 amount) public {
    _mint(to, amount);
  }

  function _mint(address to, uint256 amount) internal {
    ap.totalSupply += amount;

    // Cannot overflow because the sum of all user
    // balances can't exceed the max uint256 value.
    unchecked {
      ap.balanceOf[to] += amount;
    }

    emit Transfer(address(0), to, amount);
  }

  function _burn(address from, uint256 amount) internal {
    ap.balanceOf[from] -= amount;

    // Cannot underflow because a user's balance
    // will never be larger than the total supply.
    unchecked {
      ap.totalSupply -= amount;
    }

    emit Transfer(from, address(0), amount);
  }
}
