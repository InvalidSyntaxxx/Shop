<!--
 * @Descripttion: 
 * @version: 
 * @Author: 王远昭
 * @Date: 2023-01-16 09:58:43
 * @LastEditors: 王远昭
 * @LastEditTime: 2023-02-03 18:30:34
-->
<!-- 订单页 -->
<template>
    <!-- 头顶面包屑，我是歇了 -->
    <el-breadcrumb>
        <el-breadcrumb-item :to="{ path: '/User' }">我的</el-breadcrumb-item>
        <el-breadcrumb-item>全部订单</el-breadcrumb-item>
    </el-breadcrumb>

    <el-divider class="first"></el-divider>
    
    <h1>订单列表</h1>
    <el-empty v-if="!orders" description="亲，您在今年还没有收获哦！😐" />
    <div v-else class="container" v-for="order in orders">
        <el-divider v-if="order.id != 1" />
        <el-container class="orderCard">
            <el-aside width="100px">
                <el-image style="width: 100px; height: 100px" :src="rootImage + order.img" :fit="fit" />
            </el-aside>
            <el-main>
                <el-container>
                    <el-header>
                        <div class="description">
                            {{ order.description }}
                        </div>
                    </el-header>
                    <el-main>
                        <b>x {{ order.count }} </b>
                    </el-main>
                </el-container>

            </el-main>
        </el-container>

        <div class="demo-collapse">
            <el-descriptions class="margin-top" border>
                <el-descriptions-item>
                    <template #label>
                        <div class="cell-item">
                            <el-icon :style="iconStyle">
                                <ion-icon name="person-outline"></ion-icon>
                            </el-icon>
                            收货人姓名
                        </div>
                    </template>
                    {{ order.name }}
                </el-descriptions-item>
                <el-descriptions-item>
                    <template #label>
                        <div class="cell-item">
                            <el-icon :style="iconStyle">
                                <ion-icon name="call-outline"></ion-icon>
                            </el-icon>
                            联系电话
                        </div>
                    </template>
                    {{ order.phone }}
                </el-descriptions-item>

                <el-descriptions-item>
                    <template #label>
                        <div class="cell-item">
                            <el-icon :style="iconStyle">
                                <ion-icon name="time-outline"></ion-icon>
                            </el-icon>
                            下单时间
                        </div>
                    </template>
                    {{ order.time }}
                </el-descriptions-item>
                <el-descriptions-item>
                    <template #label>
                        <div class="cell-item">
                            <el-icon :style="iconStyle">
                                <ion-icon name="cube-outline"></ion-icon>
                            </el-icon>
                            订单状态
                        </div>
                    </template>
                    <el-tag size="small">
                        已下单
                    </el-tag>
                </el-descriptions-item>

                <el-descriptions-item>
                    <template #label>
                        <div class="cell-item">
                            <el-icon :style="iconStyle">
                                <ion-icon name="business-outline"></ion-icon>
                            </el-icon>
                            收货地址
                        </div>
                    </template>
                    {{ order.address }}
                </el-descriptions-item>
            </el-descriptions>
        </div>
        <div class="sum">
            <span>
                <el-tag class="ml-2" size="large" type="success">实付款</el-tag>
                ￥{{ order.sum }}</span>
        </div>
    </div>
    
    <el-divider />
    <div v-if="orders" class="footer">
        亲，您在今年都收获满满！😁
    </div>
</template>

<script>
import axios from 'axios';
import { ElMessage } from 'element-plus'
import { useGlobalStore } from '../../store/global';
export default {
    setup() {
        const globalstore = useGlobalStore()
        return {
            globalstore
        }
    },
    data() {
        return {
            rootImage: "/products/",
            orders: []

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
        // 获取全部订单
        getOrders() {
            axios
                .get(this.globalstore.apiServer + "/order")
                .then((res) => {
                    this.orders = res.data;
                    console.log(JSON.stringify(this.orders))
                })
                .then(() => {
                    console.log("get!")
                });
        }
    },
    mounted() {
        this.getOrders()
    }
}
</script>
<style scoped>
.container {
    margin: auto;
    width: 60%;
}

.description {
    font-family: "LXGW WenKai Lite", sans-serif;
    overflow: hidden;
    white-space: nowrap;
    text-overflow: ellipsis;
}

.sum {
    font-size: large;
    font-family: "LXGW WenKai Lite", sans-serif;
    float: right;
    margin: 10px 20px 0 0;
}

.el-divider {
    margin-top: 50px;
}

.first {
    margin-top: 10px;
}
.footer {
    width: 100%;
    margin: auto;
    text-align: center;
    font-family: "LXGW WenKai Lite", sans-serif;

}
</style>