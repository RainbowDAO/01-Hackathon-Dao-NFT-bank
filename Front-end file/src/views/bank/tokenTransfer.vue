<template>
  <!--  令牌转让市场-->
  <div class="tokenTransfer">
    <!-- <singleNav :nav-list="navList" v-model="activeIndex"></singleNav> -->
    <RainbowPanel v-show="activeIndex==0">
      <template v-slot:name>
     <div style="display: flex;justify-content: space-between;">
          <span style="font-size: 18px;"> MY RBT-deposit
            <span class="erc-info">ERC721</span>
          </span>
          <el-button @click="isShowRecord = true" class="button-view"
                     size="mini">
            Expired
          </el-button>
        </div>
      </template>
      <template v-slot:content>
        <div v-for="item in bankTokenArr" :key="item.index">
          <TableItem  :tableData="item" operateRName="withdraw money" @operateRClick="operateRClick"/>
        </div>
      </template>
      
    </RainbowPanel>
    <RainbowPanel v-show="activeIndex==1">
      <template v-slot:name>
        Token transfer market
      </template>
      <template v-slot:content>
        <el-table :data="marketTokenArr.slice((currentPage-1)*pagesize,currentPage*pagesize)">
          <el-table-column
              label="#"
              type="index"
          >
          </el-table-column>
          <el-table-column
              prop="firstOwnerName"
              label="Initial adult"
          >
          </el-table-column>
          <el-table-column
              label="Generation time">
            <div slot-scope="scope">
              {{ new Date(scope.row.creationTime * 1000) | formatDate }}
            </div>
          </el-table-column>
          <el-table-column
              label="Expiration time">
            <div slot-scope="scope">
              {{ new Date(scope.row.expireTime * 1000) | formatDate }}
            </div>
          </el-table-column>
          <el-table-column
              prop="expireTime"
              label="Days Remaining">
            <div slot-scope="scope">
              {{ parseInt((scope.row.expireTime - scope.row.creationTime) / 86400) }}
            </div>
          </el-table-column>
          <el-table-column
              prop="mortgageAmount"
              label="Number of RBTS included"
          >
            <div slot-scope="scope">
              {{ scope.row.mortgageAmount | formatNumberTo }}
            </div>
          </el-table-column>
          <el-table-column
              label="operation"
          >
            <template slot-scope="scope">
              <el-button size="mini" class="button1" @click="buyDeposit(scope.row)">
                purchase
              </el-button>
            </template>
          </el-table-column>
        </el-table>
        <el-pagination
           @size-change="handleSizeChange"
            @current-change="handleCurrentChange"
            :current-page="currentPage"
            :page-sizes="[5, 10, 20, 40]"
            :page-size="pagesize"
            layout="total, sizes, prev, pager, next, jumper"
            :total="marketTokenArr.length">
        </el-pagination>
      </template>
    </RainbowPanel>
    <el-dialog
        title="Issue sale token information"
        :visible.sync="isShowPublish"
        width="400px"
    >
      <div class="order">
        <div class="r-intro-box">
          <div>
            <span>number</span>
            <span>{{ sellToken.tokenId }}</span>
          </div>
          <div>
            <span>Generation date</span>
            <span> {{ new Date(sellToken.creationTime * 1000) | formatDate }}</span>
          </div>
          <div>
            <span>Expiration time</span>
            <span> {{ new Date(sellToken.expireTime * 1000) | formatDate }}</span>
          </div>
          <div>
            <span>Days Remaining</span>
            <span>{{ parseInt((sellToken.expireTime - sellToken.creationTime) / 86400) }}</span>
          </div>
          <div>
            <span>Number of RBTS included</span>
            <span> {{ sellToken.mortgageAmount |formatNumber }}</span>
          </div>
          <div>
            <span>Including RBT value</span>
            <span> ${{ includeValue |formatNumber }}</span>
          </div>
        </div>
        <div class="price-box">
          <span>Sale amount</span>
          <div class="input-box">
            <el-input class="input2" size="mini" v-model="orderForm.amount"></el-input>
            <ChooseToken @changeToken="changeToken"></ChooseToken>
          </div>
        </div>

        <div class="intro">
          After the sale is successful, you will be deducted <span class="r-p-color">5%</span>Platform service fee
        </div>
        <div class="operating">
          <el-button size="small" class="button3" @click="isShowPublish=false">Cancel</el-button>
          <el-button size="small " class="button1" @click="subOrder">Confirm sale</el-button>
        </div>
      </div>
    </el-dialog>
    <el-dialog
        title="Purchase token confirmation"
        :visible.sync="isShowBuy"
        width="400px"
    >
      <div class="order">
        <div class="r-intro-box">
          <div>
            <span>number</span>
            <span>{{ buyToken.tokenId }}</span>
          </div>
          <div>
            <span>Generation date</span>
            <span> {{ new Date(buyToken.creationTime * 1000) | formatDate }}</span>
          </div>
          <div>
            <span>Expiration time</span>
            <span> {{ new Date(buyToken.expireTime * 1000) | formatDate }}</span>
          </div>
          <div>
            <span>Days Remaining</span>
            <span>{{ parseInt((buyToken.expireTime - buyToken.creationTime) / 86400) }}</span>
          </div>
          <div>
            <span>Number of RBTS included</span>
            <span> {{ buyToken.mortgageAmount |formatNumberTo }}</span>
          </div>
          <div>
            <span>Including RBT value</span>
            <span> ${{  buyToken.mortgageAmount |formatNumberTo }}</span>
          </div>
        </div>
        <div class="operating">
          <el-button size="small" class="button3" @click="isShowBuy=false">Cancel</el-button>
          <el-button size="small " class="button1" @click="subBuy">Confirm purchase</el-button>
        </div>
      </div>
    </el-dialog>
  </div>
</template>

<script>
import {mapGetters} from "vuex";
import Moment from 'moment'

export default {
  name: "tokenTransfer",
  data() {
    return {
      currentPage:1,
      pagesize:5,
      orderForm: {},
      sellToken: {},
      buyToken: {},
      isShowPublish: false,
      isShowBuy:false,
      activeIndex: 0,
      navList: [{
        name: 'My token',
        index: 0
      }, {
        name: 'Transfer market',
        index: 1
      }],
    }
  },
  methods: {
    handleSizeChange(val) {
      this.pagesize = val;
    },
    handleCurrentChange(val) {
      this.currentPage = val;
    },
    sellDeposit(token) {
      this.sellToken = token
      this.isShowPublish = true
    },
    buyDeposit(token) {
      this.buyToken = token
      this.isShowBuy= true
    },
    changeToken(param) {
      console.log(param)
    },
    subOrder() {
       this.$store.dispatch("RbtDeposit721/approve",{
            to:"0x4D64eDac49B026aE95765DBD3830C582c693AEe4",
            tokenId:this.borrowToken.tokenId
          }).then(() => {
            this.publish();
          }).catch(() => {
            this.isLoading = false
            this.$message({
              type: 'error',
              message: 'privilege grant failed'
            })
          })
          return
        },
     operateRClick(tableData){
      this.release(tableData.nameObj.data)
    },
      publish(){
        this.isLoading = false
        this.$store.dispatch("transferMarket/publish", {
          amount: this.orderForm.amount,
          tokenId: this.sellToken.tokenId
        }).then(res => {
          console.log(res);
          this.$message.success("Published successfully")
          this.orderForm = {}
          this.isShowPublish = false
          this.getData()
        }).catch(err => {
          console.log(err)
          this.$message.error("Publishing failed" + err)
          this.orderForm = {}
        })
      },
      subBuy(){ //确认购买{from,id,bid,_types
        this.$store.dispatch("TokenExchangeMarket/bidToken",{
          from:"0x4D64eDac49B026aE95765DBD3830C582c693AEe4",
          id:1,
          bid:1000,
          _types:"0x4D64eDac49B026aE95765DBD3830C582c693AEe4"}).then(res=>{
          console.log(res)
          this.$message.success("Purchase successful")
        }).catch((err)=>{
          this.$message.error("Purchase failed" + err)
        })
      },
      getData() {
        if(!this.isConnected)
        this.$store.dispatch("RbtDeposit721/tokenMetadata",1)
        this.$store.dispatch("TokenExchangeMarket/sellToken",{
          from:"0x4D64eDac49B026aE95765DBD3830C582c693AEe4",
          tokenId:1,
          sellPrice:1000,
          _types:"0x4D64eDac49B026aE95765DBD3830C582c693AEe4"
        })
      },
    },
    
  
  created() {
       this.getData()
  },
  
  watch: {
    account() {
      this.getData()
    },
  },
 computed: {
    ...mapGetters([
      'isConnected',
      'account'
    ]),
    bankTokenArr() {
      let arr = []
      this.$store.state.rainbowBank.records.forEach((item,index)=>{
        arr.push({
          index:index+1,
          nameObj:{ 
            title:"Token number",
            data:item.tokenId
          }, 
          infoArr:[
            {
              title:"Lock type",
              data:item.month + "Months"
            },
             {
              title:"Number of RBTS included",
              data:item.amount
            },
          ],
          detailArr:[

            {
              title:"Current holder",
              data: item.depositor.substr(0,3) + '...'+ item.depositor.substr(item.depositor.length - 3,3)
            },
            {
              title:"Generation time",
              data: Moment(item.created_at).format('YYYY-MM-DD')
            },
            {
              title:"Expiration time",
              data: Moment(item.updated_at).format('YYYY-MM-DD')
            },
          ],
          withdrawa:[
            {
              address:item.depositor,
              tokenid:item.tokenId

            }
          ]
        })
      })
     return arr
    },

    marketTokenArr() {
      let arr = []
      this.$store.state.transferMarket.marketTokenArr.forEach(item => {
        for (let i = 0; i < this.$store.state.rbtDeposit.bankTokenArr.length; i++) {
          let token = this.$store.state.rbtDeposit.bankTokenArr[i]
          if (token.tokenId == item.tokenId) {
            arr.push({
              ...token,
              ...item,
            })
          }
        }
      })
      return arr
    },
    includeValue() {
      return this.sellToken.mortgageAmount
    },
  }
}
</script>

<style lang="scss" scoped>
.tokenTransfer {
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
