<!--
 * @Descripttion: 
 * @version: 
 * @Author: 王远昭
 * @Date: 2023-01-14 23:39:40
 * @LastEditors: 王远昭
 * @LastEditTime: 2023-02-03 11:12:32
-->
<template>
    <!-- 表单 -->
    <div class="maintable">
        <div class="maincontainer">
            <div class="tableTop">
                <el-autocomplete v-model="searchValue" :fetch-suggestions="querySearch" @select="handleSearch" clearable
                    placeholder="请输入编号或商品名称" style="width:300px" class="mb-3"></el-autocomplete>

                <el-button type="primary" size="mini" @click="handleSearch">搜索</el-button>
                <el-button @click="handleAdd">增加</el-button>
            </div>
            <el-table v-loading="loading" :data="container['tableData']" height="560" table-layout="fixed" stripe>
                <el-table-column prop="id" label="编号" align="center"></el-table-column>
                <el-table-column prop="name" label="商品名称" align="center"></el-table-column>
                <el-table-column label="商品略缩图" align="center">
                    <template #default="scope">
                        <el-image style="width: 100px; height: 100px" :src="rootImage + scope.row.img" :zoom-rate="1.2"
                            :initial-index="4" fit="cover" />
                    </template>
                </el-table-column>
                <el-table-column prop="type" label="商品类型" align="center"></el-table-column>
                <el-table-column prop="price" label="售价" align="center"></el-table-column>
                <el-table-column prop="inventory" label="库存量" align="center"></el-table-column>
                <el-table-column prop="description" label="商品简介" align="center"></el-table-column>
                <el-table-column prop="date" label="上架时间" align="center"></el-table-column>
                <el-table-column fixed="right" label="操作" width="150">
                    <template #default="scope">
                        <el-button type="primary" size="small" @click="handleUpdate(scope.$index)">修改</el-button>
                        <el-button type="danger" size="small" @click="handleDelete(scope.$index)">删除</el-button>
                    </template>
                </el-table-column>
            </el-table>

            <!-- 修改商品信息 -->
            <el-dialog v-model="UpdateTableVisible" title="修改商品信息">
                <ProductForm></ProductForm>
            </el-dialog>

            <!-- 增加商品 -->
            <el-dialog v-model="AddTableVisible" title="新增商品信息">
                <ProductForm></ProductForm>
            </el-dialog>
            <div style="display:flex;justify-content:center; align-items:center;">
                <el-pagination @size-change="handleSizeChange" @current-change="handleCurrentChange"
                    :current-page="container['currentPage']" :page-sizes="[4, 6, 8]" :page-size="container['pageSize']"
                    layout="total,  sizes, prev, pager, next, jumper" :total="container['totalItems']"></el-pagination>
            </div>
        </div>
    </div>

</template>
<script>
import axios from 'axios';
import { computed } from 'vue'
import { ElMessage, ElMessageBox } from 'element-plus'
import { useGlobalStore } from '../../store/global'
import ProductForm from './ProductForm.vue'
export default {
    components: { ProductForm },
    provide() {
        return {
            form: computed(() => this.form),
            originImage: computed(() => this.originImage),
            action: computed(() => this.action)
        }
    },
    setup() {
        const Globalstore = useGlobalStore()
        return { Globalstore }
    },
    data() {
        return {
            rootImage: "/products/",
            originImage: [],
            form: {},
            action: "",
            container: {
                products: [],
                tableData: [],
                currentPage: 1,
                pageSize: 8,
                totalItems: 0,
                filterTableData: [],
                flag: false,
            },
            UpdateTableVisible: false,
            AddTableVisible: false,
            loading: true,
            searchValue: "",

        };
    },
    methods: {
        showTips(tips, type) {
            ElMessage({
                showClose: true,
                message: tips,
                type: type,
            });
        },
        getType() {
            axios.get(this.Globalstore.apiSever + "/fenlei").then((res) => {
                this.type = res.data;
            });
        },
        getProduct() {
            axios
                .get(this.Globalstore.apiSever + "/products")
                .then((res) => {
                    this.container.products = res.data;
                    //   alert(JSON.stringify(this.container.products))
                })
                .then(() => {
                    this.container.totalItems = this.container.products.length;
                    if (this.container.totalItems > this.container.pageSize) {
                        for (let index = 0; index < this.container.pageSize; index++) {
                            this.container.tableData.push(this.container.products[index]);
                        }
                    } else {
                        this.container.tableData = this.container.products;
                    }
                });
        },
        // 每页显示条数改变触发
        handleSizeChange(val) {
            this.container.pageSize = val;
            this.handleCurrentChange(1);
        },
        // 当前页改变触发
        handleCurrentChange(val) {
            this.container.currentPage = val;
            // 判断是否为搜索的数据,传入对应值
            if (!this.container.flag) {
                this.currentChangePage(this.container.products);
            } else {
                this.currentChangePage(this.container.filterTableData);
            }
        },
        // 根据分页，确定当前显示的数据
        currentChangePage(list) {
            let fromNum = (this.container.currentPage - 1) * this.container.pageSize;
            let toNum = this.container.currentPage * this.container.pageSize;
            this.container.tableData = [];
            for (; fromNum < toNum; fromNum++) {
                if (list[fromNum]) {
                    this.container.tableData.push(list[fromNum]);
                }
            }
        },
        // 处理删除事件
        handleDelete(index) {
            ElMessageBox.confirm("此操作将永久删除该数据，是否删除？", "警告", {
                confirmButtonText: "马上删除",
                cancelButtonText: "我再想想",
                type: "warning",
            })
                .then(() => {
                    // 后端数据删除
                    axios({
                        url:
                            this.Globalstore.apiSever + "/products?DeleteID=" +
                            this.container.tableData[index]["id"],
                        method: "POST",
                    })
                        .then(() => {
                            // 前端数据表格删除
                            this.container.tableData.splice(index, index + 1);
                            this.showTips("删除成功！", "success");
                        })
                        .catch(() => {
                            this.showTips("似乎出错了...", "info");
                        });
                })
                .catch(() => {
                    this.showTips("操作取消", "info");
                });
        },
        querySearch(queryString, cb) {
            const results = queryString
                ? this.container.tableData.filter(item => ((item.id + "").indexOf(queryString) != -1 || item.name.indexOf(queryString) != -1))
                : []
            // callback回调函数，返回结果
            cb(results)
        },
        handleSearch() {
            // 前端搜索功能需要区分是否检索,因为对应的字段的索引不同
            let newTableData = []
            this.container.products.filter((item) => {
                if ((item.id + "").indexOf(this.searchValue) != -1 || item.name.indexOf(this.searchValue) != -1) {
                    newTableData.push(new Object(item))
                }
            })
            // 搜索后的新数据
            this.container.filterTableData = newTableData
            // 页面数据改变重新统计数据数量和当前页
            this.container.currentPage = 1;
            this.container.totalItems = this.container.filterTableData.length;
            // 渲染表格,根据值
            this.currentChangePage(this.container.filterTableData);
            // 页面初始化数据需要判断是否检索过
            this.container.flag = true;
        },
        // 处理更新事件
        handleUpdate(index) {
            this.UpdateTableVisible = true;
            this.form = this.container.tableData[index];
            this.originImage = [
                {
                    name: this.container.tableData[index]["name"],
                    url: this.rootImage + this.container.tableData[index]["img"],
                },
            ];
            this.action = "";
        },
        // 处理增加事件
        handleAdd() {
            this.form = {}
            this.originImage = []
            this.action = "add"
            this.AddTableVisible = true;
        }
    },
    mounted() {
        this.getProduct();
        this.loading = false;
        this.getType();
    },

}
</script>
<style scoped>
.tableTop {
    margin: 20px 0 10px 20px;
}
</style>