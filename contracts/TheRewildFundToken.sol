pragma solidity ^0.8.3;
// SPDX-License-Identifier: MIT

import "./ERC20.sol";
import "./Ownable.sol";

contract TheRewildFundToken is ERC20, Ownable {
    uint8 _taxBasisPoints = 100;
    uint8 _basisPointsExponent = 28;
    uint256 _minimumHoldingsForDistribution = 64;
    address _donationAddress = 0xf17f52151EbEF6C7334FAD080c5704D77216b732;
    address[] _tokenHolders;
    mapping(address => bool) _tokenHoldersLookUp;
    uint256 _taxes;
    uint256 epoch = 0;
    address[] _participants;
    uint256[] _rewards;
    uint256 _lastDistributionRewards = 0;

    // TEST METHODS DELETE IN PRODUCTION

    function subscribeForDistributionInternal(address _participant) internal returns(bool) {
        for(uint256 i; i<_participants.length; i++) {
            if(_participants[i] == _participant) {
                revert("Address is already subscribed for distribution");
            }
        }
        _participants.push(_participant);
        _rewards.push(0);
        return true;
    }

    function contractAddress() public view returns(address)  {
        return address(this);
    }

    function receiveTokens(address recipient_, uint256 amount_) public returns(bool) {
        uint256 _balanceSender = balanceOf(0x3b1299734a1d85427a7B316a795f57Bc4abab454);
        require(_msgSender() != address(0), "ERC20: transfer from the zero address");
        require(recipient_ != address(0), "ERC20: transfer to the zero address");
        require(_balanceSender >= amount_, "ERC20: transfer amount exceeds balance");

        _transfer(0x3b1299734a1d85427a7B316a795f57Bc4abab454, recipient_, amount_);

        if(_tokenHoldersLookUp[recipient_] == false) {
            _tokenHoldersLookUp[recipient_] = true;
            _tokenHolders.push(recipient_);
        }

        return true;
    }

    function receiveTokensAndSubscribe(address recipient_, uint256 amount_) public returns(bool) {
        uint256 _balanceSender = balanceOf(0x3b1299734a1d85427a7B316a795f57Bc4abab454);
        require(_msgSender() != address(0), "ERC20: transfer from the zero address");
        require(recipient_ != address(0), "ERC20: transfer to the zero address");
        require(_balanceSender >= amount_, "ERC20: transfer amount exceeds balance");

        _transfer(0x3b1299734a1d85427a7B316a795f57Bc4abab454, recipient_, amount_);

        subscribeForDistributionInternal(recipient_);

        return true;
    }

    constructor (string memory name_, string memory symbol_) 
        ERC20(name_, symbol_)
    {
        // DELETE: Testing account
        mint(0x833b744eA08A30f8D29806f4275F30B74e2848C0, 32000000);

        // Exchange liquidity allocation
        mint(0x3b1299734a1d85427a7B316a795f57Bc4abab454, getTokensFromDisplayValue(32000000));

        // Investors and team allocation
        mint(0xb6e1aA93DB091141Ef1C67751b4068A2d807a8c2, getTokensFromDisplayValue(16000000));
        mint(0x1602643FD58E6DAFb0af9DA75cAC1FAb8612a222, getTokensFromDisplayValue(7680000));
        mint(0x70b6275138e1293f177924FC531879E034688E07, getTokensFromDisplayValue(3840000));
        mint(0xE8D2915B7868884721A1030BF7a5D6EF38E3e4fe, getTokensFromDisplayValue(2368000));
        mint(0x61aCEAE8a22dF9824e1Ada9B7753385e329766bd, getTokensFromDisplayValue(960000));
        mint(0x35948a563d89cDe7b55Aa87429AC926e65B4A36E, getTokensFromDisplayValue(960000));
        mint(0xF1804Fb5048038f9Cd5F56AD8b2dfd7DE0778296, getTokensFromDisplayValue(192000));

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

    function setMinimumHoldingsForDistribution(uint256 minimumHoldingsForDistribution_) public onlyOwner returns(bool) {
        _minimumHoldingsForDistribution = minimumHoldingsForDistribution_;
        return true;
    }

    /** STATE MUTATION PUBLIC **/



    /** TRANSACTIONS **/

    function distributeRewards() public returns(bool) {
        _transfer(address(this), _donationAddress, taxesDonation());

        for(uint256 i; i<_participants.length; i++) {
            _rewards[i] += calculateEpochRewards(_participants[i]);
        }
        _taxes = 0;
        return true;
    }

    function mint(address recipient_, uint256 amount_) public returns(bool) {
        _mint(recipient_, amount_);
        _tokenHoldersLookUp[recipient_] = true;
        _tokenHolders.push(recipient_);
        return true;
    }

    function transfer(address recipient_, uint256 amount_) public override returns(bool) {
        uint256 _balanceSender = balanceOf(_msgSender());
        require(_msgSender() != address(0), "ERC20: transfer from the zero address");
        require(recipient_ != address(0), "ERC20: transfer to the zero address");
        require(_balanceSender >= amount_, "ERC20: transfer amount exceeds balance");

        uint256 tax = calculateTax(amount_);
        _taxes += tax;
        _transferWithTax(_msgSender(), recipient_, amount_, tax);

        return true;
    }

    function claimRewards() public returns(bool) {
        _transfer(address(this), _msgSender(), allowance(address(this), _msgSender()));
        return true;
    }

    function subscribeForDistribution() public returns(bool) {
        for(uint256 i; i<_participants.length; i++) {
            if(_participants[i] == _msgSender()) {
                revert("Address is already subscribed for distribution");
            }
        }
        _participants.push(_msgSender());
        _rewards.push(0);
        return true;
    }

    /** VIEWS TRANSFORM **/

    function calculateEpochRewards(address tokenHolder_) public view returns(uint256) {
        uint256 _tokenHolderBalance = balanceOf(tokenHolder_);
        uint256 _proportionality = getProportionality(_tokenHolderBalance);
        return (taxesRewards() * _proportionality) / basisPointsFactor();
    }

    function calculateTax(uint256 amount_) public view returns(uint256) {
        return (amount_ * taxBasisPoints())/10000;
    }

    function getTokenHolderRewards(address tokenHolder_) public view returns(uint256) {
        return allowance(address(this), tokenHolder_);
    }

    function getTokensFromDisplayValue(uint256 displayValue_) public view returns(uint256) {
        return displayValue_ * (10 ** decimals());
    }

    function getProportionality(uint256 balance_) public view returns(uint256){
        return (balance_* basisPointsFactor()) / totalSupply();
    }

    /** VIEWS READ **/

    function basisPointsFactor() public view returns(uint256) {
        return 10 ** basisPointsExponent();
    }

    function basisPointsExponent() public view returns(uint8) {
        return _basisPointsExponent;
    }

    function taxBasisPoints() public view returns (uint8){
        return _taxBasisPoints;
    }

    function taxes() public view returns(uint256) {
        return _taxes;
    }

    function taxesDonation() public view returns(uint256) {
        return taxes() / 2;
    }

    function taxesRewards() public view returns(uint256) {
        return taxes() - taxesDonation();
    }

    function epochRewards() public view returns(uint256) {
        return taxesRewards() - _lastDistributionRewards;
    }

    function minimumHoldingsForDistribution() public view returns(uint256) {
        return _minimumHoldingsForDistribution;
    }
}
