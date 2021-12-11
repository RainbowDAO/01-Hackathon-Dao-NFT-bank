<template>
  <div class="rain-header" :style="'background-image:'+ $route.path=='/cityNode'?'':'' + '!important'">
    <div class="rainbow-box" :style="dialogVisible ? 'z-index: 1000' :'z-index:10'">
      <span class = "logo">
        <a href="#initBank" @click="$router.push({name:'initBank'})">DAO NFT Bank</a>
      </span>

      <div class="rain-header-right">
        <headerNav v-model="$route.path"/>
        <ConnectWallet class="connect-wallet" @changeState="changeDialog"></ConnectWallet>
      </div>
    </div>
    <div class="item-nav-header">
      <strong class="nav-name">
        {{ navName }}
      </strong>
    </div>
  </div>
</template>

<script>
import headerImg from "@/views/static/img/img.png";
import ConnectWallet from "@/components/ConnectWallet";
import headerNav from "@/components/headerNav";


import {mapGetters} from "vuex";

export default {
  name: "RainbowHeader",
  components: {
     ConnectWallet,headerNav
  },
  data() {
    return {
      headerImg: headerImg,
      dialogVisible: false,
    }
  },
  methods: {
    changeDialog(onOff) {
      this.dialogVisible = onOff
    },
    loginOut() {
      this.$store.dispatch('app/loginOutWeb3')
    },
    chooseAction(command) {
      switch (command) {
        case 'register':
          this.$router.push('/register')
          break;
        case 'info':
          this.$router.push({name: 'my'})
          break;
      }
    },
    switchNav(path) {
      this.$router.push(path)
    },
    toggleSideBar() {
      this.$store.dispatch('app/toggleSideBar')
    },
    async showConnectList() {
      this.$store.commit("app/SET_SHOWCONNECT")
    },
  },

  created() {
    let ethereum = window.ethereum
    //切换账户
    ethereum.on('accountsChanged', () => {
      this.$store.dispatch('app/registerWeb3')
    });
    ethereum.on('disconnect', () => {
      console.log('disconnect')
    });
    ethereum.on('chainChanged', (chainId) => {
      this.$store.commit("app/SET_CHAIN", chainId)
      window.location.reload();
    });
    if (this.isConnected) {
      this.$store.dispatch('app/registerWeb3').then(() => {
        // this.$store.dispatch('rainbow/getMyUser',this.account)
      })
    }
  },
  watch: {
    account() {

    }
  },
  computed: {
    ...mapGetters([
      'isConnected',
      'account'
    ]),
    navArr() {
      return this.$store.state.app.navArr
    },
    navName() {
      return this.$store.state.app.navName
    },
    account() {
      return this.$store.state.app.account
    },
    sidebar() {
      return this.$store.state.app.sidebar
    },
    userId() {
      return this.$store.state.rainbow.userId
    }
  }
}
</script>

<style lang="scss" scoped>

.rain-header {
  font-family: Roboto, Roboto-Bold;
  background-image: url("../assets/img/header_bg.png");
  background-size: 100% 100%;
  .item-nav-header {
    width: 100%;
    height: 120px;
    .nav-name{
      color: #fff;
      font-size: 22px;
      position: relative;
      top: 50%;
      padding: 50px 0 0 50px;
    }
  }
.logo {
  padding-left: 150px;
  font-weight: bold;
  color: white;
}
  .rainbow-box {
    overflow: hidden;
    border-bottom: 1px solid #333;
    height: 50px;
    color: #666666;
    display: flex;
    padding-right: 2%;
    align-items: center;
    z-index: 10;
    justify-content: space-between;
    background-size: cover;
    position: relative;

    .left {
      display: flex;

      .nav-name {
        font-size: 16px;
        margin-left: 10px;
      }

      background-image: linear-gradient(270deg, #A519BB, #ec0b6a);
      -webkit-background-clip: text;
      -webkit-text-fill-color: transparent;


    }
  }

  .connect-wallet {
    ::v-deep .el-button {
      span {
        font-size: 10px;
        padding: 8px 0;
      }
    }
  }

  .button2 {
    height: 28px;
    width: 100px;
    margin-right: 10px;
    background: rgba(255, 255, 255, 0.10);
    border: 1px solid rgba(255, 255, 255, 0.25);
    font-size: 10px;

    .el-icon-arrow-down {
      float: right;
    }
  }

  .rain-header-right {
    display: flex;
    justify-content: space-around;
    align-items: center;

    .nav-list {
      height: 60px;
      min-width: 400px;
      display: flex;
      justify-content: flex-end;

      margin-right: 10px;

      .nav-item {
        line-height: 60px;
        height: 60px;
        margin: 0 10px;
        cursor: pointer;
        position: relative;

        &.active::after {
          content: '';
          position: absolute;
          width: 70%;
          height: 3px;
          bottom: 0;
          left: 15%;
          background: white;
          display: block;
        }
      }
    }
  }
}

</style>
