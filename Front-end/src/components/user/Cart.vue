<!--
 * @Descripttion: 
 * @version: 
 * @Author: 王远昭
 * @Date: 2023-01-14 12:37:30
 * @LastEditors: 王远昭
 * @LastEditTime: 2023-01-19 10:23:48
-->
<template>
  <el-breadcrumb>
    <el-breadcrumb-item :to="{ path: '/User' }">我的</el-breadcrumb-item>
    <el-breadcrumb-item>我的购物车</el-breadcrumb-item>
  </el-breadcrumb>
  <el-divider></el-divider>
  <div class="tableTop">
    <el-button class="buttonTop" type="primary" size="large">
      全部购买！
    </el-button>
  </div>
  <div class="maincontainer">
    <el-table v-loading="loading" :data="container['tableData']" height="500" table-layout="fixed"
      :summary-method="getSummaries" show-summary stripe>
      <el-table-column prop="name" label="宝贝名称" align="center"></el-table-column>
      <el-table-column label="宝贝分类" align="center">
        <template #default="scope">
          <el-tag>{{ scope.row.type }}</el-tag>
        </template>
      </el-table-column>
      <el-table-column label="宝贝样图" align="center">
        <template #default="scope">
          <el-image style="width: 100px; height: 100px" :src="rootImage + scope.row.img" :zoom-rate="1.2"
            :initial-index="4" fit="cover" />
        </template>
      </el-table-column>
      <el-table-column prop="description" label="宝贝简介" align="center"></el-table-column>
      <el-table-column prop="count" label="宝贝数量" align="center">
        <template #default="scope">
          <el-input-number v-model="scope.row.count" :min="1" :max="99" @change="handleChange" />
        </template>
      </el-table-column>
      <el-table-column prop="price" label="宝贝一口价" align="center"></el-table-column>
      <el-table-column fixed="right" label="操作" width="150">
        <template #default="scope">
          <el-button size="small" @click="handleAdd(scope.$index)">立即下单</el-button>
          <el-button type="danger" size="small" @click="handleDelete(scope.$index)">
            <ion-icon name="trash-outline"></ion-icon>
          </el-button>
        </template>
      </el-table-column>
    </el-table>
    <div style="display:flex;justify-content:center; align-items:center;">
      <el-pagination @current-change="handleCurrentChange" :current-page="container['currentPage']"
        layout="total, prev, pager, next, jumper" :total="container['totalItems']"></el-pagination>
    </div>
  </div>
</template>
<script>
import axios from 'axios';
import { computed } from 'vue'
import { ElMessage, ElMessageBox } from 'element-plus'
export default {
  data() {
    return {
      rootImage: "images/products/",
      loading: true,
      container: {
        products: [],
        tableData: [],
        currentPage: 1,
        totalItems: 0,
        filterTableData: [],
        flag: false,
      },

    }
  },
  mounted() {
    this.getCart();
    this.loading = false;
  },
  methods: {
    showTips(tips, type) {
      ElMessage({
        showClose: true,
        message: tips,
        type: type,
      });
    },
    getSummaries(param) {
      const { columns, data } = param
      const sums = []
      columns.forEach((column, index) => {
        if (index === 0) {
          sums[index] = '总计'
          return
        }
        const values = data.map((item) => Number(item[column.property]))
        if (!values.every((value) => Number.isNaN(value))) {
          sums[index] = `${values.reduce((prev, curr) => {
            const value = Number(curr)
            if (!Number.isNaN(value)) {
              return prev + curr
            } else {
              return prev
            }
          }, 0)}`
        } else {
          sums[index] = ''
        }
      })
      sums[5] = sums[5] + '元'
      return sums
    },
    getCart() {
      axios
        .get("http://localhost:53000/cart")
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
      ElMessageBox.confirm("要忍心把宝贝给人家嘛？", "警告", {
        confirmButtonText: "不要了",
        cancelButtonText: "我再想想",
        type: "warning",
      })
        .then(() => {
          // 后端数据删除
          axios({
            url:
              "http://localhost:53000/cart?DeleteID=" +
              this.container.tableData[index]["id"],
            method: "POST",
          })
            .then(() => {
              // 前端数据表格删除
              this.container.tableData.splice(index, index + 1);
              this.showTips("成功把宝贝给别人家的小朋友啦！", "success");
            })
            .catch(() => {
              this.showTips("似乎出错了...", "info");
            });
        })
        .catch(() => {
          this.showTips("取消", "info");
        });
    },
    // 提交事件
    handleAdd(index) {
        axios({
          method: "post",
          url: "http://localhost:53000/order",
          data: this.container.tableData[index],
          headers: {
            'Content-Type': 'multipart/form-data',
          },
          timeout: 1000,
        })
          .then(() => {
            this.showTips("下单成功！", "success");
            // 重载画面
            this.$router.go(0)
          })
          .catch(() => {
            this.showTips("似乎出错了，未能增加", "danger");
          });
      },
      handleAddAll(){

      }
  }
}
</script>
<style>
.tableTop {
  float: right;
}

.tableTop .buttonTop {
  margin: 0 20px 10px;
}
</style>