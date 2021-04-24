const RewildToken = artifacts.require("RewildToken")

contract("RewildToken", accounts => {
    const testAmount = 100

    var targetTaxBasisPoints = 100
    it(`should test a tax of ${getTargetTaxPercentage()}%`, async () => {
        await testTaxes()
    })

    targetTaxBasisPoints = 10
    it(`should change taxBasisPoints to ${getTargetTaxPercentage()}%`, async () => {
        const instance = await RewildToken.deployed()
        await instance.setTaxBasisPoints(targetTaxBasisPoints)
        const taxBasisPoints = await instance.taxBasisPoints.call()

        assert.equal(
            taxBasisPoints,
            targetTaxBasisPoints,
            `taxBasisPoints is ${taxBasisPoints} and should be ${targetTaxBasisPoints}`
        )
    })

    it(`should test a tax of ${getTargetTaxPercentage()}%`, async () => {
        await testTaxes()
    })

    targetTaxBasisPoints = 1
    it(`should change taxBasisPoints to ${getTargetTaxPercentage()}%`, async () => {
        const instance = await RewildToken.deployed()
        await instance.setTaxBasisPoints(targetTaxBasisPoints)
        const taxBasisPoints = await instance.taxBasisPoints.call()

        assert.equal(
            taxBasisPoints,
            targetTaxBasisPoints,
            `taxBasisPoints is ${taxBasisPoints} and should be ${targetTaxBasisPoints}`
        )
    })

    it(`should test a tax of ${getTargetTaxPercentage()}%`, async () => {
        await testTaxes()
    })

    /** UTILS **/

    async function testTaxes() {
        const instance = await RewildToken.deployed()
        const testLabel = `should calculate ${getTargetTaxPercentage()}% of `
    
        for (const i of Array(5).keys()) {
            const amountToCalculateTaxOf =  Math.pow(testAmount, i+1)
            const tax = amountToCalculateTaxOf*getTargetTaxFactor()
            it(testLabel + amountToCalculateTaxOf, async () =>{
                const calculatedTax = await  instance.calculateTax.call(amountToCalculateTaxOf)

                assert.equal(
                    calculatedTax,
                    tax,
                    `${calculatedTax} isn't ${taxPercentage}% of ${amountToCalculateTaxOf}`
                )
            })
        }
    
    }

    function getTargetTaxPercentage() {
        return targetTaxBasisPoints / 100
    }

    function getTargetTaxFactor() {
        return targetTaxBasisPoints / 10000
    }
})
