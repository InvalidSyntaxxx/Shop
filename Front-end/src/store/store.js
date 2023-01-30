/*
 * @Descripttion: 
 * @version: 
 * @Author: 王远昭
 * @Date: 2023-01-17 10:01:45
 * @LastEditors: 王远昭
 * @LastEditTime: 2023-01-17 10:29:12
 */
import { defineStore } from "pinia";
export const userStore = defineStore({
    id: 'userStore',
    state:()=>({
        isAuthenicated: false
    }),
    ations: {
        logIn() {
            this.isAuthenicated = true
        },
        logOut() {
            this.isAuthenicated = false
        },
        getStatus() {
            return this.isAuthenicated
        }
    }
})