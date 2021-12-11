# 01-Hackathon-Dao-NFT-bank



## What is 'Dao-NFT-Bank'?


- "Dao-NFT-Bank" is part of the function of the bank established in rainbow city
  - You can get **RBD (NFT)** by staking **RBT** in the bank, and RBD can be **borrowed** and **the scene**
  - The trading market and NFT transfer market will make your RBD (NFT) token more flexible



## Submission

- Project Github Repository : https://github.com/RainbowDAO/01-Hackathon-Dao-NFT-bank.git
- Smart contracts (GitHub): https://github.com/RainbowDAO/01-Hackathon-Dao-NFT-bank/tree/main/contract
- Demo Website : [http://nftbank.rainbowdao.io/#/initBank](http://nftbank.rainbowdao.io/#/initBank)



## first of all ##

```
npm install
```



If you want to deploy the contract locally, first, you need to deploy RBT.sol to create an RBT token, and then create an RBD721 token. After the creation is complete, deploy the bank contract to call the INIT method to bind the newly created RBT and RBD721Token.
INIT bank address in RBD721, because only banks can issue RBD721, and finally LoanMarket.sol, TokenExchangeMarket.sol, you can bind your created tokens and NFTs according to INIT

enjoy it :canoe:



## :tada:By the way, the following is deployed on the kovan testnet and can be used directly ##

# 02-test-net-contract #

test-network: Kovan

Test/faucet: https://gitter.im/kovan-testnet/faucet#

## address ##

####  ERC20ORCHESTRATOR ####

0xcDee16288b9F2a811F02BA380956a4dC4B0A0105

#### RBBANKORCHESTRATOR ####

0x0C2636E6073745a1FF616D846107E0cEF0f49DA3

##### RAINBOW BANK #####

0x40D45f3142137f008A77bcDE2EB35Dc7347aba5c

#### RBT ####

0xC18Ea0101bA60F30E26936501149286D133E28a6

#### RBTDEPOSIT721 ####

0xc4886C90f8Bb0EC4f486af525Ee9e4CD24A1dB52

#### loanMarket ####

0xB92aD9F520701e0CE9e4b14edA350fb6B9D5FD62

#### tokenExchangeMarket ####

0xAecaf1eE139FDF88be5C8E3eB50E001C48BfA81f
