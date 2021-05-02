pragma solidity ^0.8.3;
// SPDX-License-Identifier: MIT

import "./ERC20Taxable.sol";
import "./Ownable.sol";

contract RewildToken is ERC20Taxable, Ownable {
    uint8 private _taxBasisPoints = 250;
    address private _donationAddress = 0xb6e1aA93DB091141Ef1C67751b4068A2d807a8c2;

    constructor ()
        ERC20Taxable('Rewild', 'RWLD')
    {
        _mint(0x3b1299734a1d85427a7B316a795f57Bc4abab454, getTokensFromDisplayValue(352000000));
        _mint(0xb6e1aA93DB091141Ef1C67751b4068A2d807a8c2, getTokensFromDisplayValue(128000000));
        _mint(0x1602643FD58E6DAFb0af9DA75cAC1FAb8612a222, getTokensFromDisplayValue(38400000));
        _mint(0x70b6275138e1293f177924FC531879E034688E07, getTokensFromDisplayValue(25600000));
        _mint(0x61aCEAE8a22dF9824e1Ada9B7753385e329766bd, getTokensFromDisplayValue(9600000));
        _mint(0x35948a563d89cDe7b55Aa87429AC926e65B4A36E, getTokensFromDisplayValue(9600000));
        _mint(0xF1804Fb5048038f9Cd5F56AD8b2dfd7DE0778296, getTokensFromDisplayValue(2720000));
        _mint(0xd5033D2BcE919E60B89ba55094211A8D1f8fF600, getTokensFromDisplayValue(7680000));
        _mint(0xaf8b6F4aECCa3aA5Ea07b3f96418CA947bCA7968, getTokensFromDisplayValue(9600000));
        _mint(0x5f4D8c9576c67Ea540652BE0A0d2cFc6b9AE08c9, getTokensFromDisplayValue(3200000));
        _mint(0xB96A121C2F826F03b5eec1315046a3DF2Cf1a42C, getTokensFromDisplayValue(1600000));
        _mint(0x4E7e1C73C116649c1C684acB6ec98bAc4FbB4ef6, getTokensFromDisplayValue(6400000));
        _mint(0xefdee53249EF08013D31AEAC2A738912197b7b5e, getTokensFromDisplayValue(4800000));
        _mint(0xFc7b86ccA8BC329Ea500135F129D4259690eF258, getTokensFromDisplayValue(1600000));
        _mint(0x37eeEeB9bc8e3d144E2225660645ed68bE5b666C, getTokensFromDisplayValue(1600000));
        _mint(0xc8c01020d786920C29bDBb596eeF2A6f9A19C3D1, getTokensFromDisplayValue(2400000));
        _mint(0x7299B91174F79C820aA1Ed787F6C719A20AbcA95, getTokensFromDisplayValue(12800000));
        _mint(0x2797F2A68F998E8fC1462Fd0D1c01e891F60bdb5, getTokensFromDisplayValue(1600000));
        _mint(0xb4DE483a98E2d5C52C0eD51F5936A26A0D1ef39B, getTokensFromDisplayValue(3200000));
        _mint(0xafb7e19a422216b2c496EC9b59dc46CdAD9DD48a, getTokensFromDisplayValue(3200000));
        _mint(0xb4705fd75Ac926fF84a2467eb39a0Be12892641f, getTokensFromDisplayValue(3200000));
        _mint(0xeE3c21c21848ed1C787C7c0205E8dE40722846d6, getTokensFromDisplayValue(3200000));
        _mint(0x066Aa3A32E9b9d5fD48046499bD2b840bbD50283, getTokensFromDisplayValue(8000000));
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
        require(taxBasisPoints_ <= 250, "Tax can't be higher than 250 basis points");
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
