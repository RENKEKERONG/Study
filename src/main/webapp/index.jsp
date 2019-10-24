<%@ page contentType="text/html; charset=utf-8" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form" %>
<c:set var="basePath" value="${pageContext.request.contextPath}"/>
<!DOCTYPE html>
<html lang="zh-cn">
<head>
    <meta charset="UTF-8">
    <!-- import CSS -->
    <jsp:include page="/resources/vue.jsp" flush="true"/>
    <style>
        .el-image__error, .el-image__inner, .el-image__placeholder {
            width: 100%;
            height: 100%;
            position: fixed;
        }
    </style>
</head>
<body>
<div id="app">
    <template v-cloak style="position: center">
        <el-container style="background: #32ffa8;height: 20%;min-height:20vh;" direction="vertical">
<%--            <el-main>--%>
                <el-row style="">
                    <div class="demo-image__lazy">
                        <el-image style="width:30%" v-for="url in urls" :key="url" :src="url" lazy></el-image>
                    </div>
                </el-row>
                <el-row style="left: 500px;height: 500px;padding-top: 300px;">
                <el-form :model="ruleForm" status-icon :rules="rules" ref="ruleForm" label-width="100px" class="demo-ruleForm" style="width: 30%;">
                    <el-form-item label="用户名" prop="userName">
                        <el-input  icon="el-icon-s-comment" type="password" v-model.trim="loginForm.pass" autocomplete="off"></el-input>
                    </el-form-item>
                    <el-form-item label="密码" prop="passWord">
                        <el-input placeholder="请输入密码" v-model.trim="loginForm.passWord" show-password></el-input>
                    </el-form-item>
                    <el-form-item>
                        <el-checkbox v-model.trim="checked">记住密码</el-checkbox>
                    </el-form-item>
                    <el-form-item>
                        <el-button type="primary" @click="submitForm('ruleForm')">登录</el-button>
                    </el-form-item>
                </el-form>
                </el-row>
            </el-main>
        </el-container>
    </template>
</div>
</body>
<!-- import Vue before Element -->
<script src="https://unpkg.com/vue/dist/vue.js"></script>
<!-- import JavaScript -->
<script src="https://unpkg.com/element-ui/lib/index.js"></script>
<script>
    Vue.use(ELEMENT, {size: 'mini'});
    new Vue({
        el: '#app',
        data() {
            <!--自定义校验方法-->
            var checkAge = (rule, value, callback) => {
                if (!value) {
                    return callback(new Error('年龄不能为空'));
                }
                setTimeout(() => {
                    if (!Number.isInteger(value)) {
                        callback(new Error('请输入数字值'));
                    } else {
                        if (value < 18) {
                            callback(new Error('必须年满18岁'));
                        } else {
                            callback();
                        }
                    }
                }, 1000);
            };
            var validatePass = (rule, value, callback) => {
                if (value === '') {
                    callback(new Error('请输入密码'));
                } else {
                    if (this.ruleForm.checkPass !== '') {
                        this.$refs.ruleForm.validateField('checkPass');
                    }
                    callback();
                }
            };
            var validatePass2 = (rule, value, callback) => {
                if (value === '') {
                    callback(new Error('请再次输入密码'));
                } else if (value !== this.ruleForm.pass) {
                    callback(new Error('两次输入密码不一致!'));
                } else {
                    callback();
                }
            };
            var _$this = this;
            return {
                urls: [
                    'https://fuss10.elemecdn.com/d/e6/c4d93a3805b3ce3f323f7974e6f78jpeg.jpeg',
                ],
             //存放定义的Data
                loginForm: {
                    userName: '',
                    passWord: '',
                },
                rules: {
                    userName: [
                        { validator: validatePass, trigger: 'blur' }
                    ],
                    passWord: [
                        { validator: validatePass2, trigger: 'blur' }
                    ],
                    age: [
                        { validator: checkAge, trigger: 'blur' }
                    ]
                }
            };
        },
        mounted: function () {

        },
        created: function () {
        },
        methods: {
            submitForm(formName) {
                this.$refs[formName].validate((valid) => {
                    if (valid) {
                        alert('submit!');
                    } else {
                        console.log('error submit!!');
                        return false;
                    }
                });
            },
            resetForm(formName) {
                this.$refs[formName].resetFields();
            }
        }

    });
</script>
</html>
