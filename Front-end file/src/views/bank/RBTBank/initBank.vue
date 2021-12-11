<template>
  <div class= "rbt-bank">
  <div class = "rainbow-panel">
    <div class = "title">
      INIT BANK
    </div>
    <div class="info">
      Init your bank setting
    </div>
    <div class="bank-form">
      <div class="item">
        <div class="title">
          USER
        </div>
        <div class="input">
          <input type="text" v-model="username"  placeholder="ADDRESS">
        </div>
      </div>
      <div class="item">
        <div class="title">
          TOKEN
        </div>
        <div class="input">
          <input type="text" v-model="tokenAddr"  placeholder="ADDRESS">
        </div>
      </div>
      <div class="item">
      <div class="title">
        TOKEN 721
      </div>
      <div class="input">
        <input type="text" v-model="nftAddr"  placeholder="ADDRESS">
      </div>
    </div>
  </div>
    <div class ="complete" @click="Complete">
      Complete
    </div>
    <span>your bank address :{{this.bankAddr}}</span>
  </div>
  </div>
</template>

<script>

export default {
  name: "initBank",

  data() {
        return {
      username:undefined,
      tokenAddr:undefined,
      nftAddr:undefined,
      form: {},
      a:0,
      bankAddr:undefined,
  }
},
  methods:{

    async Complete(){
       this.$store.dispatch("RbBankOrchestrator/init", this.username).then(res => {
        console.log(res)
      })
      await this.$store.dispatch("RbBankOrchestrator/input",{_rbt:this.tokenAddr,_deposits:this.nftAddr}).then(res =>{
        console.log(res)
      })
      await this.$store.dispatch("RbBankOrchestrator/bank").then(res=>{
         console.log(res)
         this.bankAddr =res
       })



      this.$store.dispatch("RBT/approve",{spender:this.bankAddr,amount:999999999999}).then(res=>{
        console.log(res)
      })

      this.$store.dispatch("RbtDeposit721/init",this.bankAddr).then(res=>{
        console.log(res)
      })

    }
  }
}
</script>

<style lang="scss" scoped>

  .rbt-bank{
    .rainbow-panel{
      margin: -60px auto 30px;
      width: 1200px;
      border-radius: 20px;
      background: #fff;
      padding: 30px;
    }
    .title{
      font-size: 30px;
      text-align: center;
      color: #333333;
      line-height: 45px;
    }
    .info{
      text-align: center;
      font-weight: 500;
      color: #666666;
      line-height: 24px;
    }
    .bank-form{
      .item{
        text-align: center;
        .title{
          font-size: 14px;
          font-weight: 700;
        }
        .input{
          input{
            padding-left: 10px;
            width: 480px;
            height: 50px;
            background: #ffffff;
            border: 1px solid #eaeaea;
            border-radius: 10px;
          }
        }
      }
    }
    .complete{
      text-align: center;
      width: 180px;
      height: 50px;
      background: linear-gradient(90deg,#12c2e9 0%, #c471ed 64%, #f64f59 100%);
      border: 1px solid #eaeaea;
      border-radius: 10px;
      cursor: pointer;
      margin: 20px auto;
      user-select: none;
      font-size: 20px;
      line-height: 50px;
      color: #fff;
    }
  }
</style>
