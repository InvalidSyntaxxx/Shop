<!--
 * @Descripttion: 
 * @version: 
 * @Author: 王远昭
 * @Date: 2023-01-14 21:03:43
 * @LastEditors: 王远昭
 * @LastEditTime: 2023-01-14 21:48:56
-->
<script>
export default {
    data() {
        return {
            images: [
                "https://cdn.cnbj1.fds.api.mi-img.com/mi-mall/c162874708ca7856f972ef5eee976e3a.jpg?thumb=1&w=1533&h=575&f=webp&q=90",
                "https://cdn.cnbj1.fds.api.mi-img.com/mi-mall/6d507a3851facf18b1ee54ee94c9e8e8.jpg?thumb=1&w=1533&h=575&f=webp&q=90",
                "https://cdn.cnbj1.fds.api.mi-img.com/mi-mall/a3729c82b1ec2bdbb641c30564c5bed1.jpg?w=2452&h=920",
            ],
            hdgd:"400px",
        }
    },
    mounted() {
        let that = this;
        window.onresize = function windowResize() {
          // 通过捕获系统的onresize事件触发我们需要执行的事件
          var w = window.innerWidth
          var h = 270
          if (w > 1180) {
            h = 400
          } else {
            h = 0.22 * w
          }
          that.hdgd = h + 'px'
          console.log(that.hdgd)
        }
      }
}
</script>
<template>
    <div class="block" m="t-4">
        <el-carousel trigger="click" :height="hdgd" >
            <el-carousel-item v-for="item in images" :key="item" >
                    <el-image  class="image" :src="item" fit="" />
            </el-carousel-item>
        </el-carousel>
    </div>
</template>

<style scoped>
.image{
    /* width: 400px; */
}
.el-carousel__container {
  height: auto;
}
.block {
  padding: 30px 0;
  box-sizing: border-box;
  vertical-align: top;
}
.block:last-child {
  border-right: none;
}
.demonstration {
display: block;
  color: var(--el-text-color-secondary);
  font-size: 14px;
  margin-bottom: 20px;
}


</style>
