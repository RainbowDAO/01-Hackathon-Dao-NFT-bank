<template>
<div class = "nft-bank-nav">
  <div class="nav-box">
    <ul class = "navbar-nav">
      <li class="a-box" :class="{'active':$route.path=='/RBTBank'}" @click="$router.push({name:'RBTBank'})">
        <a class = "cover" href="#RBTBank"> BANK</a>
      </li>
      <li class="a-box" :class="{'active':$route.path=='/borrowingMessage'}"  @click="$router.push({name:'borrowingMessage'})">
        <a class = "cover" href="#borrowingMessage"> MORTGAGE LOAN MARKET</a>
      </li>
      <li class="a-box" :class="{'active':$route.path=='/TokenAssignment'}" @click="$router.push({name:'TokenAssignment'})">
        <a class = "cover" href="#TokenAssignment"> TOKEN ASSIGNMENT MARKET</a>
      </li>
    </ul>
  </div>
</div>
</template>

<script>

export default {
  name: "headerNav",

  created() {
    console.log(this.$route.path)
  }
}
</script>

<style lang="scss" scoped>
.navbar-nav {
  display: flex;
  margin-right: 200px;
  list-style: none;
  color: white;
  font-weight: bold;
  .active{
    color: #ff1493;
  }
  }
.a-box{
  margin-right: 60px;

}

.cover{
  &:hover{
    color: deeppink;
  }
}
</style>
