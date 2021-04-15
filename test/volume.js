const Utils = require('./Utils')
const TheRewildFundToken = artifacts.require("TheRewildFundToken")

contract("TheRewildFundToken", accounts => {
    Utils.log("ACCOUNTS LENGTH", accounts.length)

    const liquidityAddress = '0x3b1299734a1d85427a7B316a795f57Bc4abab454'


    it(`should distribute rewards to ${accounts.length} accounts`, async () => {
        const instance = await TheRewildFundToken.deployed()

        const tokensPerAccount = 100000
        let liquidityAddressBalance = await instance.balanceOf(liquidityAddress)

        const receiveTokensCalls = []
        for(let i=0; i<accounts.length; i++) {
            const account = accounts[i]
            if(liquidityAddressBalance >= tokensPerAccount) {
                liquidityAddressBalance = liquidityAddressBalance - tokensPerAccount
                receiveTokensCalls.push(instance.receiveTokensAndSubscribe(account, tokensPerAccount))
            } else {
                break
            }
        }

        await Promise.all(receiveTokensCalls)

        const result = await instance.distributeRewards()
        Utils.log("GAS USED", result.receipt.gasUsed)
    })
})
