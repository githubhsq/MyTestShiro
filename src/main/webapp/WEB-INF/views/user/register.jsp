<%--
  Created by IntelliJ IDEA.
  User: hsq
  Date: 2018/1/9
  Time: 16:58
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    String path = request.getContextPath();
    String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path;
%>
<html>
<head>
    <meta charset="UTF-8">
    <title>Document</title>
    <style>
        *{
            margin: 0px;
            padding: 0px;
        }
        html,body{
            background-color: #789;
        }
        .logo-box{
            position: absolute;
            top: 0px;
            left: 0px;
            right: 0px;
            bottom: 0px;
            margin: auto;
            width: 500px;
            height: 350px;
        }
        .logo-input{
            width: 100%;
            height: 80px;
            font-size: 0px;
            line-height: 80px;
            box-sizing: border-box;
            padding:0px 100px;
        }
        .input{
            display: inline-block;
            height: 40px;
            width: 90%;
            padding-left: 20px;
            font-size: 18px;
            border-radius: 4px;
        }
        .logo-input span{
            color: #fff;
            display: inline-block;
            width: 100px;
            height: 30px;
            font-size: 14px;
            vertical-align: top;
            margin-top: -8px;
            margin-left: 5px;
        }
        .btnbox{
            display: flex;
            justify-content: space-between;
        }
        .btn{
            width: 48%;
            height: 40px;
            background-color: blue;
            border-radius: 6px;
            line-height: 40px;
            font-size: 16px;
            text-align: center;
            color: #fff;
            cursor: pointer;
        }
        .btnbox .bgcolor{
            background-color: red;
        }
    </style>
</head>
<body>
    <div class="logo-box">
        <div class="logo-input">
            <input class="Account-input input" type="text" id="username" class="username" placeholder="Account" />
        </div>
        <div class="logo-input">
            <input class="password-input input" type="password" id="password" class="password" placeholder="Password" />
        </div>
        <div class="logo-input">
            <input class="checkbox-input" type="checkbox" id="rememberMe" />
            <span>记住我</span>
        </div>
        <div class="error"><span>+</span></div>
        <div class="logo-input btnbox">
            <div class="btn bgcolor"  id="login">登录</div>
            <div class="btn" id="register">Register</div>
        </div>
    </div>


</body>
<!-- Javascript -->

<script  src="<%=basePath%>/js/common/jquery/jquery1.8.3.min.js"></script>
<script  src="<%=basePath%>/js/common/MD5.js"></script>
<script  src="<%=basePath%>/js/common/supersized.3.2.7.min.js"></script>
<script  src="<%=basePath%>/js/common/supersized-init.js"></script>
<script  src="<%=basePath%>/js/common/layer/layer.js"></script>
<script >
    jQuery(document).ready(function() {
        //回车事件绑定
        document.onkeydown=function(event){
            var e = event || window.event || arguments.callee.caller.arguments[0];
            if(e && e.keyCode==13){
                userLogin();
            }
        };

        //登录操作
        $('#login').on("click",userLogin);

        //注册
        $("#register").click(function(){
            window.location.href="register.shtml";
        });
    });

    function userLogin() {
            var username = $('#username').val();
            var password = $('#password').val();
            if(username == undefined) {
                $('.error').fadeOut('fast', function(){
                    $('.error').css('top', '27px').show();
                });
                $('.error').fadeIn('fast', function(){
                    $('.username').focus();
                });
                return false;
            }
            if(password == undefined) {
                $('.error').fadeOut('fast', function(){
                    $('.error').css('top', '96px').show();
                });
                $(this).find('.error').fadeIn('fast', function(){
                    $('.password').focus();
                });
                return false;
            }
            var pswd = MD5(username +"#" + password);
            var entity = new Object();
            entity.pswd = pswd;
            entity.email = username;
            entity.rememberMe = $("#rememberMe").is(':checked');
            var load = layer.load();
            $.ajax({
                url:"<%=basePath%>/u/submitLogin",
                data:entity,
                type:"post",
                dataType:"json",
                async: false,
                beforeSend:function(){
                    layer.msg('开始登录，请注意后台控制台。');
                },
                success:function(result){
                    layer.close(load);
                    if(result && result.status != 200){
                        layer.msg(result.message);
                        $('#password').val('');
                        return;
                    }else{
                        layer.msg('登录成功！');
                        setTimeout(function(){
                            //登录返回
                            window.location.href= "../../../user/index.html";
                        },1000)
                    }
                },
                error:function(e){
                    console.log(e,e.message);
                    layer.msg('请看后台Java控制台，是否报错，确定已经配置数据库和Redis',new Function());
                }
            });
        }

</script>
</html>
