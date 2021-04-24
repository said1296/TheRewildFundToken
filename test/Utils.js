module.exports = class Utils {
    static log(tag, message){
        console.log(`${tag}: ${message}`)
    }

    static getDonationAddress() {
        return '0xb6e1aA93DB091141Ef1C67751b4068A2d807a8c2'
    }

    static getLiquidityAddress() {
        return '0x57B1Be961198da42D6c820075404Ff23Bd580F40'
    }
}
