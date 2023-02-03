<!--
 * @Descripttion: 
 * @version: 
 * @Author: 王远昭
 * @Date: 2023-01-14 21:58:06
 * @LastEditors: 王远昭
 * @LastEditTime: 2023-02-03 11:10:36
-->
<template>
    <!-- 商品展示 -->
    <div id="product">
        <h2 class="classification">手机</h2>
        <div class="productcontainer">
            <div class="left">
                <img style="max-height: 768px;" src="/products/side.jpg" alt="">
            </div>
            <div class="right">
                <div v-for="product in phone" class="product">
                    <div class="add" @click="handleCart(product.id)">
                        <ion-icon name="cart-outline"></ion-icon>
                    </div>
                    <div class="imgcontainer">
                        <img :src="'/products/' + product['img']" alt="">
                    </div>
                    <div class="info">
                        <span class="see"><ion-icon style="font-size: large;" name="eye-outline"></ion-icon>{{
                        product['see']}}</span>
                        <span class="love"><ion-icon style="font-size: large;" name="heart-outline"></ion-icon>{{
                        product['love']}} </span>
                        <span class="hot"><ion-icon style="font-size: large;" name="flame"></ion-icon>{{
                        product['hot']}} </span>
                    </div>
                    <h3 class="name">{{ product['name']}}</h3>
                    <p class="description">{{ product['description'] }}</p>
                    <p class="price">{{ product['price'] }}元</p>
                </div>
            </div>
        </div>
        <h2 class="classification">
            其它
            <el-radio-group v-model="sort" @change="handleSort(param)">
                <el-radio-button label="销售量" />
                <el-radio-button label="类型">
                </el-radio-button>
                <el-radio-button label="全部" />
            </el-radio-group>
            <!-- </div> -->
        </h2>
        <el-select v-if="typeSelect" v-model="typeValue" @change="handleSelect" class="typeSelect" placeholder="请选择类型">
            <el-option v-for="item in type" :key="item['classification']" :label="item['classification']"
                :value="item['classification']" />
        </el-select>
        <div class="right">
            <div v-for="other in others" class="product">
                <div class="add" @click="handleCart(other.id)"><ion-icon name="cart-outline"></ion-icon></div>
                <div class="imgcontainer">
                    <img :src="'/products/' + other['img']" alt="">
                </div>
                <div class="info">
                    <span class="see"><ion-icon style="font-size: large;" name="eye-outline"></ion-icon>{{
                    other['see']}}</span>
                    <span class="love"><ion-icon style="font-size: large;" name="heart-outline"></ion-icon>{{
                    other['love']}} </span>
                    <span class="hot"><ion-icon style="font-size: large;" name="flame"></ion-icon>{{ other['hot']}}
                    </span>
                </div>
                <h3 class="name">{{ other['name']}}</h3>
                <p class="description">{{ other['description'] }}</p>
                <p class="price">{{ other['price'] }}元</p>
            </div>
        </div>
    </div>
</template>
<script>
import axios from 'axios'
import { useGlobalStore } from '../store/global';
import { ElMessage, ElMessageBox } from 'element-plus';
export default {
    setup(){
        const Globalstore = useGlobalStore()
        return { Globalstore } 
    },
    data() {
        return {
            typeSelect: false,
            typeValue: "",
            type: [],
            products: [],
            phone: [],
            others: [],
            sort: ""
        }
    },
    mounted() {
        this.getProduct(8);
        this.getOther(8);
    },
    methods: {
        handleCart(productID) {
            // 判断是否登录
            if (sessionStorage.getItem('username')) {
                console.log(sessionStorage.getItem("username"))
                let params = new FormData()
                params.append('id', productID)
                axios.post( this.Globalstore.getApiSever+"/cart", params,
                    {
                        headers: { 'Content-Type': 'multipart/form-data' },
                    })
                    .then(() => {
                        ElMessageBox.confirm(
                            '<ion-icon name="cart-outline"></ion-icon>加入购物车成功！立马去查看',
                            '温馨提示',
                            {
                                confirmButtonText: '迫不及待！',
                                cancelButtonText: '我还想要更多',
                                type: 'success',
                                dangerouslyUseHTMLString: true,
                            }
                        )
                            .then(() => {
                                this.$router.push("/User/cart")
                            })
                    })
            } else {
                ElMessageBox.confirm(
                    '您还未登录，是否去登陆？',
                    '温馨提示',
                    {
                        confirmButtonText: '立马去',
                        cancelButtonText: '我先看看',
                        type: 'warning',
                    }
                )
                    .then(() => {
                        this.$router.push("/login")
                    })
            }
        },
        getProduct(limit) {
            axios
                .get(this.Globalstore.apiSever+"/products?_limit=" + limit)
                .then((res) => {
                    this.products = res.data;
                    this.phone = this.products.slice(0, 8)
                    this.products = this.products.reverse()
                });
        },
        getType() {
            axios.get(this.Globalstore.apiSever+"/fenlei").then((res) => {
                this.type = res.data;
            });
        },
        getOther() {
            axios
                .get(this.Globalstore.apiSever+"/products")
                .then((res) => {
                    this.others = res.data;
                    this.others.reverse()
                });
        },
        handleSort() {
            this.others = this.products
            if (this.sort == "销售量") {
                // 按销售量排序
                this.typeSelect = false
                let results = []
                let hotsResults = []
                for (let i = 0; i < this.others.length; i++) {
                    hotsResults.push(parseInt(this.others[i]['hot']))
                    hotsResults.sort(function (a, b) { return b - a }) //sort默认对字符串排序，数值排序不支持
                }
                // 取销售量为前6位商品
                results = this.others.filter((item) => item.hot > hotsResults[7])
                console.log(results)
                // 重新排序 
                this.others = results
            }
            else if (this.sort == "类型") {
                this.typeSelect = true
            } else {
                this.typeSelect = false
                this.others = this.products
            }
        },
        handleSelect() {
            this.others = this.products
            this.others = this.others.filter((item) => item.type == this.typeValue)
        }
    },
    mounted() {
        this.getOther()
        this.getProduct()
        this.getType()
        console.log(this.type.length)
        // for(let i = 0; i<this.type.length;i++){
        // types.push(this.type['classification'])
        // }
        // console.log(types)
    }
}
</script>
<style scoped>
img {
    max-width: 250px;
    max-height: 250px;
}

.classification {
    position: relative;
    font-family: "LXGW WenKai Lite", sans-serif;
    ;
    padding-top: 20px;
    margin: 1em 0 0 1em;
    color: #000000;
}

.productcontainer {
    display: flex;
    margin: 0 calc(1em + 2vw);
    max-width: 100%;
    max-height: 820px;
    overflow: hidden;
}

.left {
    margin: calc(1em + 1vw + 1vh);
}

.right {
    display: flex;
    flex-flow: row wrap;
    align-items: center;
    justify-content: center;
}

.product {
    background-color: rgb(255, 255, 255);
    display: block;
    margin: 0.35em;
    justify-content: center;
    text-align: center;
    z-index: 2;
}

.product:hover {
    box-shadow: 0 15px 30px rgb(0 0 0 / 10%);
    transform: translate3d(0, -2px, 0);
    transition: all .25s linear;
    opacity: 0.5;

}

.product .add {
    height: 2em;
    width: 2em;
    font-size: 1.5em;
    display: flex;
    align-items: center;
    justify-content: center;
    position: absolute;
    border-radius: 50px;
    color: #fff;
    background-color: #000000;
    cursor: pointer;
    display: none;
    left: calc(50% - 1rem);
}

.add ion-icon {
    /* 垂直居中的关键 */
    height: 100%;
}

.product:hover .add {
    display: block;
    z-index: 3;
    bottom: calc(50% - 1rem);
    opacity: 1;
}

.product:hover .add:hover {
    color: #2dfc52;
    filter: drop-shadow(0 0 2px #2dfc52) drop-shadow(0 0 5px #2dfc52) drop-shadow(0 0 15px #2dfc52);
}

.info {
    /* width: 100%; */
    /* float: right; */
    display: block;
    font-size: 0.5em;
    color: #DCD9D4;
    margin: 0 0 1em;
}

.info ion-icon {
    vertical-align: -.25em;
}

.love {
    padding: 0 3em;
}

.hot {
    right: 0;
}

.name {
    display: block;
    font-family: var(--text-font-family);
    font-size: 1.15em;
}

.description {
    width: 240px;
    margin: .15em 0 0;
    font-size: .75em;
    padding: 0 0 calc(1em - 1vh);
    text-align: center;
    text-overflow: ellipsis;
    white-space: nowrap;
    overflow: hidden;
    color: #b0b0b0;
}

.price {
    font-family: initial;
    font-size: 1.5em;
    color: #ff6700;
    padding-bottom: 20px;
}

/* 让提交清空按钮居中 */
.jc-center .el-form-item__content {
    justify-content: center;
}

.typeSelect {
    margin: 10px 80px;
}
</style>