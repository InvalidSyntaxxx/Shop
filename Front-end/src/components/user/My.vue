<!--
 * @Descripttion: 
 * @version: 
 * @Author: 王远昭
 * @Date: 2023-01-16 09:59:11
 * @LastEditors: 王远昭
 * @LastEditTime: 2023-01-17 01:28:19
-->
<!-- 个人用户详细信息 -->
<template>
    <el-breadcrumb>
        <el-breadcrumb-item :to="{ path: '/User' }">我的</el-breadcrumb-item>
        <el-breadcrumb-item>个人信息</el-breadcrumb-item>
    </el-breadcrumb>

    <el-divider></el-divider>

    <el-empty v-if="!userSession" description="description" />
    <div v-else class="box">
        <h1>个人信息页面</h1>

        <!-- 头像 -->
        <div class="avatar">
            <el-avatar size="large" src="../images/avatar/2.jpg" />
        </div>

        <!-- 信息表单 -->
        <div class="info">
            <el-form :model="user" label-width="120px" label-position="top">
                <el-form-item label="昵称">
                    <el-input v-model="user.nikename" placeholder="请输入用户名" />
                </el-form-item>
                <el-form-item label="密码" prop="pass">
                    <el-input v-model="user.password" type="password" autocomplete="off" />
                </el-form-item>
                <el-form-item label="邮箱">
                    <el-input v-model="user.mail" placeholder="请输入邮箱" />
                </el-form-item>
                <el-form-item label="性别" prop="sex">
                    <el-radio-group v-model="user.sex">
                        <el-radio label="男" />
                        <el-radio label="女" />
                        <el-radio label="保密" />
                    </el-radio-group>
                </el-form-item>
                <el-form-item label="收货人姓名">
                    <el-input v-model="user.name" placeholder="请输入用户名" />
                </el-form-item>
                <el-form-item label="收货联系电话">
                    <el-input v-model="user.phone" placeholder="请输入常用的电话" />
                </el-form-item>
                <el-form-item label="常用收货地址">
                    <el-input v-model="user.address" placeholder="请输入常用收货地址" />
                </el-form-item>
                <el-form-item>
                    <el-button type="primary" @click="putUserInfo">保存</el-button>
                </el-form-item>
            </el-form>
        </div>
    </div>
</template>
<script>
import axios from 'axios';
import { ElMessage } from 'element-plus';
export default {
    data() {
        return {
            rootImage: "../images/avatar/",
            user: {},
            userSession: "1"
        }
    },
    methods: {
        showTips(tips, type) {
            ElMessage({
                showClose: true,
                message: tips,
                type: type,
            });
        },
        getUserInfo() {
            axios.get("http://localhost:53000/user")
                .then((res) => {
                    this.user = res.data;
                });
        },
        putUserInfo() {
            axios.put("http://localhost:53000/user",
                this.user,
                {
                    headers: {
                        'Content-Type': 'multipart/form-data',
                    }
                })
                .then(() => {
                    this.showTips("保存成功！", "success")
                }).catch(() => {
                    this.showTips("出错了，保存失败。。。", "danger")
                })
        }
    },
    beforeCreate(){
        // this.$router.go(0)
    },
    mounted() {
        if (!sessionStorage.getItem('username')){
            // this.$router.push('/login')
        }
        this.getUserInfo()
    }
}
</script>
<style>
h1 {
    margin: 20px 0;
}

.box {
    text-align: center;
}

.flexbox {
    display: flex;
    justify-content: center;
    align-items: center
}

.el-form {
    margin: 0 30px;
}

.el-form-item {
    width: 400px;
    padding: 10px 0;
    margin: auto;
}

.avatar {
    width: 400px;
    margin: auto;
}


.info {
    width: 100%;
}
</style>