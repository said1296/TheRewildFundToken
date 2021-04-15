const TheRewildFundToken = artifacts.require("TheRewildFundToken")

contract("TheRewildFundToken", accounts => {
    it(`should get balance of liquidity address`, async () => {
        const liquidityAddress = "0x3b1299734a1d85427a7B316a795f57Bc4abab454"
        const targetLiquidityAddressBalance = 32000000 * 1e18;
        const instance = await TheRewildFundToken.deployed()
        const liquidityAddressBalance = await instance.balanceOf.call(liquidityAddress)

        assert.equal(
            liquidityAddressBalance,
            targetLiquidityAddressBalance,
            `liquidity address balance is ${liquidityAddressBalance} and should be ${targetLiquidityAddressBalance}`
        )
    })
})
