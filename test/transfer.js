const web3 = require('web3')
const Utils = require('./Utils')
const TheRewildFundToken = artifacts.require("TheRewildFundToken")

contract("TheRewildFundToken", accounts => {
    console.log(accounts.length)
    const testingLiquidityAddress = accounts[0];
    console.log(accounts[0])

    it(`should transfer taxes`, async () => {
        const transferAmount = 100000
        const instance = await TheRewildFundToken.deployed()


        let resultNormal = await instance.transferNormal(accounts[9], transferAmount, {from: testingLiquidityAddress})
        resultNormal = await instance.transferNormal(accounts[9], transferAmount, {from: testingLiquidityAddress})
        const resultFirstTime = await instance.transfer(accounts[9], transferAmount, {from: testingLiquidityAddress})
        const result = await instance.transfer(accounts[9], transferAmount, {from: testingLiquidityAddress})
        const result2 = await instance.transfer(accounts[9], transferAmount, {from: testingLiquidityAddress})

        Utils.log("GAS FIRST TIME", resultFirstTime.receipt.gasUsed)
        Utils.log("GAS", result.receipt.gasUsed)
        Utils.log("GAS2", result2.receipt.gasUsed)
        Utils.log("GAS NORMAL", resultNormal.receipt.gasUsed)
    })
})
