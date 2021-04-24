pragma solidity ^0.8.3;
// SPDX-License-Identifier: MIT

import "./ERC20Taxable.sol";
import "./Ownable.sol";

contract RewildToken is ERC20Taxable, Ownable {
    uint8 private _taxBasisPoints = 100;
    address private _donationAddress = 0xb6e1aA93DB091141Ef1C67751b4068A2d807a8c2;

    constructor ()
        ERC20Taxable('Rewild', 'RWLD')
    {
        _mint(0x3b1299734a1d85427a7B316a795f57Bc4abab454, getTokensFromDisplayValue(384000000));
        _mint(0xb6e1aA93DB091141Ef1C67751b4068A2d807a8c2, getTokensFromDisplayValue(128000000));
        _mint(0x1602643FD58E6DAFb0af9DA75cAC1FAb8612a222, getTokensFromDisplayValue(32000000));
        _mint(0x70b6275138e1293f177924FC531879E034688E07, getTokensFromDisplayValue(25600000));
        _mint(0xE8D2915B7868884721A1030BF7a5D6EF38E3e4fe, getTokensFromDisplayValue(1920000));
        _mint(0x61aCEAE8a22dF9824e1Ada9B7753385e329766bd, getTokensFromDisplayValue(9600000));
        _mint(0x35948a563d89cDe7b55Aa87429AC926e65B4A36E, getTokensFromDisplayValue(9600000));
        _mint(0xF1804Fb5048038f9Cd5F56AD8b2dfd7DE0778296, getTokensFromDisplayValue(1920000));
        _mint(0xd5033D2BcE919E60B89ba55094211A8D1f8fF600, getTokensFromDisplayValue(3840000));
        _mint(0x066Aa3A32E9b9d5fD48046499bD2b840bbD50283, getTokensFromDisplayValue(43520000));
    }

    /** TRANSACTIONS **/

    function transfer(address recipient, uint256 amount) public override returns(bool) {
        uint256 tax = calculateTax(amount);
        transferWithTax(recipient, amount, tax);
        if(tax > 0) {
            increaseBalance(_donationAddress, tax);
        }

        return true;
    }

    function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
        uint256 tax = calculateTax(amount);
        transferFromWithTax(sender, recipient, amount, tax);
        if(tax > 0) {
            increaseBalance(_donationAddress, tax);
        }
        return true;
    }

    /** STATE MUTATION OWNER **/

    function setTaxBasisPoints(uint8 taxBasisPoints_) public onlyOwner returns(bool) {
        _taxBasisPoints = taxBasisPoints_;
        return true;
    }

    function setDonationAddress(address donationAddress_) public onlyOwner returns(bool) {
        _donationAddress = donationAddress_;
        return true;
    }

    /** VIEWS TRANSFORM **/

    function calculateTax(uint256 amount_) public view returns(uint256) {
        return (amount_ * taxBasisPoints())/10000;
    }

    function getTokensFromDisplayValue(uint256 displayValue_) public view returns(uint256) {
        return displayValue_ * (10 ** decimals());
    }

    /** VIEWS READ **/

    function donationAddress() public view returns(address) {
        return _donationAddress;
    }

    function taxBasisPoints() public view returns (uint8) {
        return _taxBasisPoints;
    }
}
