<template>
  <div id="app">
    <router-view/>
  </div>
</template>

<script>


export default {
  name: 'App',
  components: {

  }
}
</script>

<style lang="scss">
@import "~@/styles/index.scss";
#app {
  .no-data {
    width: 100%;
    display: flex;
    justify-content: center;
    font-size: 30px;
    color: #999;
  }
}
</style>
