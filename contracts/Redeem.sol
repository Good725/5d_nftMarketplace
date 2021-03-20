pragma solidity ^0.7.0;

import "@openzeppelin/contracts/math/SafeMath.sol";
import "./Token.sol";
import "./NFT.sol";

contract Redeem {
    using SafeMath for uint256;

    Token token;
    NFT nft;
    uint256[] prices;

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

        nft.mint(msg.sender, id, amount, data);
    }

    function redeem(uint256 id, uint256 amount) public {
        redeemWithData(id, amount, "");
    }
}
