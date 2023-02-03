/*
 * @Descripttion: 
 * @version: 
 * @Author: 王远昭
 * @Date: 2023-01-17 10:01:45
 * @LastEditors: 王远昭
 * @LastEditTime: 2023-02-03 00:27:51
 */
import { defineStore,acceptHMRUpdate } from "pinia";
export const useGlobalStore = defineStore({
    id: 'GlobalStore',
    state:()=>({
        apiHost: 'http://47.94.12.50',
        apiPort: '53000',
    }),
    getters:{
        apiSever:(state) => state.apiHost + ":" + state.apiPort
    },
    actions: {
        getImageUrl(name) {
            return new URL(name, import.meta.url).href
          }
    }
})

// 确保传递正确的 store 声明
if (import.meta.hot) {
    import.meta.hot.accept(acceptHMRUpdate(useGlobalStore, import.meta.hot))
  }