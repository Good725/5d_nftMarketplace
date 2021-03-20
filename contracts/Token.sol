pragma solidity ^0.7.0;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract Token is Ownable, ERC20 {
    constructor(
        string memory name,
        string memory symbol,
        uint256 supply
    ) Ownable() ERC20(name, symbol) {
        _mint(msg.sender, supply);
    }

    function burn(address from, uint256 amount) public onlyOwner {
        _burn(from, amount);
    }
}
