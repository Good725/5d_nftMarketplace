pragma solidity ^0.7.0;
pragma experimental ABIEncoderV2;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/math/SafeMath.sol";

contract NFT is Ownable, ERC721 {
    using SafeMath for uint256;

    uint256 public constant tokenIdMultiplier = 100000000;
    mapping(uint256 => uint256) public totalSupply;
    mapping(uint256 => string) public uriMap;

    constructor(
        string memory name,
        string memory symbol,
        string[] memory uriArray
    ) Ownable() ERC721(name, symbol) {
        // ERC721._setBaseURI(uri);
        _updateURIMap(uriArray);
    }

    function updateBaseURI(string memory baseURI) public onlyOwner {
        ERC721._setBaseURI(baseURI);
    }

    function updateURIMap(string[] memory uriArray) public onlyOwner {
        _updateURIMap(uriArray);
    }

    function _updateURIMap(string[] memory uriArray) internal {
        for (uint256 i = 0; i < uriArray.length; i++) {
            uriMap[i] = uriArray[i];
        }
    }

    function encodeTokenId(uint256 seriesId, uint256 tokenPosition)
        public
        pure
        returns (uint256)
    {
        return (seriesId + 1) * tokenIdMultiplier + tokenPosition;
    }

    function extractSeriesId(uint256 tokenId) public pure returns (uint256) {
        return
            ((tokenId - (tokenId % tokenIdMultiplier)) / tokenIdMultiplier) - 1;
    }

    function mint(
        address recipient,
        uint256 seriesId,
        bytes memory data
    ) public onlyOwner {
        uint256 tokenPosition = totalSupply[seriesId];
        require(tokenPosition < tokenIdMultiplier, "TOKEN_POSITION_TOO_LARGE");
        uint256 tokenID = encodeTokenId(seriesId, tokenPosition);

        totalSupply[seriesId] = tokenPosition.add(1);

        return _safeMint(recipient, tokenID, data);
    }

    function tokenURI(uint256 tokenId)
        public
        view
        virtual
        override
        returns (string memory)
    {
        require(
            _exists(tokenId),
            "ERC721Metadata: URI query for nonexistent token"
        );

        uint256 seriesId = extractSeriesId(tokenId);

        return uriMap[seriesId];
    }

    function tokensOfOwner(address owner)
        external
        view
        returns (uint256[] memory)
    {
        uint256 length = ERC721.balanceOf(owner);

        uint256[] memory tokenIds = new uint256[](length);
        for (uint256 i = 0; i < length; i++) {
            tokenIds[i] = tokenOfOwnerByIndex(owner, i);
        }

        return tokenIds;
    }
}
