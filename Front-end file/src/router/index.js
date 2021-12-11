import Vue from 'vue'
import VueRouter from 'vue-router'
import layout from "@/views/layout/layout";

Vue.use(VueRouter)

const routes = [

    {
        path: '/404',
        component: () => import('@/views/errorPage/404'),
        hidden: true
    },
    {
        path: '/',
        component: layout,
        redirect: '/initBank',

        children: [
            //    bank
            {
                path:'/initBank',
                name:'initBank',
                component: () => import('../views/bank/RBTBank/initBank')
            },
            {
                path: '/tokenTransfer',
                name: 'tokenTransfer',
                component: () => import('../views/bank/tokenTransfer')
            }, {
                path: '/borrowingMessage',
                name: 'borrowingMessage',
                component: () => import('../views/bank/mortgageMarket/borrowingMessage')
            }, {
                path: '/RBTBank',
                name: 'RBTBank',
                component: () => import('../views/bank/RBTBank/rbtBank')
            },{
                path: '/TokenAssignment',
                name: 'TokenAssignment',
                component: () => import('../views/bank/mortgageMarket/borrowingMarket')
            },
        ]
    }
]
const router = new VueRouter({
    routes
})

export default router
