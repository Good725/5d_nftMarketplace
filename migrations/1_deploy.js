/// <reference types="../types/truffle-contracts" />

const BN = require("bn.js");

const Redeem = artifacts.require("Redeem");
const NFT = artifacts.require("NFT");
const Token = artifacts.require("Token");

module.exports = async function (deployer, _networks, accounts) {
    console.log(accounts[0]);
    await deployer.deploy(
        Token,
        "5D:JL1",
        "5D:JL1",
        new BN(100000).mul(new BN(10).pow(new BN(18)))
    );
    let token = await Token.at(Token.address);

    await deployer.deploy(
        NFT,
        "Moonwalk by Jahan Loh - Fifth Dimension",
        "MOONWALK",
        [
            "ipfs://QmZp4qZa2qYkcAiCnr3M24Gm9zKkdz5J7Xt1TLHMR2V3s4",
            "ipfs://QmYiDBuWvmV1Rm3vdH2vees6kPMo8D6qt9N8fTDuhQVcxp",
            "ipfs://QmThaeNiJMvU9fap2Lh3Etb1MbFEN1gqrScApnkHqMMump",
        ]
    );
    let nft = await NFT.at(NFT.address);

    await deployer.deploy(Redeem, token.address, nft.address, [
        new BN(100).mul(new BN(10).pow(new BN(18))),
        new BN(300).mul(new BN(10).pow(new BN(18))),
        new BN(1000).mul(new BN(10).pow(new BN(18))),
    ]);
    let redeem = await Redeem.at(Redeem.address);

    await token.transferOwnership.sendTransaction(redeem.address);
    await nft.transferOwnership.sendTransaction(redeem.address);

    // await redeem.redeem(0, 10);
    // await redeem.redeem(1, 1);
    // await redeem.redeem(2, 1);
    // await redeem.redeem(0, 1);

    // console.log(
    //     (await nft.tokensOfOwner(accounts[0])).map((x) => x.toString())
    // );

    // for (let i = 0; i < 4; i++) {
    //     const mintedToken = await nft.tokenOfOwnerByIndex(accounts[0], i);
    //     console.log("mintedToken", mintedToken.toString());

    //     console.log(await nft.tokenURI(mintedToken));
    // }

    await token.transfer(
        "0x1693325f5E363C72553750967fDb5A1419d6A42d",
        new BN(100000).mul(new BN(10).pow(new BN(18)))
    );
};
