<!--
 * @Descripttion: 
 * @version: 
 * @Author: 王远昭
 * @Date: 2023-01-15 12:22:30
 * @LastEditors: 王远昭
 * @LastEditTime: 2023-01-16 22:52:40
-->

<template>
    <el-container>
        <el-aside width="200px">
            <!-- 侧边栏 -->
            <el-menu default-active="1" class="el-menu-vertical-demo" :collapse="isCollapse" @open="handleOpen"
                @close="handleClose">
                <el-menu-item @click="isCollapse = !isCollapse">
                    <div v-show="isCollapse">
                        <el-icon> <ion-icon name="chevron-forward-outline"></ion-icon> </el-icon>
                    </div>
                    <div v-show="!isCollapse">
                        <el-icon><ion-icon name="chevron-back-outline"></ion-icon></el-icon>
                    </div>
                </el-menu-item>
                <el-sub-menu index="1">
                    <template #title>
                        <el-icon>
                            <ion-icon name="person-outline"></ion-icon>
                        </el-icon>
                        <span>我的</span>
                    </template>
                    <el-menu-item-group>
                        <template #title><span>个人信息</span></template>
                        <el-menu-item index="1-1" @click="this.$router.push('/User/info')">查看个人信息</el-menu-item>
                        <el-menu-item index="1-2" @click="this.$router.push('/User/info')">修改个人信息</el-menu-item>
                    </el-menu-item-group>
                    <el-menu-item-group title="操作">
                        <el-menu-item index="1-3" @click="this.$router.push('/User/logout')">
                            <ion-icon name="log-out-outline"></ion-icon>
                            退出
                        </el-menu-item>
                    </el-menu-item-group>
                </el-sub-menu>

                <el-menu-item index="2" @click="this.$router.push('/User/cart')">
                    <el-icon>
                        <ion-icon name="cart-outline"></ion-icon>
                    </el-icon>
                    <span>我的购物车</span>
                </el-menu-item>
                <el-menu-item index="3" @click="this.$router.push('/User/order')">
                    <el-icon>
                        <ion-icon name="newspaper-outline"></ion-icon>
                    </el-icon>
                    <span>我的订单</span>
                </el-menu-item>
                <el-menu-item index="4" disabled>
                    <template #title>我要成为大咸鱼</template>
                </el-menu-item>
            </el-menu>
        </el-aside>
        <el-main>
            <!-- 嵌套子路由 -->
            <RouterView></RouterView>
        </el-main>
    </el-container>
</template>
<script>
// import Admin from './Admin.vue';
export default {
    data() {
        return {
            user :{},
            isCollapse: false
        }
    },
    methods: {
        handleClose(key, keyPath) {
            console.log(key, keyPath)
        },
        handleOpen(key, keyPath) {
            console.log(key, keyPath)
        },
        showTips(tips, type) {
            ElMessage({
                showClose: true,
                message: tips,
                type: type,
            });
        },
        getType() {
            axios.get("http://localhost:53000/user").then((res) => {
                this.user = res.data;
            });
        }
    }
}
</script>
<style scoped>
.el-container {
    height: 100vh;
}

.el-menu-vertical-demo:not(.el-menu--collapse) {
    width: 200px;
    height: 100%;
}

.el-menu-vertical-demo .el-menu--collapse {
    width: 200px;
}

.el-menu {
    height: 100%;
}
</style>