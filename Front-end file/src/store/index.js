import Vue from 'vue'
import Vuex from 'vuex'
import getters from './getters'
import app from "./modules/app";


import RbBankOrchestrator from "./modules/abisMethods/RbBankOrchestrator";
import RBT from "./modules/abisMethods/RBT"
import RbtDeposit721 from "./modules/abisMethods/RbtDeposit721";
import TokenExchangeMarket from "./modules/abisMethods/TokenExchangeMarket";
import LoanMarket from "./modules/abisMethods/LoanMarket";
import RainbowBank from "./modules/abisMethods/RainbowBank";



Vue.use(Vuex)

export default new Vuex.Store({
  getters,
  modules: {
    app,

    RbtDeposit721,
    RBT,
    RbBankOrchestrator,
    TokenExchangeMarket,
    LoanMarket,
    RainbowBank,
  }
})
