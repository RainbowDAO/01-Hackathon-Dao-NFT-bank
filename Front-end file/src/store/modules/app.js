import getWeb3 from "@/utils/getWeb3";

const state = {
    web3:null,
    account:'',
    isConnected:false,
    chainId: 666,
    sidebar: {
        opened: true,
        withoutAnimation: false
    },
    navArr:[],//头部菜单
    navName:'',
}
const mutations = {
    SET_ACCOUNT(state, account){
        state.account = account
    },
    SET_ISCONNECT(state, isConnect){
        state.isConnected = isConnect
    },
    SET_NAVARR: (state, arr) => {
        state.navArr = arr
    },
    SET_NAVNAME: (state, name) => {
        state.navName = name
    },
    // 菜单状态
    TOGGLE_SIDEBAR: state => {
        state.sidebar.opened = !state.sidebar.opened
        state.sidebar.withoutAnimation = false
    },
    //  注册web3
    SET_WEB3INSTANCE (state, web3Instance) {
        state.web3 = web3Instance
        web3Instance?state.isConnected = true:state.isConnected = false
    },
    SET_CHAINID: (state, chainId) => {
        if (!chainId) {
            localStorage.removeItem('chainId')
            return;
        }
        chainId = parseInt(chainId)
        state.chainId = chainId ? chainId : null
        localStorage.setItem('chainId', chainId)
    },
    SET_BALANCE: (state, balance) => {
        state.balance = parseInt(balance, 10)
        localStorage.setItem('balance', balance)
    },
}
const actions = {
    // 菜单状态
    toggleSideBar({ commit }) {
        commit('TOGGLE_SIDEBAR')
    },
    //注册web3
    async registerWeb3 ({commit},provider) {
        return new Promise(resolve => {
            getWeb3(provider).then(result => {
                commit('SET_WEB3INSTANCE', result.web3Instance.web3())
                commit('SET_ACCOUNT', result.account)
                commit('SET_CHAINID', result.networkId)
                commit('SET_BALANCE', result.balance)
                commit("SET_ISCONNECT",true)
                // dispatch("rainbow/getMyUser",{},{root:true})
                // //签名
                // const web3 = result.web3Instance.web3()
                // const createDelegateBySigMessage = (compAddress, name="imp", chainId = 1) => {
                //     const types = {
                //         EIP712Domain: [
                //             { name: 'name', type: 'string' },
                //             { name: 'chainId', type: 'uint256' },
                //             { name: 'verifyingContract', type: 'address' },
                //         ],
                //         Hello: [
                //             { name: 'name', type: 'string' },
                //         ]
                //     };
                //     const primaryType = 'Hello';
                //     const domain = { name: 'Compound', chainId, verifyingContract: compAddress };
                //     const message = { contents: 'Hello, Rainbow!',name };
                //     return JSON.stringify({ types, primaryType, domain, message });
                // };
                // const msgParams = createDelegateBySigMessage("0x844BE1C5B2181BeBb54CD0164A91F35397f31c30", "imp", 666);
                //
                //
                // web3.currentProvider.sendAsync({
                //     method: 'eth_signTypedData_v4',
                //     params: [ result.account, msgParams],
                //     from: result.account,
                // }, function (err, res) {
                //     if (err) return console.dir(err);
                //     if (res.error) {
                //         alert(res.error.message);
                //     }
                //     if (res.error) return console.error('ERROR', res);
                //     console.log('TYPED SIGNED:' + JSON.stringify(res.result));
                //     console.log(sigUtil)
                //     const recovered = sigUtil.recoverTypedSignature_v4({
                //         data: JSON.parse(msgParams),
                //         sig: res.result,
                //     });
                //     console.log(recovered)
                //     // if (
                //     //     ethUtil.toChecksumAddress(recovered) === ethUtil.toChecksumAddress(from)
                //     // ) {
                //     //     alert('Successfully recovered signer as ' + from);
                //     // } else {
                //     //     alert(
                //     //         'Failed to verify signer when comparing ' + result + ' to ' + from
                //     //     );
                //     // }
                // })
                // //签名结束
                resolve(result)
            }).catch(e => {
                console.log('error in action registerWeb3', e)
            })
        })
    },
}
export default {
    namespaced: true,
    state,
    mutations,
    actions
}
