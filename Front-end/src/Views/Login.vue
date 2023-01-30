<template>
    <section class="user">
        <div class="user_options-container">
            <div class="user_options-text">
                <div class="user_options-unregistered">
                    <h2 class="user_unregistered-title">没有帐户？</h2>
                    <!-- <p class="user_unregistered-text"> 只有经历过地狱般的磨砺，才能练就创造天堂的力量； 只有流过血的手指，才能弹出世间的绝响</p> -->
                    <button class="user_unregistered-signup" id="signup-button" @click="signup">立马白嫖一个</button>
                </div>

                <div class="user_options-registered">
                    <h2 class="user_registered-title">已有账户？</h2>
                    <!-- <p class="user_registered-text">有一个夜晚我烧毁了所有的记忆,从此我的梦就透明了,有一个早晨我扔掉了所有的昨天,从此我的脚步就轻盈了。</p> -->
                    <button class="user_registered-login" id="login-button" @click="login()">立马上我大号</button>
                </div>
            </div>

            <div :class="formClass" id="user_options-forms">
                <div class="user_forms-login">
                    <h2 class="forms_title">Login</h2>
                    <form class="forms_form">
                        <fieldset class="forms_fieldset">
                            <div class="forms_field">
                                <input v-model="user.username" type="text" placeholder="默认:user"
                                    class="forms_field-input" required autofocus />
                            </div>
                            <div class="forms_field">
                                <input v-model="user.password" type="password" placeholder="默认:user"
                                    class="forms_field-input" required />
                            </div>
                        </fieldset>
                        <div class="forms_buttons">
                            <button type="button" class="forms_buttons-forgot">忘记密码?</button>
                            <input type="submit" value="登录" @click="handleLogin()" class="forms_buttons-action">
                        </div>
                    </form>
                </div>
                <div class="user_forms-signup">
                    <h2 class="forms_title">Sign Up</h2>
                    <form class="forms_form">
                        <fieldset class="forms_fieldset">
                            <div class="forms_field">
                                <input type="text" v-model="user.username" placeholder="昵称" class="forms_field-input" required />
                            </div>
                            <div class="forms_field">
                                <input type="email" v-model="user.email" placeholder="邮箱" class="forms_field-input" required />
                            </div>
                            <div class="forms_field">
                                <input type="password"  v-model="user.password" placeholder="密码" class="forms_field-input" required />
                            </div>
                        </fieldset>
                        <div class="forms_buttons">
                            <input type="submit" value="注册" @click="handleRegister()" class="forms_buttons-action">
                        </div>
                    </form>
                </div>
            </div>
        </div>
    </section>
</template>

<script>
import axios from 'axios';
import { userStore } from '../store/store'
import { ElMessage } from 'element-plus';
export default {
    setup() {
        const store = userStore();
        return {
            store //响应式数据
        }
    },
    data() {
        return {
            user: {
                username: "",
                password: "",
                email:""
            },
            formClass: [
                "user_options-forms",
                "bounceRight"
            ]
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
        login() {
            this.formClass.pop('bounceLeft')
            this.formClass.push('bounceRight')
        },
        signup() {
            this.formClass.pop('bounceRight')
            this.formClass.push('bounceLeft')
        },
        handleLogin() {
            axios.post(
                'http://localhost:53000/login',
                {
                    nikename: this.user.username,
                    password: this.user.password
                },
                {
                    headers: {
                        'Content-Type': 'multipart/form-data',
                    }
                })
                .then(res => {
                    console.log(res.data)
                    if (res.status == 200 && res.data == "success") {
                        sessionStorage.setItem('username', this.user.username)
                        // this.store.login()
                        this.showTips("登陆成功！", "success")
                        this.$router.push("/User/info")
                    } else if (res.data === 'error') {
                        this.showTips("用户名和密码错啦！再想想吧！", "danger")
                        return
                    }
                })
                .catch(() => {
                    this.showTips("服务器崩溃了...")
                })
        },
        handleRegister() {
            // this.showTips(this.user.username)
            axios.post(
                'http://localhost:53000/user',
                {
                    nikename: this.user.username,
                    password: this.user.password,
                    email:this.user.email
                },
                {
                    headers: {
                        'Content-Type': 'multipart/form-data',
                    }
                })
                .then(res => {
                    if (res.status === 200 && res.data=="success") {
                        this.showTips("恭喜你成为我们的一份子！", "success")
                        this.$router.push("/")
                    } else if (res.data === 'error') {
                        this.showTips("www", "danger")
                    }
                }).catch(() => {
                    this.showTips("服务器崩溃了...")
                })

        }

    }
}
</script>
<style>
* {
    box-sizing: border-box;
}

body {
    font-family: "Montserrat", sans-serif;
    font-size: 12px;
    line-height: 1em;
}

button {
    background-color: transparent;
    padding: 0;
    border: 0;
    outline: 0;
    cursor: pointer;
}

input {
    background-color: transparent;
    padding: 0;
    border: 0;
    outline: 0;
}

input[type=submit] {
    cursor: pointer;
}

input::-moz-placeholder {
    font-size: 0.85rem;
    font-family: "Montserrat", sans-serif;
    font-weight: 300;
    letter-spacing: 0.1rem;
    color: #ccc;
}

input:-ms-input-placeholder {
    font-size: 0.85rem;
    font-family: "Montserrat", sans-serif;
    font-weight: 300;
    letter-spacing: 0.1rem;
    color: #ccc;
}

input::placeholder {
    font-size: 0.85rem;
    font-family: "Montserrat", sans-serif;
    font-weight: 300;
    letter-spacing: 0.1rem;
    color: #ccc;
}

@-webkit-keyframes bounceLeft {
    0% {
        transform: translate3d(100%, -50%, 0);
    }

    50% {
        transform: translate3d(-30px, -50%, 0);
    }

    100% {
        transform: translate3d(0, -50%, 0);
    }
}

@keyframes bounceLeft {
    0% {
        transform: translate3d(100%, -50%, 0);
    }

    50% {
        transform: translate3d(-30px, -50%, 0);
    }

    100% {
        transform: translate3d(0, -50%, 0);
    }
}

@-webkit-keyframes bounceRight {
    0% {
        transform: translate3d(0, -50%, 0);
    }

    50% {
        transform: translate3d(calc(100% + 30px), -50%, 0);
    }

    100% {
        transform: translate3d(100%, -50%, 0);
    }
}

@keyframes bounceRight {
    0% {
        transform: translate3d(0, -50%, 0);
    }

    50% {
        transform: translate3d(calc(100% + 30px), -50%, 0);
    }

    100% {
        transform: translate3d(100%, -50%, 0);
    }
}



@-webkit-keyframes showSignUp {
    100% {
        opacity: 1;
        visibility: visible;
        transform: translate3d(0, 0, 0);
    }
}

@keyframes showSignUp {
    100% {
        opacity: 1;
        visibility: visible;
        transform: translate3d(0, 0, 0);
    }
}

/**
 * * Page background
 * */
.user {
    display: flex;
    justify-content: center;
    align-items: center;
    width: 100%;
    height: 100vh;
    background: rgb(250, 250, 242);
    background-size: cover;
}

.user_options-container {
    position: relative;
    width: 80%;
}

.user_options-text {
    display: flex;
    justify-content: space-between;
    width: 100%;
    background-color: rgba(34, 34, 34, 0.85);
    border-radius: 3px;
}

/**
 * * Registered and Unregistered user box and text
 * */
.user_options-registered,
.user_options-unregistered {
    width: 50%;
    padding: 75px 45px;
    color: #fff;
    font-weight: 300;
}

.user_registered-title,
.user_unregistered-title {
    margin-bottom: 15px;
    font-size: 1.66rem;
    line-height: 1em;
}

.user_unregistered-text,
.user_registered-text {
    font-size: 0.83rem;
    line-height: 1.4em;
}

.user_registered-login,
.user_unregistered-signup {
    margin-top: 30px;
    border: 1px solid #ccc;
    border-radius: 3px;
    padding: 10px 30px;
    color: #fff;
    text-transform: uppercase;
    line-height: 1em;
    letter-spacing: 0.2rem;
    transition: background-color 0.2s ease-in-out, color 0.2s ease-in-out;
}

.user_registered-login:hover,
.user_unregistered-signup:hover {
    color: rgba(34, 34, 34, 0.85);
    background-color: #ccc;
}

/**
 * * Login and signup forms
 * */
.user_options-forms {
    position: absolute;
    top: 50%;
    left: 30px;
    width: calc(50% - 30px);
    min-height: 420px;
    background-color: #fff;
    border-radius: 3px;
    box-shadow: 2px 0 15px rgba(0, 0, 0, 0.25);
    overflow: hidden;
    transform: translate3d(100%, -50%, 0);
    transition: transform 0.4s ease-in-out;
}

.user_options-forms .user_forms-login {
    transition: opacity 0.4s ease-in-out, visibility 0.4s ease-in-out;
}

.user_options-forms .forms_title {
    margin-bottom: 45px;
    font-size: 1.5rem;
    font-weight: 500;
    line-height: 1em;
    text-transform: uppercase;
    color: #e8716d;
    letter-spacing: 0.1rem;
}

.user_options-forms .forms_field:not(:last-of-type) {
    margin-bottom: 20px;
}

.user_options-forms .forms_field-input {
    width: 100%;
    border-bottom: 1px solid #ccc;
    padding: 6px 20px 6px 6px;
    font-family: "Montserrat", sans-serif;
    font-size: 1rem;
    font-weight: 300;
    color: gray;
    letter-spacing: 0.1rem;
    transition: border-color 0.2s ease-in-out;
}

.user_options-forms .forms_field-input:focus {
    border-color: gray;
}

.user_options-forms .forms_buttons {
    display: flex;
    justify-content: space-between;
    align-items: center;
    margin-top: 35px;
}

.user_options-forms .forms_buttons-forgot {
    font-family: "Montserrat", sans-serif;
    letter-spacing: 0.1rem;
    color: #ccc;
    text-decoration: underline;
    transition: color 0.2s ease-in-out;
}

.user_options-forms .forms_buttons-forgot:hover {
    color: #b3b3b3;
}

.user_options-forms .forms_buttons-action {
    background-color: #e8716d;
    border-radius: 3px;
    padding: 10px 35px;
    font-size: 1rem;
    font-family: "Montserrat", sans-serif;
    font-weight: 300;
    color: #fff;
    text-transform: uppercase;
    letter-spacing: 0.1rem;
    transition: background-color 0.2s ease-in-out;
}

.user_options-forms .forms_buttons-action:hover {
    background-color: #e14641;
}

.user_options-forms .user_forms-signup,
.user_options-forms .user_forms-login {
    position: absolute;
    top: 70px;
    left: 40px;
    width: calc(100% - 80px);
    opacity: 0;
    visibility: hidden;
    transition: opacity 0.4s ease-in-out, visibility 0.4s ease-in-out, transform 0.5s ease-in-out;
}

.user_options-forms .user_forms-signup {
    transform: translate3d(120px, 0, 0);
}

.user_options-forms .user_forms-signup .forms_buttons {
    justify-content: flex-end;
}

.user_options-forms .user_forms-login {
    transform: translate3d(0, 0, 0);
    opacity: 1;
    visibility: visible;
}

.user_options-forms.bounceLeft {
    -webkit-animation: bounceLeft 1s forwards;
    animation: bounceLeft 1s forwards;
}

.user_options-forms.bounceLeft .user_forms-signup {
    -webkit-animation: showSignUp 1s forwards;
    animation: showSignUp 1s forwards;
}

.user_options-forms.bounceLeft .user_forms-login {
    opacity: 0;
    visibility: hidden;
    transform: translate3d(-120px, 0, 0);
}

.user_options-forms.bounceRight {
    -webkit-animation: bounceRight 1s forwards;
    animation: bounceRight 1s forwards;
}

/**
 * * Responsive 990px
 * */
@media screen and (max-width: 990px) {
    .user_options-forms {
        min-height: 350px;
    }

    .user_options-forms .forms_buttons {
        flex-direction: column;
    }

    .user_options-forms .user_forms-login .forms_buttons-action {
        margin-top: 30px;
    }

    .user_options-forms .user_forms-signup,
    .user_options-forms .user_forms-login {
        top: 40px;
    }

    .user_options-registered,
    .user_options-unregistered {
        padding: 50px 45px;
    }
}

.forms_fieldset {
    border: none;
}
</style>