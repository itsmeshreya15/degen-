# DegenToken

Simple Overview
DegenToken is an ERC20 token deployed on the Avalanche network for Degen Gaming. This token facilitates in-game rewards, item exchanges, and token management for players.

## Description

DegenToken is a custom ERC20 token created for Degen Gaming on the Avalanche network. The smart contract allows for minting, transferring, redeeming, checking balances, and burning tokens. Only the owner can mint new tokens, ensuring controlled distribution for rewards. Players can exchange tokens for in-game items, transfer tokens to other players, and manage their token balances. The contract also provides a method for burning tokens that are no longer needed.

## Getting Started

### Installing

To run this program, you will need to use Remix, an online Solidity IDE. Follow these steps to get started:

Visit Remix: Go to https://remix.ethereum.org/.
Create a New File: Click on the "+" icon in the left-hand sidebar to create a new file.
Save the File: Save the file with a .sol extension (e.g., degen.sol).
Copy and Paste Code: Copy and paste the following code into the new file:

### Executing program

To run the program, follow these steps:

Compile the Code:

Click on the "Solidity Compiler" tab in the left-hand sidebar.
Ensure the "Compiler" option is set to a compatible version, such as "0.8.23".
Click on the "Compile Degen.sol" button.
Deploy the Contract:

Click on the "Deploy & Run Transactions" tab in the left-hand sidebar.
Select the "Degen" contract from the dropdown menu.
Click on the "Deploy" button.
Interact with the Contract:

Minting Tokens: Upon deployment, 10 DGN tokens are minted to the contract address.
Creating Tokens: Call the createTokens function.
Destroying Tokens: Call the destroyTokens function with the amount to burn tokens .
```
/*
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

```

## Help

Common Issues:

Insufficient Tokens for Exchange or Transfer:
Ensure you have enough tokens in your balance before performing exchange or transfer operations. Use viewBalance to check your balance.

Invalid Recipient Address:
When transferring tokens, make sure the recipient address is valid and not the zero address.
## Authors

Shreya Kandpal
shreyakandpal17@gmail.com

## License

This project is licensed under the License - see the LICENSE.md file for details
