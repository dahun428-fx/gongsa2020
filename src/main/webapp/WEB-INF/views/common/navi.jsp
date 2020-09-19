<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
		<input type="hidden" id="login-type" value="${LOGIN_TYPE }" />
		<nav class="navbar sticky-top transparent custom-color" id="navbar-top">
			<!-- side navi bar btn -->
			<div class="col-1">
				<button id="sidebarCollapse" class="btn navbar-toggler"
					type="button" data-toggle="collapse">
					<div id="sidenav-icon">
						<span></span> <span></span> <span></span> <span></span> <span></span>
						<span></span>
					</div>
				</button>
			</div>
			<!-- side navi bar btn -->
			<!-- brand name, title -->
			<div class="col-3 text-left">
				<a class="navbar-brand font-weight-bolder" href="/home.do"> <span
					class="h2 font-weight-bolder custom-color"><img id="brand-logo" style="width: 220px;" src="/resources/logo/gongsaLogo.png"/></span>
				</a>
			</div>
			<!-- brand name, title -->
			<!-- search bar -->
			<div class="col-4">
				<form class="form-inline mr-sm-2 searchform" id="totalSearchForm"
				action="/performance/totalList.do" method="get">
					<input type="search" class="form-control" id="search-box"
					name="title"/>
					<a class="btn" type="button" id="totalSearchBtn">
						<i class="fas fa-search fa-2x custom-color"></i>
					</a>
				</form>
			</div>
			<!-- search bar -->
			<!-- user icons -->
			<div class="col-4 text-right">
			
			<c:choose>
				<c:when test="${empty LOGIN_USER}">
					<div>
					<a href="/signin.do" class="btn" type="button">
					<span class="h4 custom-color">Login   </span>
						<i class="fas fa-sign-in-alt fa-2x custom-color"></i>
					</a>
					</div>
				</c:when>
				<c:otherwise>
					<div>
					<c:if test="${LOGIN_USER.admin == true }">
					<a href="/admin/home.do" target="_blank" class="btn" id="adminopen">
						<i class="fas fa-cog fa-2x custom-color"></i>
					</a>
					</c:if>
					<a class="btn" href="/mypage/mypagemain.do">
						<i class="far fa-user fa-2x custom-color"></i>
					</a>
					<a href="/signout.do" class="btn" type="button" id="btn-logout">
						<i class="fas fa-sign-out-alt fa-2x custom-color"></i>
					</a>
					</div>
				</c:otherwise>
			</c:choose>
			
			</div>
			<!-- user icons -->
		</nav>
		<!-- Vertical navbar -->
		<nav class="vertical-nav active" id="sidebar">
			<div class="row">
				<div class="col-12 sidebar-top"></div>
			</div>

			<ul class="nav flex-column m-3">
				<li class="nav-item dropdown">
					<ul class="list-unstyled components mb-5">
						<li><a href="/performance/list.do?category=콘서트" class="h4">콘서트</a></li>
						<li><a href="/performance/list.do?category=뮤지컬" class="h4">뮤지컬</a></li>
						<li><a href="/performance/list.do?category=연극" class="h4">연극</a></li>
						<li><a href="/notice/list.do" class="h4">공지사항</a></li>
						<li><a href="#customcenter" data-toggle="collapse" aria-expanded="false"
							 class="dropdown-toggle h4">고객문의센터</a>
							<ul class="collapse list-unstyled" id="customcenter">
								<li><a href="/qna/list.do" class="h6">QnA</a></li>
								<li><a href="/notice/list.do" class="h6">공지사항</a></li>
							</ul>
						
						</li>
					<c:if test="${not empty LOGIN_USER }">
						<li><a href="#mypage" data-toggle="collapse" aria-expanded="false"
							class="dropdown-toggle h4">마이페이지</a>
							<ul class="collapse list-unstyled" id="mypage">
								<li><a href="/mypage/myperformance.do" class="h6">예매내역</a></li>
								<li><a href="/mypage/mymateroom.do" class="h6">메이트방</a></li>
								<li><a href="/mypage/myprofile.do" class="h6">나의프로필</a></li>
								<li><a href="/mypage/mypagemain.do" class="h6">관심공연</a></li>
								<li><a href="/mypage/mypagemain.do" class="h6">나의쿠폰</a></li>
								<li><a href="/mypage/mypagemain.do" class="h6">나의포인트</a></li>
							</ul>
						
						</li>
					</c:if>	
					</ul>
				</li>
			</ul>
		</nav>
<script>
$(function() {
	$("#btn-logout").click(function(event) {
		event.preventDefault();
		
		var loginType = $("#login-type").val();
		
		if (loginType == 'web') {
			location.href = "/signout.do";
		} else if (loginType == "sns") {
			
			$.ajax({
				type:"POST",
				url:"/sns/kakao.do",
				success:function(result){
					var restkey = result.kakaoRestKey;
					var url = result.serverUrl;
					location.href= "https://kauth.kakao.com/oauth/logout?client_id="+restkey+"&logout_redirect_uri="+url+"/sns/logout.do";
				}
				
			})
			
		}
		
		
	});
	
	$("#totalSearchBtn").click(function() {
		console.log("전체검색누름");
		
		$("#totalSearchForm").submit();
	});

})
</script>
 