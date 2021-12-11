import Vue from 'vue'
import App from './App.vue'
import ElementUI from 'element-ui';
import 'element-ui/lib/theme-chalk/index.css';
import store from './store'
import router from './router'
import animated from 'animate.css'
import Moment from 'moment'
import {formatNumber, formatNumberToB,formatNumberToM,formatNumberTo} from "@/utils/numberUtils"
import RainbowPanel from "@/components/RainbowPanel"
import TableItem from "@/components/TableItem";
import SimplePanel from "@/components/SimplePanel";
import SingleNav from "@/components/SingleNav";
import {Decimal} from "decimal.js"
Vue.config.productionTip = false
Vue.use(animated)
Vue.use(ElementUI);


// 定义全局时间戳过滤器
Vue.filter('formatDate', function(value) {
  return Moment(value).format('YYYY-MM-DD')
})
Vue.filter('formatTime', function(value) {
  return Moment(value).format('YYYY-MM-DD HH:mm:ss')
})
Vue.filter('formatNumber',value=>{
  return formatNumber(value)
})
Vue.filter('formatNumberToB',value=>{
  return formatNumberToB(value)
})
Vue.filter('formatNumberToM',value=>{
  return formatNumberToM(value)
})
Vue.filter('formatNumberTo',value=>{
  return formatNumberTo(value)
})
Vue.prototype.$decimal = Decimal
Vue.component('SingleNav',SingleNav)
Vue.component('RainbowPanel',RainbowPanel)
Vue.component('TableItem',TableItem)
Vue.component('SimplePanel',SimplePanel)
new Vue({
  router,
  store,
  render: h => h(App)
}).$mount('#app')
