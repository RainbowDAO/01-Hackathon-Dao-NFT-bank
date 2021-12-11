<template>
  <div class="simplePanel r-shadow">
    <div class="header">
      <slot name="name"></slot>
    </div>
    <div class="line"/>
    <div class="content">
      <slot name="content"></slot>
    </div>
  </div>
</template>

<script>
export default {
  name: "simplePanel"
}
</script>

<style lang="scss" scoped>
.simplePanel{
  text-align: left;
  min-width: 260px;
  width: 330px;
  border-radius: 10px;
  overflow: hidden;
  .line{
    width: 100%;
    height: 1px;
    background: rgba(255,255,255,0.20);
  }
  .header{
    color: white;
    background: linear-gradient(311deg,#736dff 6%, #a97fff);
    padding: 6px 22px;
    line-height: 30px;
    display: flex;
    justify-content: space-between;
    align-items: center;
    img{
      width: 20px;
      height: 20px;
    }
  }
  .content{
    padding: 20px 22px;
    background: white;
  }
}
</style>
