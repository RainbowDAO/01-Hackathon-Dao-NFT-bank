<template>
  <div class="rainbowPanel r-shadow">
    <div class="rainbowPanel-header">
      <div class="name"><slot name="name"></slot></div>
    </div>
    <div class="rainbowPanel-content ">
      <slot name="content"></slot>
    </div>
  </div>
</template>

<script>
export default {
  name: "rainbowPanel"
}
</script>

<style lang="scss" scoped>
.rainbowPanel{
  background: white;
  width: 1100px;
  margin: 18px auto;
  overflow: hidden;
  border: 1px solid #f8f8f8;
  border-radius: 10px;
  .rainbowPanel-header{
    padding:20px;
    display: flex;
    text-align: left;

    .name{
      padding-left: 6px;
      line-height: 20px;
      font-size: 20px;
      font-weight: bold;
      font-family: Roboto;
      color: #333333;
      width: 100%;
    }


  }
  .rainbowPanel-content{
    padding: 0 20px 30px;
  }
}
</style>
