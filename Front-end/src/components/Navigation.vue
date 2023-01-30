<!--
 * @Descripttion: 
 * @version: 
 * @Author: 王远昭
 * @Date: 2023-01-14 17:14:03
 * @LastEditors: 王远昭
 * @LastEditTime: 2023-01-17 15:07:26
-->
<script>
import axios from 'axios'
import { computed } from 'vue'
export default {
  provide:{
    isAuthenicated: computed(()=>this.isAuthenicated)
  },
  data() {
    return {
      isAuthenicated: false,
      isAdmin: true,
    }
  },
  methods: {
    handleNavSelect(key, keyPath) {
      console.log(key, keyPath)
    },
    goToUser() {
      if (this.isAuthenicated) {
        this.$router.push('/User')
      } else {
        this.$router.push('/Login')
      }
    },
    gotoAdmin() {
      if (this.isAdmin) {
        this.$router.push('/Admin')
      } else {
        this.$router.push('/')
      }
    },
    gotoHome() {
      this.$router.push('/Home')
    },
    logIn() {
      this.$router.go(0)
      if(sessionStorage.getItem('user')){
        this.isAuthenicated = true
      }else{
        this.isAuthenicated = false
      }
    },
    logOut() {
      sessionStorage.clear()
      axios.post("http://localhost:53000/logout")

      this.$router.push("/Home")
    }
  },
  
  mounted(){
    window.addEventListener("setItem", this.logIn);
    if(sessionStorage.getItem("username")){
      this.isAuthenicated = true;
    }
  }
}

</script>
<template>
  <!-- 导航栏 -->
  <el-menu :key="isAuthenicated" :default-active="activeIndex" class="el-menu-demo" mode="horizontal" :ellipsis="false"
    @select="handleNavSelect">
    <el-menu-item index="1" @click="gotoHome">首页</el-menu-item>
    <el-menu-item index="2" @click="gotoAdmin">管理</el-menu-item>
    <div class="flex-grow" />
    <el-menu-item v-if="!isAuthenicated" index="3" @click="this.$router.push('/Login')">
      <template  #title>
        <ion-icon name="person-circle-outline"></ion-icon>
        游客,请登录
      </template>
    </el-menu-item>
    <el-sub-menu v-else index="3">
      <template #title>
        <ion-icon name="person-circle-outline"></ion-icon>我的
      </template>
      <el-menu-item @click="this.$router.push('/User/order')" index="3-1"><ion-icon name="reader-outline"></ion-icon> 我的订单</el-menu-item>
      <el-menu-item @click="this.$router.push('/User/cart')" index="3-2"><ion-icon name="cart-outline"></ion-icon> 我的购物车</el-menu-item>
      <el-menu-item @click="this.$router.push('/User/info')" index="3-3"><ion-icon name="person-outline"></ion-icon> 个人中心</el-menu-item>
      <el-sub-menu index="3-4">
        <template #title>账号管理</template>
        <el-menu-item  @click="logOut" index="3-4-1">
          <ion-icon name="power-outline"></ion-icon> 注销
        </el-menu-item>
        <el-menu-item  index="3-4-2"><ion-icon name="repeat-outline"></ion-icon>
          切换账号</el-menu-item>
      </el-sub-menu>
    </el-sub-menu>
  </el-menu>
</template>
<style scoped>
* {
  font-family: "LXGW WenKai Lite", sans-serif;
}

.flex-grow {
  flex-grow: 1;
}

.example-showcase .el-dropdown+.el-dropdown {
  margin-left: 15px;
}

ion-icon {
  font-size: 1.5em;
}
</style>