## Interactive Public Monuments
Make the city interactive and raise money for public infrastructure at the same time!

This smart contract can trigger events in the real world. For example:
- Set the color of the lights at a city fountain
- Display a text at an interactive display
- Turn on the lights in the Christmas tree
- Turn on or change the color of the lights of a city monument

Users have to pay to trigger these events. Users can send the needed funds to the smart contract. Only after the funds are received, they can trigger the interactive event.

The City is the owner of the smart contract. They can withdraw the used user funds. These funds can then be used to pay for maintenance of the monuments or other govement spending.

## Tech Setup
### Smart Contract Functions
- `deposit`: Deposit Ethereum to this contract
- `depositsOf(address payee)`: Check the deposited value of the given address
- `withdraw(uint amount)`: Users can withdraw unused funds and the owner can withdraw funds that have been payed
- `setColor(string memory color)`: Sets the color of the lights by calling a Web API using Chainlink. Depending on the configured URL, this can also trigger other real world functions.

- 
## Usage
- Deploy `interactive.sol` to the network:
Deployed to the Kovan test network: `0x4987Fce831147CbE6D6b6d5a4bBDeCDc2E163971`
- As the owner, transfer `LINK` to the contract. It costs 0.1 LINK to do a web request
- As a user, fund the contract with `ETH` using the `deposit` function. It costs 0.01 Eth to trigger an event
- As a user, call the `setColor` function to change the color of the monument
- See the log of webhook calls at: https://webhook.site/#!/ac12f6e8-f06c-445b-8941-b62b6527427e/0f8bee2a-b6c2-4bec-9fde-d0305658df69/1

# Chainlink Spring Hackathon 2021
This project was created for the [Chainlink Spring Hackathon 2021](https://chain.link/hackathon) ([DevPost](https://chainlink-2021.devpost.com))

Competes in the GovTech category: https://blog.chain.link/introducing-the-govtech-prize-at-the-chainlink-virtual-hackathon/

## TODO
- [ ] Webpage to interact with the smart contract


