const contract = artifacts.require('./RewildToken')

module.exports = function(deployer) {
    deployer.deploy(contract)
}
