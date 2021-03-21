pragma solidity ^0.7.0;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC1155/ERC1155.sol";
import "@openzeppelin/contracts/math/SafeMath.sol";

contract NFT is Ownable, ERC1155 {
    using SafeMath for uint256;

    constructor(string memory uri) Ownable() ERC1155(uri) {}

    uint256[] public totalSupply;

    function mint(
        address recipient,
        uint256 id,
        uint256 amount,
        bytes memory data
    ) public onlyOwner {
        totalSupply[id] = totalSupply[id].add(amount);
        return _mint(recipient, id, amount, data);
    }
}
