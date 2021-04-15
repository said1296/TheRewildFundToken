const contract = artifacts.require('./TheRewildFundToken')

module.exports = function(deployer) {
    deployer.deploy(contract, "The Rewild Fund Token", "RWLD")
}