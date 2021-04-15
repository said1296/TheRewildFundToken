const web3 = require('web3')
const Utils = require('./Utils')
const TheRewildFundToken = artifacts.require("TheRewildFundToken")

contract("TheRewildFundToken", accounts => {
    console.log(accounts.length)
    const testingLiquidityAddress = accounts[0];
    const donationAddress = accounts[1]
    const taxFactor = 0.01
    it(`should transfer taxes`, async () => {
        const transferAmount = 100000
        const instance = await TheRewildFundToken.deployed()

        await instance.transfer(accounts[9], transferAmount, {from: testingLiquidityAddress})

        const targetTaxes =  transferAmount * taxFactor
        const taxes = await instance.taxes()
        assert.equal(
            taxes,
            targetTaxes,
            `donation taxes is ${taxes} and should be ${targetTaxes}`
        )

        await instance.distributeRewards()

        const donationAddressBalance = await instance.balanceOf.call(donationAddress)
        const targetDonationAddressBalance = targetTaxes/2

        assert.equal(
            donationAddressBalance,
            targetDonationAddressBalance,
            `donation address balance is ${donationAddressBalance} and should be ${targetDonationAddressBalance}`
        )


    })
})
