// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol";

contract TokenDegen is ERC20, Ownable, ERC20Burnable {

    constructor() ERC20("Degen", "DGN") Ownable(msg.sender) {}

    // Enum for collectible items
    enum Collectibles {Common, Uncommon, Rare, UltraRare, Legendary}

    struct Buyer {
        address buyerAddress;
        uint quantity;
    }
    // Queue for buyers wanting to purchase TokenDegen
    Buyer[] public buyerQueue;

    struct UserCollectibles {
        uint common;
        uint uncommon;
        uint rare;
        uint ultraRare;
        uint legend;
    }

    // Mapping to store redeemed collectibles
    mapping(address => UserCollectibles) public userCollectibles;

    function purchaseTokens(address _buyerAddress, uint _quantity) public {
        buyerQueue.push(Buyer({buyerAddress: _buyerAddress, quantity: _quantity}));
    }

    // Mint tokens for buyers in the queue
    function mintTokens() public onlyOwner {
        // Loop to mint tokens for buyers in the queue
        while (buyerQueue.length != 0) {
            uint index = buyerQueue.length - 1;
            if (buyerQueue[index].buyerAddress != address(0)) { // Check for non-zero address
                _mint(buyerQueue[index].buyerAddress, buyerQueue[index].quantity);
                buyerQueue.pop();
            }
        }
    }
    
    // Transfer tokens to another user
    function transferTokens(address _recipient, uint _quantity) public {
        require(_quantity <= balanceOf(msg.sender), "Insufficient balance");
        _transfer(msg.sender, _recipient, _quantity);
    }

    // Redeem different collectibles
    function redeemCollectibles(Collectibles _collectible) public {
        if (_collectible == Collectibles.Common) {
            require(balanceOf(msg.sender) >= 15, "Insufficient balance");
            userCollectibles[msg.sender].common += 1;
            burn(15);
        } else if (_collectible == Collectibles.Uncommon) {
            require(balanceOf(msg.sender) >= 25, "Insufficient balance");
            userCollectibles[msg.sender].uncommon += 1;
            burn(25);
        } else if (_collectible == Collectibles.Rare) {
            require(balanceOf(msg.sender) >= 35, "Insufficient balance");
            userCollectibles[msg.sender].rare += 1;
            burn(35);
        } else if (_collectible == Collectibles.UltraRare) {
            require(balanceOf(msg.sender) >= 45, "Insufficient balance");
            userCollectibles[msg.sender].ultraRare += 1;
            burn(45);
        } else if (_collectible == Collectibles.Legendary) {
            require(balanceOf(msg.sender) >= 60, "Insufficient balance");
            userCollectibles[msg.sender].legend += 1;
            burn(60);
        } else {
            revert("Invalid collectible selected");
        }
    }

    // Function to burn tokens
    function burnTokens(address _holder, uint _quantity) public {
        _burn(_holder, _quantity);
    }

    // Function to check the balance of tokens
    function getBalance() public view returns (uint) {
        return balanceOf(msg.sender);
    }
}
