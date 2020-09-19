<%@page import="com.sample.service.UserService"%>
<%@page import="com.sample.web.view.User"%>
<%@page import="com.fasterxml.jackson.annotation.JsonTypeInfo.Id"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1">

<title>같이 보자! 공공연한사이</title>
<link rel="stylesheet" href="/resources/css/jquery.fullPage.css">
<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.5.0/css/bootstrap.css">
<link rel="stylesheet" href="/resources/bootstrap-datepicker/css/bootstrap-datepicker.min.css">
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.8.2/css/all.min.css" />
<link rel="stylesheet" href="/resources/css/style.css" />
<script src="https://code.jquery.com/jquery-3.5.1.min.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.16.0/umd/popper.min.js"></script>
<script src="https://maxcdn.bootstrapcdn.com/bootstrap/4.5.0/js/bootstrap.js"></script>
<script src="/resources/bootstrap-datepicker/js/bootstrap-datepicker.min.js"></script>
<script src="/resources/bootstrap-datepicker/locales/bootstrap-datepicker.ko.min.js"></script>
<script type="text/javascript" src="/resources/js/jquery.color.js"></script>
<script type="text/javascript" src="/resources/js/custom.js"></script>
</head>
<body>
<div class="header">
<%@ include file="../common/navi.jsp" %>
</div>
<div class="container " style="margin-top: 150px;">
	<c:if test="${param.error eq 'fail' }">
		<div class="row">
			<div class="col-6 mx-auto" >
				<div class="row pl-3">
					<div class="col-8">
						<div class="alert alert-danger " style="font-size: 15px;">
							<strong>아이디 혹은 비밀번호가 일치하지 않습니다.</strong>
						</div>
					</div>
				</div>
			</div>
		</div>
	</c:if>
	<div class="row ">
		<div class="col-6 mx-auto" >
			<div class="row">
				<div class="col-12">
					<img src="/resources/logo/gongsaLogo.png" width="360px;"  />
				</div>
			</div>
			<form:form  id="signin-form" method="POST" action="signin.do" modelAttribute="loginForm">
				<div class="card border-0">
					
					<div class="card-header bg-white text-black font-weight-bolder card border-0" style="margin-left: 100px;"><h4>회원 로그인</h4></div>
					<div class="card-body">
						<div class="form-row">
							<div class="form-group col-md-8">
      							<form:input type="text" class="form-control" id="id" path="id"  placeholder="아이디를 입력하세요" />
      							<form:errors path="id" cssClass="text-danger"></form:errors>
							</div>
						</div>
						<div class="form-row">
							<div class="form-group col-md-8">
      							<form:input type="password" class="form-control" id="password" path="password" placeholder="비밀번호를 입력하세요 " />
      							<form:errors path="password" cssClass="text-danger"></form:errors>
							</div>
						</div>
						<div class="form-row">
							<div class="form-group col-md-4 text-center mt-3">
      							<button type="submit" class="btn btn-info" style="width: 160px;">로 그 인</button>
							</div>
						<div class="form-group col-md-4 text-center mt-3">
      							<a href="term.do"><button type="button" class="btn btn-outline-secondary" style="width: 160px;">회원가입</button></a>
							</div>
						</div>
						<div class="form-row">
							<div class="form-group col-md-1.5">
								<p><a href="findId.do" style="color: gray"><small>아이디 찾기</small></a></p>
							</div>
							<div class="form-group col-md-3">
								<p><a href="findPwd.do" style="color: gray"><small>비밀번호 찾기</small></a></p>
							</div>
						</div>
					</div>
				</div>
			</form:form>
		</div>
	</div>
	<div class="row">
		<div class="col-6 mx-auto" >
			<div class="row">
				<div class="col-md-4 text-center mt-3">
					<button class="btn" type="button" id="kakao-login-btn"  style="margin-left: 22px;"><img src="/resources\sample-images\kakao.png" alt=""></button>
				</div>
			</div>

		
		</div>
	</div>
</div>


</body>

<script src="https://developers.kakao.com/sdk/js/kakao.js"></script>
<script src="https://t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>
<script type="text/javascript">

$("#kakao-login-btn").click(function() {
	$.ajax({
		type:"POST",
		url:"/sns/kakao.do",
		success:function(result){
			var restkey = result.kakaoRestKey;
			var url = result.serverUrl;
			location.href= "https://kauth.kakao.com/oauth/authorize?response_type=code&client_id="+restkey+"&redirect_uri="+url+"/sns/kakao.do";
		}
			
	})

});

$(function() {
	// 등록버튼 클릭시 실행됨
	$("#signin-form").submit(function() {
		checkAll(this);
	
	});
	
		function checkAll(form) {
		    if (!checkUserId(form.id.value)) {
		    	console.log(form.id.value);
		        return false;
		    } else if (!checkPassword(form.password.value)) {
		        return false; 
		    }
		    return true;
		}
		
		function checkExistData(value, dataName) {
		    if (value == "") {
		        alert(dataName + " 입력해주세요!");
		        return false;
		    }
		    return true;
		}
		
		function checkUserId(id) {
		    //Id가 입력되었는지 확인하기
		    if (!checkExistData(id, "아이디를")) {
		        return false;
		}
			return true;
	}
		function checkPassword(password) {
		    //Id가 입력되었는지 확인하기
		    if (!checkExistData(password, "비밀번호를")) {
		        return false;
		}
			return true;
	}

})


</script>

</html>