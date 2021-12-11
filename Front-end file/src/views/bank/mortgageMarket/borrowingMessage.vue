<template>
  <div class="borrowingMessage">
    <RainbowPanel  v-loading="loading">
      <template v-slot:name>Publish borrowing information</template>
      <template v-slot:content>
        <div v-for="(item,index) in camArr" :key="index">
          <TableItem :tableData="item" operate-g-name="SELL"
                     @operateGClick="isShowBorrow=true;sellForm.tokenId = item.index" operate-r-name="BORROW"
                     @operateRClick="mortTap(item)"/>

        </div>
        <div class="no-data" v-show="camArr.length==0">
          <img src="../../../assets/img/no-data.png" alt="">
        </div>
      </template>
    </RainbowPanel>
    <el-dialog
        title="Borrow Message"
        :visible.sync="isShowBorrow"
        width="400px"
    >
      <div class="order">
        <div class="price-box">
          <span>from</span>
          {{sellForm.from}}
        </div>
        <div class="price-box">
          <span>tokenId</span>
          <div class="input-box">
            {{sellForm.tokenId}}
          </div>
        </div>
        <div class="price-box">
          <span>sellPrice</span>
          <div class="input-box">
            <el-input class="input2" size="mini" v-model="sellForm.sellPrice"></el-input>
          </div>
        </div>
        <div class="price-box">
          <span>_types</span>
          <div class="input-box">
            <el-input class="input2" size="mini" v-model="sellForm._types"></el-input>
          </div>
        </div>
        <div class="operating">
          <el-button size="small" class="button3" @click="isShowBorrow=false">Cancel</el-button>
          <el-button size="small " class="button1" @click="sellToken">Submit</el-button>
        </div>
      </div>
    </el-dialog>
    <el-dialog
        title="Borrow Message"
        :visible.sync="mortgageMarketDialog"
        width="400px"
    >
      <div class="order">
        <div class="price-box">
          <span>tokenId</span>
          {{mortForm.tokenId}}

        </div>
        <div class="price-box">
          <span>amount</span>
          <div class="input-box">
            <el-input class="input2" size="mini" v-model="mortForm.amount"></el-input>
            $
          </div>
        </div>
        <div class="price-box">
          <span>day</span>
          <div class="input-box">
            <el-input class="input2" size="mini" v-model="mortForm.day"></el-input>
          </div>
        </div>
        <div class="price-box">
          <span>dayRate</span>
          <div class="input-box">
            <el-input class="input2" size="mini" v-model="mortForm.dayRate"></el-input>
          </div>
        </div>
        <div class="operating">
          <el-button size="small" class="button3" @click="mortgageMarketDialog=false">Cancel</el-button>
          <el-button size="small " class="button1" @click="mortgageMarket">Submit</el-button>
        </div>
      </div>
    </el-dialog>
  </div>
</template>

<script>
import {mapGetters} from "vuex";
import moment from "moment";
import TableItem from "../../../components/TableItem";

export default {
  name: "borrowingMessage",
  components: {TableItem},

  data() {
    return {
      loading:false,
      borrowToken: {},
      isShowBorrow: false,
      mortgageMarketDialog:false,
      orderForm: {},
      mortForm:{},
      sellForm:{
      },
      currentData: {},
      tokenAmount: 0,
      tokenHolder: undefined,
      currentObj: {},
      tableData: [],
      camArr: []
    }
  },
  methods: {
    mortTap(item){
      this.mortgageMarketDialog = true
      this.mortForm.tokenId=item.index
    },
    mortgageMarket(){
      //tokenId,amount,day,dayRate
      this.$store.dispatch("LoanMarket/mortgageMarket", {
        ...this.mortForm
      }).then(res=>{
        console.log(res)
      })
    },
    async sellToken(){
      // from,tokenId,sellPrice,_types
      await this.$store.dispatch("TokenExchangeMarket/sellToken", {
       ...this.sellForm
      }).then(res=>{
        console.log(res)
      })
    },

    async initData() {
      if (!this.isConnected) {
        return;
      }
      this.sellForm.from = this.account
      await this.$store.dispatch("RbtDeposit721/totalSupply").then(async length => {
        this.loading = true
        for (let i = 0;i<length;i++){
          let tempObj = {}
          tempObj.tokenId = i + 1
          await this.$store.dispatch("RbtDeposit721/ownerOf", i+1).then(async res => {
            tempObj.ownerOf = res
            if(res.toUpperCase() == this.account.toUpperCase()){
              await this.$store.dispatch("RbtDeposit721/amount", i+1).then(res => {
                tempObj.amount = res
              })

              await this.$store.dispatch("RbtDeposit721/tokenMetadata", i+1).then(res => {
                tempObj.tokenMetadata = moment(parseInt(res.startTime) * 1000).format('YYYY/MM/DD hh:mm:ss');
              })
              this.tableData.push(tempObj)
            }
          })
        }
        this.loading=false
      })

    },
    changeToken(param) {
      console.log(param)
    },

  },

  created() {
    if (this.isConnected) {
      this.initData()
    }
  },

  watch: {
    account() {
      this.initData()
    },
    tableData() {
      let arr = []
      this.tableData.forEach((item, index) => {
        let obj = {
          index: index + 1,
          nameObj: {
            title: "account",
          },
          infoArr: [
            {
              title: "amount",
              data: item.amount
            },
            {
              title: "ownerOf",
              data: item.ownerOf
            },
            {
              title: "tokenMetadata",
              data: item.tokenMetadata
            },
          ],
          detailArr: [],

        }
        arr.push(obj)
      })
      this.camArr =arr
    }

  },
  computed: {
    ...mapGetters([
      'isConnected',
      'account'
    ]),
  }
}
</script>

<style lang="scss" scoped>
.borrowingMessage {
  .my-borrow {
    margin-top: 20px;
  }

  .order {
    .tip {
      display: flex;
      justify-content: space-between;

      span:first-child {
        color: #736DFF;
      }
    }

    > div {
      margin-top: 10px;
    }

    .price-box {
      width: 380px;
      background: #f8f8f8;
      border: 1px solid #eaeaea;
      border-radius: 11px;
      display: flex;
      justify-content: space-between;
      align-items: center;
      padding: 6px 20px;

      .input-box {
        width: 260px;
        height: 30px;
        align-items: center;
        padding: 0 10px;
        background: #ffffff;
        border: 1px solid #eaeaea;
        border-radius: 6px;
        display: flex;

        ::v-deep .el-input__inner {
          padding: 0 0;
        }
      }
    }

    .operating {
      display: flex;
      justify-content: space-between;

      .el-button {
        width: 150px;
      }
    }
  }
}
</style>
