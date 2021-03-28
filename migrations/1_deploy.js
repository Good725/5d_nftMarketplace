/// <reference types="../types/truffle-contracts" />

const BN = require("bn.js");

const Redeem = artifacts.require("Redeem");
const NFT = artifacts.require("NFT");
const Token = artifacts.require("Token");

module.exports = async function (deployer, _networks, accounts) {
    console.log(accounts[0]);

    await deployer.deploy(
        Token,
        "JL001_MOONWALK",
        "JL001",
        new BN(250000).mul(new BN(10).pow(new BN(18)))
    );
    let token = await Token.at(Token.address);

    await deployer.deploy(NFT, "Jahan Loh's Moonwalk", "MOONWALK", [
        "ipfs://QmecVeCXovqSD6DsLBUjY9kaMQK4vWZ4MKzoSGxkf6HnPW", // Phobos
        "ipfs://QmecY9ZYyEacnhyeiwgzz5EiEULy8VERNKnLtzmv72Gpu2", // Ganymede
        "ipfs://QmRb7bkm3j2k35W2NFo69uXwRFNrVRD7uqDRQ5SKgEp387", // Callisto
    ]);
    let nft = await NFT.at(NFT.address);

    await deployer.deploy(
        Redeem,
        token.address,
        nft.address,
        [
            new BN(100).mul(new BN(10).pow(new BN(18))),
            new BN(300).mul(new BN(10).pow(new BN(18))),
            new BN(1000).mul(new BN(10).pow(new BN(18))),
        ],
        [0, 0, 50]
    );
    let redeem = await Redeem.at(Redeem.address);

    await token.initializeRedeemContract.sendTransaction(redeem.address);
    await nft.initializeRedeemContract.sendTransaction(redeem.address);

    await redeem.redeem(0, 10);
    await redeem.redeem(1, 1);
    await redeem.redeem(2, 1);
    await redeem.redeem(0, 1);

    console.log(
        (await nft.tokensOfOwner(accounts[0])).map((x) => x.toString())
    );

    for (let i = 0; i < 4; i++) {
        const mintedToken = await nft.tokenOfOwnerByIndex(accounts[0], i);
        console.log("mintedToken", mintedToken.toString());

        console.log(await nft.tokenURI(mintedToken));
    }

    // await token.transfer(
    //     "0x1693325f5E363C72553750967fDb5A1419d6A42d",
    //     new BN(100000).mul(new BN(10).pow(new BN(18)))
    // );
};
