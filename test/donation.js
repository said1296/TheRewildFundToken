const Utils = require('./Utils')
const RewildToken = artifacts.require("RewildToken")


contract("RewildToken", accounts => {
    it(`should receive donations from transfer`, async () => {

        const instance = await RewildToken.deployed()

        let taxFactor = 0;
        let transferAmount = 0;
        let targetDonationAddressBalance = 0


        await testTaxFactor(0.01)
        await testTaxFactor(0.001)
        await testTaxFactor(0.0001)



        async function testTaxFactor(taxFactor_) {
            taxFactor = taxFactor_
            const taxPercentage = taxFactor_ * 100
            const taxBasisPoints = taxPercentage * 100
            if(taxBasisPoints < 0) {
                throw 'Tax basis points cant be less than 0'
            }

            await instance.setTaxBasisPoints(taxBasisPoints)

            const testMaxExponent = 5
            for(let i=0; i<testMaxExponent; i++) {
                transferAmount = Math.pow(10, i)
                await testDonation()
            }
        }

        async function testDonation() {
            await instance.transfer(accounts[9], transferAmount, {from: Utils.getLiquidityAddress()})

            targetDonationAddressBalance +=  Math.floor(transferAmount * taxFactor)

            const donationAddressBalance = await instance.balanceOf.call(Utils.getDonationAddress())

            assert.equal(
                donationAddressBalance,
                targetDonationAddressBalance,
                `donation address balance is ${donationAddressBalance} and should be ${donationAddressBalance}`
            )
        }
    })

})

contract("RewildToken", accounts => {
    it(`should receive donations from transferFrom`, async () => {

        const instance = await RewildToken.deployed()

        let taxFactor = 0;
        let transferAmount = 0;
        let targetDonationAddressBalance = 0


        await testTaxFactor(0.01)
        await testTaxFactor(0.001)
        await testTaxFactor(0.0001)



        async function testTaxFactor(taxFactor_) {
            taxFactor = taxFactor_
            const taxPercentage = taxFactor_ * 100
            const taxBasisPoints = taxPercentage * 100
            if(taxBasisPoints < 0) {
                throw 'Tax basis points cant be less than 0'
            }

            await instance.setTaxBasisPoints(taxBasisPoints)

            const testMaxExponent = 5
            for(let i=0; i<testMaxExponent; i++) {
                transferAmount = Math.pow(10, i)
                await testDonation()
            }
        }

        async function testDonation() {
            await instance.approve(accounts[9], transferAmount, {from: Utils.getLiquidityAddress()})
            await instance.transferFrom(Utils.getLiquidityAddress(), accounts[9], transferAmount, {from: accounts[9]})

            targetDonationAddressBalance +=  Math.floor(transferAmount * taxFactor)

            const donationAddressBalance = await instance.balanceOf.call(Utils.getDonationAddress())

            assert.equal(
                donationAddressBalance,
                targetDonationAddressBalance,
                `donation address balance is ${donationAddressBalance} and should be ${donationAddressBalance}`
            )
        }
    })

})
