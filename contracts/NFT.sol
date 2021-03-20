pragma solidity ^0.7.0;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC1155/ERC1155.sol";

contract NFT is Ownable, ERC1155 {
    constructor(string memory uri) Ownable() ERC1155(uri) {}

    function mint(
        address recipient,
        uint256 id,
        uint256 amount,
        bytes memory data
    ) public onlyOwner {
        return _mint(recipient, id, amount, data);
    }
}
