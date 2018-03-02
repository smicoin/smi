pragma solidity ^0.4.18;

import "./Crowdsale.sol";
import "../node_modules/zeppelin-solidity/contracts/token/ERC20/MintableToken.sol";
import "../node_modules/zeppelin-solidity/contracts/token/ERC20/BurnableToken.sol";


/**
 * @title SocialMediaIncomeCrowdsaleToken
 * @dev ERC20 Token that can be minted.
 * It is meant to be used in a crowdsale contract.
 */
contract SocialMediaIncomeCrowdsaleToken is MintableToken, BurnableToken {

    string public constant name = "Social Media Income"; // solium-disable-line uppercase
    string public constant symbol = "SMI"; // solium-disable-line uppercase
    uint8 public constant decimals = 18; // solium-disable-line uppercase

}


/**
 * @title SocialMediaIncomeCrowdsale
 * @dev This is a fully fledged crowdsale.
 * The way to add new features to a base crowdsale is by multiple inheritance.
 *
 * After adding multiple features it's good practice to run integration tests
 * to ensure that subcontracts works together as intended.
 */
contract SocialMediaIncomeCrowdsale is Crowdsale {

    function SocialMediaIncomeCrowdsale(uint256 _preIcoStartTime, uint256 _preIcoEndTime, uint256 _preIcoRate, uint256 _icoStartTime, uint256 _icoEndTime, uint256 _icoRate, address _wallet) public
    Crowdsale(_preIcoStartTime, _preIcoEndTime, _preIcoRate, _icoStartTime, _icoEndTime, _icoRate, _wallet)
    {

    }

    function createTokenContract() internal returns (MintableToken) {
        return new SocialMediaIncomeCrowdsaleToken();
    }
}
