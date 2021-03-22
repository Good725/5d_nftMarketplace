pragma solidity ^0.7.0;
pragma experimental ABIEncoderV2;

import "@openzeppelin/contracts/math/SafeMath.sol";
import "./Token.sol";
import "./NFT.sol";

contract Redeem {
    using SafeMath for uint256;

    Token public token;
    NFT public nft;
    uint256[] public prices;

    constructor(
        Token token_,
        NFT nft_,
        uint256[] memory prices_
    ) {
        token = token_;
        nft = nft_;
        prices = prices_;
    }

    function redeemWithData(
        uint256 id,
        uint256 amount,
        bytes memory data
    ) public {
        require(id < prices.length, "INVALID_ID");
        require(amount > 0, "INVALID_AMOUNT");

        uint256 price = prices[id];
        uint256 cost = price.mul(amount);

        token.burn(msg.sender, cost);

        for (uint256 i = 0; i < amount; i++) {
            nft.mint(msg.sender, id, data);
        }
    }

    function redeem(uint256 id, uint256 amount) public {
        redeemWithData(id, amount, "");
    }

    function totalSupplies() public view returns (uint256[] memory) {
        uint256[] memory balances = new uint256[](prices.length);
        for (uint256 i = 0; i < balances.length; i++) {
            balances[i] = nft.totalSupply(i);
        }
        return balances;
    }
}
