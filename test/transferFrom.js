const web3 = require('web3')
const Utils = require('./Utils')
const RewildToken = artifacts.require("RewildToken")

contract("RewildToken", accounts => {

    it(`should transferFrom tokens and receive them with taxes deducted`, async () => {
        const instance = await RewildToken.deployed()

        let transferAmount = 0;
        let targetReceiverBalance = 0

        const testMaxExponent = 5
        for(let i=0; i < testMaxExponent; i++) {
            transferAmount = Math.pow(10, i)
            await testTransferFrom()
        }


        async function testTransferFrom() {
            const initialSenderBalance = await instance.balanceOf(Utils.getLiquidityAddress())

            await instance.approve(accounts[9], transferAmount, {from: Utils.getLiquidityAddress()})
            await instance.transferFrom(Utils.getLiquidityAddress(), accounts[9], transferAmount, {from: accounts[9]})


            const targetSenderBalance = initialSenderBalance - transferAmount
            const senderBalance = await instance.balanceOf(Utils.getLiquidityAddress())

            const tax = await instance.calculateTax(transferAmount)

            targetReceiverBalance += transferAmount - tax
            const receiverBalance = await instance.balanceOf(accounts[9])

            assert.equal(
                receiverBalance,
                targetReceiverBalance,
                `receiverBalance is ${receiverBalance} and should be ${targetReceiverBalance}`
            )

            assert.equal(
                senderBalance,
                targetSenderBalance,
                `senderBalance is ${senderBalance} and should be ${targetSenderBalance}`
            )
        }
    })
})
