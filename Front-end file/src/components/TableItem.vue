<template>
  <div class="table-item-box" :class="{'r-active-shadow':isShowDetail}" v-show="tableData">
    <div class="table-item">
      <div class="table-item-index">
        {{ tableData.index }}
      </div>
      <div class="table-item-name">
        <div style="text-align:center">{{ tableData.nameObj.title }}</div>
        <div style="text-align:center">{{ tableData.nameObj.data }}</div>
      </div>
      <div class="vertical-bar"></div>
      <div class="table-item-info">
        <div class="info-item" v-for="(info,index) in tableData.infoArr" :key="index">
          <div class="info-item-title">
            {{ info.title }}
          </div>
          <div class="info-item-value r-rainbow-color">
            {{ info.data }}
          </div>
        </div>

      </div>

      <div class="table-item-operate">
        <!--        <el-button class="button-view table-item-view" @click="isShowDetail=!isShowDetail" v-if="tableData.detailArr.length>=0">-->
        <!--          detail <i class="el-icon-arrow-down"></i>-->
        <!--        </el-button>-->
        <el-button v-if="operateRName" @click="$emit('operateRClick',tableData)"
                   class="button1 table-item-operate-detail">
          {{ operateRName }}
        </el-button>
        <el-button v-if="operateGName" @click="$emit('operateGClick',tableData)"
                   class="buttonG  table-item-operate-detail">
          {{ operateGName }}
        </el-button>
        <el-button v-if="operateOName" @click="$emit('operateOClick',tableData)"
                   class="buttonD  table-item-operate-detail">
          {{ operateOName }}
        </el-button>
      </div>
    </div>
    <div class="table-line" v-show="isShowDetail"/>
    <div class="table-item-detail animate__animated animate__flipInX" v-show="isShowDetail">
      <div class="table-detail-item">
        <div class="title-box">
          <template v-for="(item,index) in tableData.detailArr">
            <div class="item" v-if="index < 5" :key="index">
              <div v-if="item.type=='operate'">
                operate
              </div>
              <div style="text-align:center">{{ item.title }}</div>
            </div>
          </template>
        </div>
        <div class="value-box">
          <template v-for="(item,index) in tableData.detailArr">
            <div class="item" v-if="index < 5" :key="index">
              <div v-if="item.type=='operate'">
                <el-button class="button1"> {{ item.data }}</el-button>
              </div>
              <div style="text-align:center">{{ item.data }}</div>
            </div>
          </template>
        </div>
      </div>
      <div class="table-detail-item" v-if="tableData.detailArr && tableData.detailArr.length > 5">
        <div class="title-box">
          <template v-for="(item,index) in tableData.detailArr">
            <div class="item" v-if="index >= 5" :key="index">
              <div v-if="item.type=='operate'">
                operate
              </div>
              <div v-else>
                {{ item.title }}
              </div>
            </div>
          </template>
        </div>
        <div class="value-box">
          <template v-for="(item,index) in tableData.detailArr">
            <div class="item" v-if="index >= 5" :key="index">
              <div v-if="item.type=='operate'">
                <el-button class="button1"> {{ item.name }}</el-button>
              </div>
              <div v-else>
                {{ item.data }}
              </div>
            </div>
          </template>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
//import Moment from 'moment'
//import {mapGetters} from "vuex";

export default {
  name: "tableItem",
  props: ["tableData","operateRName", "operateRClick","operateGName", "operateGClick","operateOName","operateOClick"],
  data() {
    return {
      isShowDetail: false,
    }
  },
  created() {

  }
}
</script>

<style lang="scss" scoped>

.table-item-box {
  ::v-deep .animate__animated.animate__bounce {
    --animate-duration: 0.2s;
  }

  ::v-deep :root {
    --animate-delay: 0.1s;
  }
  margin-top: 20px;
  padding: 25px 20px;
  width: 1060px;
  background: #fbfcfe;
  border: 1px solid #f0f0f0;
  border-radius: 10px;
  transition: all 0.8s ease-out;
  &:hover{
    border-image: linear-gradient(90deg, #12c2e9, #c471ed 55%, #f64f59) 1 1;
    border-radius: 10px;
    box-shadow: 0px 0px 15px 3px rgba(218,0,127,0.25);
  }
  .table-item {
    display: flex;
    align-items: center;

    .table-item-name, .table-item-index {
      color: #520fd5;
      font-weight: 700;
      text-align: center;
      line-height: 30px;
    }

    .table-item-index {
      padding: 0 10px;
      height: 30px;
      opacity: 1;
      background: #f0effe;
      border-radius: 5px;
    }

    .table-item-name {
      width: 20%;
      padding-left: 20px;
      text-align: left;
    }

    .table-item-operate {
      flex: 1;
      display: flex;
      justify-content: flex-end;
    }

    .vertical-bar {
      width: 1px;
      height: 40px;
      opacity: 1;
      background: #eaeaea;
    }

    .table-item-info .info-item, .table-item-value .value-item {
      line-height: 30px;
    }

    .table-item-info {
      padding: 0px 30px;
      flex: 2;

      .info-item {
        display: flex;
        justify-content: space-between;

        .info-item-title {
          font-size: 12px;
        }

        .info-item-value {
          font-weight: bold;
          font-size: 14px;
        }
      }
    }

  }

  .table-line {
    margin: 20px 0 20px -20px;
    width: 858px;
    height: 1px;
    opacity: 1;
    background: #eaeaea;
  }

  .table-item-detail {
    .table-detail-item:nth-child(n+1) {
      margin-top: 10px;
    }

    .table-detail-item {
      .title-box, .value-box {
        display: flex;
        align-items: center;

        .item {
          width: 20%;
          text-align: center;
        }
      }

      .title-box {
        color: #333;
        height: 30px;
        padding: 0 30px;
        border-radius: 5px;
        background: #f0effe;
      }

      .value-box {
        color: #520fd5;
        font-weight: 500;
        padding: 20px 30px 0;

      }
    }
  }
}
</style>
