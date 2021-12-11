import Web3 from 'web3'

let curProvider = null

function getWeb3(provider) {
    return new Promise(function (resolve, reject) {
        // Check for injected web3 (mist/metamask)
        let web3js = window.ethereum
        if (provider) {
            curProvider = provider
            let web3 = new Web3(provider)
            console.log(web3)
            resolve({
                web3() {
                    return web3
                }
            })
        } else if (typeof web3js !== 'undefined') {
            let web3 = new Web3(web3js)
            curProvider = web3js

            //   curProvider.sendAsync({
            //     method: 'close',
            //     params: {
            //         type: 'ERC20',
            //         options: {
            //             address: '0xb60e8dd61c5d32be8058bb8eb970870f07233155',
            //             symbol: 'FOO',
            //             decimals: 18,
            //             image: 'https://foo.io/token-image.svg',
            //         },
            //     },
            // })

            resolve({
                web3() {
                    return web3
                }
            })
        } else {
            reject(new Error('Unable to connect'))
        }
    }).then(result => {
        return new Promise(function (resolve) {
            const web3 = result.web3()
            let webRes = {
                isInjected: false,
                web3Instance: result,
                networkId: curProvider.networkId,
                account: curProvider.accounts && curProvider.accounts.length > 0 ? curProvider.accounts[0] : null
            }
            web3.eth.net.getId().then(netWarkId => {
                webRes.networkId = netWarkId
                web3.eth.getCoinbase().then(coinbase => {
                    coinbase ? webRes.account = coinbase : ''
                    resolve(webRes)
                })
            })
        })
    })
}

export default getWeb3
