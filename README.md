
# Submission for the DAO Global Hackathon 2021


### Project name

Dao governance token lock bank and NFT incentive system

### Team Name

Rainbowcity Foundation

### Payment Address

0x140Db6C3947E1AC8645be81E86C619189cfd7621 (eth)

### Submission links

- Website: http://nftbank.rainbowdao.io/
- Hackathon: https://www.rainbowdao.io/Hackathon
- GitHub repository :https://github.com/RainbowDAO/01-Hackathon-Dao-NFT-bank
- Smart contracts (GitHub): https://github.com/RainbowDAO/01-Hackathon-Dao-NFT-bank/tree/main/contract
- Frontend code (GitHub):https://github.com/RainbowDAO/01-Hackathon-Dao-NFT-bank/tree/main/Front-end%20file
- PIcture (GitHub): https://github.com/RainbowDAO/01-Hackathon-Dao-NFT-bank/tree/main/pic

### Recorded video demo

https://youtu.be/COZ6B5rGLjw


[![IMAGE ALT TEXT](https://raw.githubusercontent.com/RainbowDAO/01-Hackathon-Dao-NFT-bank/main/pic/202.png)](https://youtu.be/COZ6B5rGLjw "ColourBox")

### Date when team began working on the project

- November 2021

### contact   Person

- RainbowKun
- Email:  rainbowcitydao@gmail.com



## Short pitch



  - Solution: 



Our system is mainly a governance token lock-up bank and NFT incentive system serving the DAO organization. The main function is to lock the governance tokens, and the corresponding NFT tokens can be rewarded according to the lock time and amount. 

It is equivalent to depositing tokens in a bank, and the rewarded NFT is equivalent to a deposit certificate. According to the NFT deposit certificate, the corresponding governance token can be withdrawn after expiration.

 At the same time, in order to allow deposit agents to obtain a certain degree of liquidity. We have also developed the mortgage loan market and the NFT transfer market for NFT deposit certificates. 

The mortgage loan market can mortgage NFT deposit certificates and then borrow from the market. In the NFT transfer market, the corresponding NFT certificate can be transferred directly in the market to obtain liquidity funds.



  - Pain: 

Our product mainly solves two pain points:

1. Lock the liquidity of governance tokens through lock-up bank, reduce the circulation of tokens in the secondary market, build a stronger community consensus, and stabilize the price of tokens;

2. After the governance token is locked into the bank, the locker needs a certain amount of liquidity. He can choose to use the NFT deposit certificate for mortgage loans in the mortgage loan market, or directly perform NFT transfer in the transfer market. 

Our NFT certificate here contains token deposit information, which belongs to the direct application of NFT in the financial field.



  - Target audience: 


The target audience of our product is mainly various DAO organizations that have issued governance tokens. Meet their needs for governance token management. Lock the liquidity of the governance tokens through the lock-up bank, and at the same time reward the NFT deposit certificate as the basis for lock-up.

This product is suitable for all types of DAO organizations, whether it is a large DAO organization or a small DAO organization. Everyone can apply it to actual governance. And it is possible to formulate different lock-up policies at different stages and reward different NFT tokens. Its function is very practical for DAO organization.






## Documentation on how to run the project



- Smart contracts docs: https://github.com/RainbowDAO/01-Hackathon-Dao-NFT-bank/tree/main/contract#readme

- Frontend docs: https://github.com/RainbowDAO/01-Hackathon-Dao-NFT-bank/tree/main/Front-end%20file#readme

"Dao-NFT-Bank" is part of the function of the bank established in Rainbowcity.

You can get **RBD (NFT)** by staking **RBT** in the bank, and RBD can be Mortgage loans and direct transfers.

The trading market and NFT transfer market will make your RBD (NFT) token more flexible.



- first of all    npm install

If you want to deploy the contract locally, first, you need to deploy RBT.sol to create an RBT token, and then create an RBD721 token. 

After the creation is complete, deploy the bank contract to call the INIT method to bind the newly created RBT and RBD721Token.

INIT bank address in RBD721, because only banks can issue RBD721, and finally LoanMarket.sol, TokenExchangeMarket.sol, 

you can bind your created tokens and NFTs according to INIT



By the way, the following is deployed on the kovan testnet and can be used directly



test-net-contract

test-network: Kovan

Test/faucet: https://gitter.im/kovan-testnet/faucet#



- address



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






## Project social media: 


Twitter:    https://twitter.com/RainbowcityDAO

Discord     https://discord.gg/vbnvFEeYRr   

Telegram: https://t.me/RainbowDAO

Medium:   https://medium.com/rainbowcity

Github:    https://github.com/RainbowDAO

Email： Rainbowcitydao@gmail.com

RainbowDAO website ：http://www.rainbowdao.io

Rainbowcity website ：https://www.rainbowcity.io






##  Product UI introduction



### 1. Initialize the entire contract and set basic information. Set the management contract address.




![image](https://raw.githubusercontent.com/RainbowDAO/01-Hackathon-Dao-NFT-bank/main/pic/1.png)



### 2.RBD bank page, the RBD  token I own..



![image](https://raw.githubusercontent.com/RainbowDAO/01-Hackathon-Dao-NFT-bank/main/pic/2.png)



### 3.Deposit RBD token into NFT bank.



![image](https://raw.githubusercontent.com/RainbowDAO/01-Hackathon-Dao-NFT-bank/main/pic/3.png)



### 4.My loan information page. I can mortgage my NFT and then mortgage the loan.



![image](https://raw.githubusercontent.com/RainbowDAO/01-Hackathon-Dao-NFT-bank/main/pic/4.png)



### 5.My loan order information.



![image](https://raw.githubusercontent.com/RainbowDAO/01-Hackathon-Dao-NFT-bank/main/pic/5.png)



### 6.My loan order information.



![image](https://raw.githubusercontent.com/RainbowDAO/01-Hackathon-Dao-NFT-bank/main/pic/6.png)


### 7.I lent the order information to someone else.




![image](https://raw.githubusercontent.com/RainbowDAO/01-Hackathon-Dao-NFT-bank/main/pic/7.png)


### 8.NFT token mortgage loan market.




![image](https://raw.githubusercontent.com/RainbowDAO/01-Hackathon-Dao-NFT-bank/main/pic/8.png)


### 9.NFT token transfer trading market.




![image](https://raw.githubusercontent.com/RainbowDAO/01-Hackathon-Dao-NFT-bank/main/pic/9.png)




### 10.NFT token transfer trading market.


![image](https://raw.githubusercontent.com/RainbowDAO/01-Hackathon-Dao-NFT-bank/main/pic/10.png)


### 11.NFT token transfer trading market.




![image](https://raw.githubusercontent.com/RainbowDAO/01-Hackathon-Dao-NFT-bank/main/pic/11.png)


### 12.NFT token transfer trading market.




![image](https://raw.githubusercontent.com/RainbowDAO/01-Hackathon-Dao-NFT-bank/main/pic/12.png)









