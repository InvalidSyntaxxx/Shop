<!--
 * @Descripttion: 
 * @version: 
 * @Author: 王远昭
 * @Date: 2023-01-15 17:26:39
 * @LastEditors: 王远昭
 * @LastEditTime: 2023-02-03 17:45:18
-->
<template>
    <el-form ref="ruleFormRef"  :model="form" :rules="rules" class="demo-ruleForm" label-width="120px" status-icon>
        <el-form-item label="商品名称" prop="name">
            <el-input v-model="form.name" />
        </el-form-item>
        <el-form-item label="商品图片" prop="picture">
            <el-upload ref="uploadFile" action="" enctype="multipart/form-data"
                :headers="headers" accept="image/*" :on-success="handleUploadSuccess" :file-list="originImage" list-type="picture-card"
                :http-request="uploadAction" :auto-upload="true" :limit="1">
                <el-icon class="el-icon--upload">
                    <ion-icon name="cloud-upload-outline"></ion-icon></el-icon>
                <template #tip>
                    <div class="el-upload__tip">
                        仅限<b>一张</b>商品图 文件大小需小于
                        <b>1MB</b>
                    </div>
                </template>
            </el-upload>

        </el-form-item>
        <el-form-item label="商品类型" prop="type">
            <el-select v-model="form.type" placeholder="请选择商品的类型">
                <el-option v-for="item in type" :key="item['classification']" :label="item['classification']"
                    :value="item['classification']" />
            </el-select>
        </el-form-item>
        <el-form-item label="商品售价" prop="price">
            <el-input-number v-model="form.price" :precision="2" :step="0.1" :min="0" />
        </el-form-item>
        <el-form-item label="商品库存" prop="inventory">
            <el-input-number v-model="form.inventory" :step="1" :min="0" />
        </el-form-item>
        <el-form-item label="商品简介" prop="description">
            <el-input v-model="form.description" type="textarea" />
        </el-form-item>
        <el-form-item>
            <el-button v-if="action" type="primary" @click="onAdd">新增</el-button>
            <el-button v-else type="primary" @click="onUpdate">更新</el-button>
        </el-form-item>
    </el-form>
</template>
<script>
import axios from 'axios';
import { useGlobalStore } from '../../store/global';
import { ElMessage } from 'element-plus';
import { ref } from 'vue';
// 前端表单验证规则
const rules = {
    name: [{ required: true, message: "请输入商品名称", trigger: "blur" }],
    picture: [
        {
            type: "file",
            required: true,
            message: "请上传至少一张商品图",
            trigger: "change",
        },
    ],
    type: [
        {
            required: true,
            message: "请选择商品类型",
            trigger: "change",
        },
    ],
    price: [
        {
            required: true,
            message: "请输入商品售价",
            trigger: "change",
        },
        { type: "number", min: 0, message: "商品售价需大于0", trigger: "blur" },
    ],
    inventory: [
        {
            required: true,
            message: "请输入商品库存",
            trigger: "change",
        },
        { type: "number", min: 0, message: "库存量需大于0", trigger: "blur" },
    ],
    description: [{ required: true, message: "请输入商品简介", trigger: "blur" }],
    date: [
        {
            type: "date",
            required: true,
            message: "请选择日期",
            trigger: "change",
        },
    ],
    time: [
        {
            type: "date",
            required: true,
            message: "请选择时间",
            trigger: "change",
        },
    ],
};

export default {
    inject: ['form', 'originImage', 'action'],
    setup() {
    const Globalstore = useGlobalStore()
    return { Globalstore }
},
    data() {
        return {
            rootImage: "images/products/",
            headers: { 'Content-Type': 'multipart/form-data' },
            type: [],
            rules: rules,
        }
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
            axios.get(this.Globalstore.apiServer + "/fenlei").then((res) => {
                this.type = res.data;
            });
        },
        handleUploadSuccess(res, file, files) {
            this.form.filename = file.name
        },
        async uploadAction(e) {
            const fd = new FormData()
            fd.append('img',e.file)
            // 将文件转化为base64格式传入后端
                axios.post(this.Globalstore.apiServer + "/upload",fd)
                    .then((res) => {
                        console.log("succss uplaod")
                    })
        },
        // 提交到 更新后的数据 服务端
        onUpdate() {
            if (!this.$refs.ruleFormRef) return;
            this.$refs.ruleFormRef.validate((valid) => {
                if (valid) {
                    console.log(this.form)
                    axios({
                        method: "put",
                        url: this.Globalstore.apiServer + "/products",
                        data: this.form,
                        headers: {
                            'Content-Type': 'multipart/form-data',
                        },
                        timeout: 1000,
                    })
                        .then(() => {
                            this.showTips("更新成功！", "success");

                        })
                        .catch(() => {
                            this.showTips("似乎出错了，未能修改", "danger");
                        });
                } else {
                    console.log("error submit!");
                    return false;
                }
            });
        },
        // 提交事件
        onAdd() {
            if (!this.$refs.ruleFormRef) return;
            this.$refs.ruleFormRef.validate((valid) => {
                console.log(this.form)
                if (valid) {
                    axios({
                        method: "post",
                        url: this.Globalstore.apiServer + "/products",
                        data: this.form,
                        headers: {
                            'Content-Type': 'multipart/form-data',
                        },
                        timeout: 1000,
                    })
                        .then(() => {
                            this.showTips("增加成功！", "success");
                            // 重载画面
                            this.$router.go('/Admin')
                        })
                        .catch(() => {
                            this.showTips("似乎出错了，未能增加", "danger");
                        });
                } else {
                    console.log("error submit!");
                    return false;
                }
            });
        }
    },
    mounted() {
        // console.log(this.originImage)
        this.getType();
        this.form = this.form.value
    }
}
</script>