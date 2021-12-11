<template>
  <div class="borrowingMarket">
    <RainbowPanel class="market">
      <template v-slot:name>
        Loan market
      </template>
      <template v-slot:content>
        <div v-for="(item,index) in camArr" :key="index">
          <TableItem :tableData="item"
                      operate-r-name="LEND"
                     @operateRClick="operateRClick(item)"/>
        </div>
        <div class="no-data" v-show="camArr.length==0">
          <img src="../../../assets/img/no-data.png" alt="">
        </div>
      </template>
    </RainbowPanel>

  </div>
</template>

<script>
import {mapGetters} from "vuex";
import moment from "moment";
import TableItem from "../../../components/TableItem";
export default {
  name: "borrowingMarket",
  components: {TableItem},
  data(){
    return {
      currentPage:1,
      pagesize:5,
      currentPage2:1,
      pagesize2:5,
      tableData: [],
      camArr: [],
      lendForm:{}
    }
  },
  created() {
      this.initData()
  },
  methods:{
    async operateRClick(item){
      await this.$store.dispatch("LoanMarket/lend", {
        id:item.index
      }).then(res=>{
        console.log(res)
      })
    },
    handleSizeChange(val) {
      this.pagesize = val;
    },
    handleCurrentChange(val) {
      this.currentPage = val;
    },
    handleSizeChange2(val) {
      this.pagesize2 = val;
    },
    handleCurrentChange2(val) {
      this.currentPage2 = val;
    },
    isLiquidation(token){
      return ((new Date()).getTime() -  token.expireTime*1000 ) < 0
    },
    async initData() {
      if (!this.isConnected) {
        return;
      }

      await this.$store.dispatch("RbtDeposit721/totalSupply").then(async length => {

        for (let i = 0;i<length;i++){
          let tempObj = {}
          tempObj.tokenId = i + 1
          await this.$store.dispatch("RbtDeposit721/ownerOf", i+1).then(async res => {
            tempObj.ownerOf = res
            if(res != this.account){
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
      })
    },
    liquidation(id){
      console.log(id)
      this.$store.dispatch("mortGageLoan/liquidation",id).then(res=>{
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
      this.$store.dispatch("LoanMarket/lend",id).then(res=>{
        console.log(res)
        this.$message.success("Loan success")
      }).catch(err=>{
        console.log(err)
          this.$message.error("Loan failure" + err)
      })
    }
  },
  computed:{
    ...mapGetters([
      'isConnected',
      'account'
    ]),

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
}
</script>

<style lang="scss" scoped>
.borrowingMarket{
  .market{
    margin-top: 20px;
  }
}
</style>
