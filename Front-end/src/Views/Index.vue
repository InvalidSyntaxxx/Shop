<!--
 * @Descripttion: 
 * @version: 
 * @Author: 王远昭
 * @Date: 2023-01-14 18:13:50
 * @LastEditors: 王远昭
 * @LastEditTime: 2023-01-16 23:29:33
-->
<script setup>
import Carousel from '../components/Carousel.vue';
import Display from '../components/Display.vue';
import Footer from '../components/Footer.vue';
</script>
<template>
    <!-- 轮播图 -->
    <div class="carouselWrapper">
        <div class="carousel">
            <Carousel style="width: 80vw"></Carousel>
        </div>
    </div>
    <!--  商品展示 -->
    <Display></Display>
    <!-- 页脚 -->
    <Footer></Footer>
</template>
<style>
.carouselWrapper {
    display: flex;
    justify-content: center;
    align-items: center;
}

.carousel {
    width: 80vw;
}
</style>