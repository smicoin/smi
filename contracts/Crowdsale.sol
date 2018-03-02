pragma solidity ^0.4.18;

import "../node_modules/zeppelin-solidity/contracts/token/ERC20/MintableToken.sol";
import "../node_modules/zeppelin-solidity/contracts/math/SafeMath.sol";


/**
 * @title Crowdsale
 * @dev Crowdsale is a base contract for managing a token crowdsale.
 * Crowdsales have a start and end timestamps, where investors can make
 * token purchases and the crowdsale will assign them tokens based
 * on a token per ETH rate. Funds collected are forwarded to a wallet
 * as they arrive.
 */
contract Crowdsale {
    using SafeMath for uint256;

    // The token being sold
    MintableToken public token;

    // start and end timestamps where investments are allowed (both inclusive)
    uint256 public preIcoStartTime;
    uint256 public icoStartTime;
    uint256 public preIcoEndTime;
    uint256 public icoEndTime;

    // address where funds are collected
    address public wallet;

    // how many token units a buyer gets per wei
    uint256 public preIcoRate;
    uint256 public icoRate;

    // amount of raised money in wei
    uint256 public weiRaised;

    /**
     * event for token purchase logging
     * @param purchaser who paid for the tokens
     * @param beneficiary who got the tokens
     * @param value weis paid for purchase
     * @param amount amount of tokens purchased
     */
    event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);


    function Crowdsale(uint256 _preIcoStartTime, uint256 _preIcoEndTime, uint256 _preIcoRate, uint256 _icoStartTime, uint256 _icoEndTime, uint256 _icoRate, address _wallet) public {
        require(_preIcoStartTime >= now);
        require(_preIcoEndTime >= _preIcoStartTime);

        require(_icoStartTime >= _preIcoEndTime);
        require(_icoEndTime >= _icoStartTime);

        require(_preIcoRate > 0);
        require(_icoRate > 0);

        require(_wallet != address(0));

        token = createTokenContract();
        preIcoStartTime = _preIcoStartTime;
        icoStartTime = _icoStartTime;

        preIcoEndTime = _preIcoEndTime;
        icoEndTime = _icoEndTime;

        preIcoRate = _preIcoRate;
        icoRate = _icoRate;

        wallet = _wallet;
    }

    // fallback function can be used to buy tokens
    function () external payable {
        buyTokens(msg.sender);
    }

    // low level token purchase function
    function buyTokens(address beneficiary) public payable {
        require(beneficiary != address(0));
        require(validPurchase());

        uint256 weiAmount = msg.value;

        // calculate token amount to be created
        uint256 tokens = getTokenAmount(weiAmount);

        // update state
        weiRaised = weiRaised.add(weiAmount);

        //send tokens to beneficiary.
        token.mint(beneficiary, tokens);

        //send same amount of tokens to owner.
        token.mint(wallet, tokens);

        TokenPurchase(msg.sender, beneficiary, weiAmount, tokens);

        forwardFunds();
    }

    // @return true if pre-ico crowdsale event has ended
    function preIcoHasEnded() public view returns (bool) {
        return now > preIcoEndTime;
    }

    // @return true if ico crowdsale event has ended
    function icoHasEnded() public view returns (bool) {
        return now > icoEndTime;
    }

    // creates the token to be sold.
    // override this method to have crowdsale of a specific mintable token.
    function createTokenContract() internal returns (MintableToken) {
        return new MintableToken();
    }

    // Override this method to have a way to add business logic to your crowdsale when buying
    function getTokenAmount(uint256 weiAmount) internal view returns(uint256) {
        if(!preIcoHasEnded()){
            return weiAmount.mul(preIcoRate);
        }else{
            return weiAmount.mul(icoRate);
        }
    }

    // send ether to the fund collection wallet
    // override to create custom fund forwarding mechanisms
    function forwardFunds() internal {
        wallet.transfer(msg.value);
    }

    // @return true if the transaction can buy tokens
    function validPurchase() internal view returns (bool) {
        bool withinPeriod = now >= preIcoStartTime && now <= preIcoEndTime || now >= icoStartTime && now <= icoEndTime;
        bool nonZeroPurchase = msg.value != 0;
        return withinPeriod && nonZeroPurchase;
    }

}
