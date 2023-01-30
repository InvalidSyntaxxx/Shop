<!--
 * @Descripttion: 
 * @version: 
 * @Author: 王远昭
 * @Date: 2023-01-14 22:19:08
 * @LastEditors: 王远昭
 * @LastEditTime: 2023-01-14 22:36:18
-->
<template>
    <!-- 页脚区 -->
    <div class="footer-wrapper">
        <footer class="footer">
            <el-row>
                <el-col :span="4">
                     <h5>© 2022 Company, Inc</h5>
                     <el-col :span="12">
                    </el-col>
                </el-col>

                <el-col :span="4">
                    <div class="grid-content ep-bg-purple-light" />
                </el-col>
                <el-col :span="4">
                    <div class="grid-content ep-bg-purple" />
                </el-col>
                <el-col :span="4">
                    <div class="grid-content ep-bg-purple-light" />
                </el-col>
                <el-col :span="4">
                    <div class="grid-content ep-bg-purple" />
                </el-col>
                <el-col :span="4" class="icon" style="float: right;">
                    <ion-icon name="mail-outline"></ion-icon>
                    <ion-icon name="chatbubbles-outline" class="center-mrl"></ion-icon>
                    <ion-icon name="help-circle-outline"></ion-icon>
                </el-col>
            </el-row>
        </footer>
    </div>
</template>
<style>
.footer-wrapper{
    background-color: #f0f8ff;
}
.icon {
    font-size: 2em;
    float: right;
}

.center-mrl {
    padding: 0 1em;
}
</style>