<template>
  <div class="hasBorrow">
    <RainbowPanel>
      <template v-slot:name>
        Orders I have lent
      </template>
      <template v-slot:content>
         <div class="release-box">
          <el-table :data="bankTokenArr">
            <el-table-column label="Token number">
              <template slot-scope="scope">
                <span>{{ scope.row.tokenId }}</span>
              </template>
            </el-table-column>
            <el-table-column label="Initial adult">
              <template slot-scope="scope">
                <span>{{ scope.row.firstOwnerName }}</span>
              </template>
            </el-table-column>
            <el-table-column label="Current holder">
              <template slot-scope="scope">
                <span>{{ scope.row.ownerName }}</span>
              </template>
            </el-table-column>

            <el-table-column prop="ownerName" label="Lock type"></el-table-column>
            <el-table-column
                prop="mortgageMonth"
                label="Pledge period"
            >
            </el-table-column>
            <el-table-column
                prop="mortgageAmount"
                label="Number of RBTS included"
                width="100px;"
            >
              <div slot-scope="scope">
                {{ scope.row.mortgageAmount |formatNumberTo }}
              </div>
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
            <el-table-column label="release">
              <template slot-scope="scope">
                <el-button size="mini" @click="release(scope.row)" class="button1">release</el-button>
              </template>
            </el-table-column>
          </el-table>
        </div>
        <div v-for="item in bankTokenArr" :key="item.index">
             <TableItem :tableData="item" operateRName="Liquidation" operateGName="Re borrowing" @operateRClick="operateRClick"   @operateGClick="operateGClick"/>
          </div>
      </template>
    </RainbowPanel>
    <RainbowPanel class="repayment">
      <template v-slot:name>
        Repayment order
      </template>
      <template v-slot:content>
       <div class="release-box">
          <el-table :data="bankTokenArr">
          </el-table>
        </div>
        <div v-for="item in bankTokenArr" :key="item.index">
             <TableItem :tableData="item"  @operateRClick="operateRClick"/>
          </div>
      </template>
    </RainbowPanel>
  </div>
</template>

<script>
import {mapGetters} from "vuex";
import Moment from 'moment';

export default {
  name: "hasBorrow",
  data(){
    return {
    }
  },
  created() {
    if (this.isConnected) {
      // this.getData()
    }
  },
  methods:{
    operateGClick(){},
     operateRClick(tableData) {
      this.liquidation(tableData.nameObj.data)
    },
    isLiquidation(token){
      return ((new Date()).getTime() -  token.expireTime*1000 ) < 0
    },
    getData() {
      this.$store.dispatch("LoanMarket/mortgageMarket")
    },
    liquidation(id){
      console.log(id)
      this.$store.dispatch("LoanMarket/liquidation",id).then(res=>{
        console.log(res)
        this.$message.success("Successful liquidation")
      }).catch(err=>{
        console.log(err)
        this.$message.error("Liquidation failure" + err)
      })
    },
    borrowAgain(id){
      this.$store.dispatch("LoanMarket/repayment",id).then(res=>{
        console.log(res)
        this.$message.success("Successful re borrowing")
      }).catch(err=>{
        console.log(err)
        this.$message.error("Failed to borrow again" + err)
      })
    },
    lend(id){
      this.$store.dispatch("LoanMarket/mortgageMarket",id).then(res=>{
        console.log(res)
        this.$message.success("Successful re borrowing")
      }).catch(err=>{
        console.log(err)
        this.$message.error("Failed to borrow again" + err)
      })
    }
  },
  computed:{
    ...mapGetters([
      'isConnected',
      'account'
    ]),
    bankTokenArr() {
      let arr = []
      this.$store.state.rainbowBank.records.forEach((item, index) => {
        let obj = {
          index: index + 1,
          nameObj: {
            title: "Token number",
            data: item.tokenId
          },
          infoArr: [
            {
              title: "Lock type",
              data: item.month + "Months"
            },
            {
              title: "Number of RBTS included",
              data: item.amount
            },
          ],
          detailArr: [

            {
              title: "holder",
              data: item.depositor.substr(0, 3) + '...' + item.depositor.substr(item.depositor.length - 3, 3)
            },
            {
              title: "Generation time",
              data: Moment(item.created_at).format('YYYY-MM-DD')
            },
            {
              title: "Expiration time",
              data: Moment(item.updated_at).format('YYYY-MM-DD')
            },
          ],
          withdrawa: [
            {
              address: item.depositor,
              tokenid: item.tokenId

            }
          ]
        }
        arr.push(obj)

      })
        return arr
    },
    myMortgageExpiredArr(){
      return this.$store.state.mortGageLoan.myMortgageExpiredArr
    },
  },
  watch: {
    account() {
      // this.getData()
    },
  },
}
</script>

<style lang="scss" scoped>
.hasBorrow{
  .repayment{
    margin-top: 20px;
  }
}
</style>