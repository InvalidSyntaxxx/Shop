/*
 * @Descripttion: 
 * @version: 
 * @Author: 王远昭
 * @Date: 2023-01-14 12:37:30
 * @LastEditors: 王远昭
 * @LastEditTime: 2023-02-01 21:38:22
 */

import { createApp } from 'vue'
import router from "./router/index"
import "lxgw-wenkai-lite-webfont/style.css";
import ElementPlus from 'element-plus'

import { createPinia } from 'pinia'
import zhCn from 'element-plus/dist/locale/zh-cn.mjs'
import 'element-plus/dist/index.css'
import App from './App.vue'
import './style/style.css'


const app = createApp(App)

app.use(createPinia()) //根存储

app.use(ElementPlus,{
    locale: zhCn,
})
app.use(router)
app.mount('#app')

// 解决提供-注入的响应式依赖！！！！！！！！！！傻逼bug
app.config.unwrapInjectedRef = true
