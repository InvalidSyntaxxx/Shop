/*
 * @Descripttion: 
 * @version: 
 * @Author: 王远昭
 * @Date: 2023-01-17 10:01:45
 * @LastEditors: 王远昭
 * @LastEditTime: 2023-02-02 14:08:19
 */
import { defineStore, acceptHMRUpdate} from "pinia";
export const useUserStore = defineStore({
    id: 'userStore',
    state:()=>({
        name:"",
        isAuthenicated: false,

    }),
    ations: {
        logIn(name) {
            this.name = name
            this.isAuthenicated = true
        },
        logOut() {
            this.name = ""
            this.isAuthenicated = false
        },
        getStatus() {
            return this.isAuthenicated
        }
    }
})

// 确保传递正确的 store 声明
if (import.meta.hot) {
    import.meta.hot.accept(acceptHMRUpdate(useUserStore, import.meta.hot))
  }