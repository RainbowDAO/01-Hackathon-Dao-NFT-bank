<template>
  <div class="rbt-bank">
    <RainbowPanel class="rainCard-box">
      <template v-slot:name>
        <div class="bank-panel-header">
          <span>My Token Asset</span>
          <span class="erc-info erc-info-r">ERC20</span>
        </div>
      </template>
      <template v-slot:content>
        <div class="my-assets-info">
          <div>My Token Amount</div>
          <div class="rbt-number">
            <strong class="r-font-color">{{ userAmount / 10 ** 18 |formatNumberTo }} <span>Token</span></strong>
          </div>
          <div>
            <strong style="margin-left: 10px;" class="r-g-color">USDT:</strong> <span>$ {{
              userAmount * 0.4 | formatNumber
            }}</span>
          </div>
        </div>
        <el-button class="button1 pre-button" size="small" @click="approve">Approve</el-button>
        <el-button class="button1 pre-button" size="small" @click="dialogVisible = true">Staking</el-button>
        <div v-for="item in accountData" :key="item.index">
          <TableItem :tableData="item" operateRName="withdraw" @operateRClick="withdraw"/>
        </div>
        <div class="no-data" v-show="accountData.length==0">
          <img src="../../../assets/img/no-data.png" alt="">
        </div>
      </template>
    </RainbowPanel>
    <!--    <RainbowPanel class="rbt-deposit">-->
    <!--      <template v-slot:name>-->
    <!--        <div style="display: flex;justify-content: space-between;">-->
    <!--          <span style="font-size: 18px;">My RBT-deposit-->
    <!--            <span class="erc-info">ERC721</span>-->
    <!--          </span>-->
    <!--          <el-button @click="isShowRecord = true" class="button-view"-->
    <!--                     size="mini">-->

    <!--            Expired-->
    <!--          </el-button>-->
    <!--        </div>-->
    <!--      </template>-->
    <!--      <template v-slot:content>-->

    <!--        <template v-if="bankTokenArr">-->
    <!--          <div v-for="item in bankTokenArr" :key="item.index">-->
    <!--            <TableItem :tableData="item" operateRName="withdraw" @operateRClick="operateRClick"/>-->
    <!--          </div>-->
    <!--          <div class="no-data" v-show="bankTokenArr.length==0">-->
    <!--            <img src="../../../assets/img/no-data.png" alt="">-->
    <!--          </div>-->
    <!--        </template>-->
    <!--      </template>-->
    <!--    </RainbowPanel>-->
    <el-dialog
        title="Stake"
        :visible.sync="dialogVisible"
        class="dialog"
        width="380px"
    >
      <div class="line">
        <strong>Stake type</strong>
        <el-select v-model="chooseMonth" @change="monthChange" placeholder="stake date" size="mini" class="select">
          <el-option
              v-for="item in monthsArr"
              :key="item.value"
              :label="item.label"
              :value="item.value">
          </el-option>
        </el-select>
      </div>
      <div class="line"><strong>Stake assets</strong> <span></span></div>
      <div class="line"><span>MY RBT</span> <span>Balance: {{ userAmount / 10 ** 18 |formatNumber }}</span></div>

      <div class="input-box">
        <el-input class="input2" :class="{'active':subAmount}" size="small" v-model="amount"></el-input>
        <el-button @click="setMax">MAX</el-button>
      </div>
      <div class="line">
        <el-button @click="dialogVisible=false">cancel</el-button>
        <el-button @click="subPledge">stake</el-button>
      </div>
    </el-dialog>
  </div>
</template>

<script>
import TableItem from "../../../components/TableItem";
import {mapGetters} from "vuex";
import moment from "moment"
import abis from "../../../../abis"

const bankAddress = abis.getContractAddress("RainbowBank")
export default {
  name: "RBTBank",
  components: {TableItem},
  data() {
    return {
      tableData: [],
      bankTokenArr: [],
      userAmount: 0,
      updateTable: false,
      subAmount: 0,
      amount: 0,
      arr1: [],
      arr2: [],
      dialogVisible: false,
      monthsArr: [{label: "active", value: 0}, {label: "Three months", value: 3}, {label: "Six months ", value: 6},
        {label: "Twelve months ", value: 12}, {label: "Twenty-four months", value: 24}, {
          label: "Thirty-six months",
          value: 36
        }],
      chooseMonth: null,
      selectIndex: null,
      allowance: 0,
      isShowRecord: false,
      accountData: [],
      isLoadingT: false,
      isLoadingT2: false,
      amount721: 0,
      stakingamount: [4],
    }
  },
  created() {
    this.initData()
  },
  computed: {
    ...mapGetters([
      'isConnected',
      'account',
      'web3'
    ]),

    consensusRecords() {
      return this.$store.state.consensus.records;
    },
  },

  watch: {
    isConnected() {
      this.initData()
    },
    tableData() {
      let arr = []
      this.tableData.forEach((item, index) => {
        let obj = {
          index: index + 1,
          nameObj: {
            title: "token",
          },
          infoArr: [
            {
              title: "amount",
              data: item.amount
            },
            {
              title: "expireTime",
              data: moment(item.expireTime * 1000)
            },
            {
              title: "startTime",
              data: moment(item.startTime * 1000)
            },
          ],
          detailArr: [],

        }
        arr.push(obj)
      })
      this.accountData = arr
    }
  },
  methods: {
    monthChange() {

    },
    setMax() {

      this.amount = this.userAmount
    },
    async getDeposit() {
      this.isLoadingT2 = true
      this.$store.dispatch("LoanMarket/length").then(async length => {
        for (let i = 1; i <= length; i++) {
          await this.$store.dispatch("RbtDeposit721/tokenMetadata", i).then(res => {
            if(res.owner.toUpperCase() == this.account.toUpperCase()){
              this.tableData.push(res)
            }
          })
        }
      })

      this.isLoadingT2 = false
    },
    async getRecord() {
      this.getDeposit()
    },
    async initData() {
      if (!this.isConnected) {
        return;
      }
      await this.$store.dispatch('RBT/balanceOf', this.$store.state.app.account).then(res => {
        this.userAmount = res
      })
      this.$store.dispatch("RbtDeposit721/balanceOf", this.$store.state.app.account).then(res => {
        this.amount721 = res
      })

      this.$store.dispatch("RbtDeposit721/tokenMetadata", 1).then(res => {
        this.stakingamount = res.amount
      })
      this.getRecord()
    },

    withdraw(item) {
      this.$store.dispatch("RainbowBank/withdrawa", {
        to: this.account,
        tokenId: item.index
      }).then(() => {
        this.$message.success()
      }).catch(err => {
        this.$message.error(err)
      })
    },
    release(tokenId) {
      this.$store.dispatch("RainbowBank/withdrawa", {to: this.$store.state.app.account, tokenId}).then(() => {
        this.$message.success("withdrawa success")
      }).catch((err) => {
        this.$message.error(err)
      })
    },
    approve() {
      this.$store.dispatch("RBT/approve", {
        spender: bankAddress,
        amount: "10000000000000000000000"
      })
    },
    subPledge() {
      this.$store.dispatch("RainbowBank/depositToken", {
            to: this.$store.state.app.account,
            month: this.chooseMonth,
            value: this.amount
          }
      ).then(() => {
        this.$message.success("depositToken success")
        let arr = this.$store.state.rainbowBank.records
        arr.push({
          month: this.chooseMonth,
          tokenId: this.bankTokenArr.length + 1,
          created_at: new Date(),
          depositor: this.account,
          amount: this.amount
        })
      }).catch((err) => {
        console.log(err)
        this.$message.error(err)
      });
    }
  }
}
</script>

<style lang="scss" scoped>
.rbt-bank {
  .rbt-deposit {
    margin-top: 20px;
  }

  .dialog {
    .select {
      width: 120px;
    }

    .line {
      padding: 8px 0;
      display: flex;
      justify-content: space-between;

      .el-button {
        width: 210px;
        height: 42px;
        border-radius: 10px;
      }

      .el-button:last-child {
        color: white;
        background: linear-gradient(225deg, #7700ff, #c4c4c4);
      }
    }

    .input-box {
      padding: 2px 4px;
      border-radius: 4px;
      border: 1px solid #eee;
      background: #F8F8F8;
      display: flex;

      .active {
        ::v-deep .el-input__inner {
          font-weight: bold;
          font-size: 14px;
        }
      }

      .el-button {
        width: 40px;
        font-size: 10px;
        height: 32px;
        padding: 6px;
        color: white;
        background: linear-gradient(225deg, #7700ff, #ed6868);
        border-radius: 5px;
      }
    }

  }

  .my-assets-info {
    margin: 10px auto;
    height: 100px;
    width: 300px;
    text-align: center;
    justify-content: center;
    font-size: 14px;

    .rbt-number {
      font-size: 22px;
      margin: 4px 0;

      span {
        font-size: 16px;
      }
    }
  }

  .pre-button {
    width: 96px;
  }

  .account-data {
    margin: 40px auto;
    width: 60%;
    min-width: 800px;
  }

  .pledge {
    margin: 40px auto;
    min-width: 450px;

    .operating {
      display: flex;
    }

    .submit-button {
      margin-top: 20px;
      min-width: 300px;
    }

    .allow {
      margin-top: 20px;
      min-width: 200px;
      width: 36%;

    }
  }
}
</style>
