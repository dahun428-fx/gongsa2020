<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
	<nav id="sidebar" class="sidebar-wrapper">
		<div class="sidebar-content">
			<div class="sidebar-brand">
				<a href="/admin/home.do" class="h3"> <img class="ml-3" id="brand-logo"
					style="width: 170px;" src="/resources/logo/gongsaLogo2.png" /> <span
					class="text-white" style="display: block;">관리자페이지</span>
				</a>
				<div id="close-sidebar">
					<i class="fas fa-bars fa-2x"></i>
				</div>
			</div>
			<div class="sidebar-menu">
				<ul>
					<li class="sidebar-dropdown"><a href="#"> <i
							class="fas fa-theater-masks fa-2x"></i> <span>공연관리</span>
					</a>
						<div class="sidebar-submenu">
							<ul>
								<li><a href="/performance/add/step1.do" class="font-weight-bold">공연등록 </a></li>
								<li><a href="/performance/adminList.do">공연리스트</a></li>
							</ul>
						</div></li>
					<li class="sidebar-dropdown"><a href="#"> <i
							class="fas fa-user-friends"></i> <span>고객관리</span>
					</a>
						<div class="sidebar-submenu">
							<ul>
								<li><a href="/adminProfile.do"> 고객리스트 </a></li>
							</ul>
						</div></li>
					<li class="sidebar-dropdown"><a href="#"> <i
							class="fas fa-clipboard-list"></i> <span>메이트관리</span>
					</a>
						<div class="sidebar-submenu">
							<ul>
								<li><a href="/managerMate/mateManager.do">메이트 등록</a></li>
								<li><a href="/managerMate/mateList.do">메이트 리스트</a></li>
								
							</ul>
						</div></li>
					<li class="sidebar-dropdown"><a href="#"> <i
							class="fas fa-question-circle"></i> <span>고객문의센터관리</span>
					</a>
						<div class="sidebar-submenu">
							<ul>
								<li><a href="/admin/notice/list.do">공지사항</a></li>
								<li><a href="/admin/qna/list.do">QnA</a></li>
							</ul>
						</div></li>
					<li class="sidebar-dropdown"><a href="#"> <i
							class="fa fa-globe"></i> <span>매출관리</span>
					</a>
						<div class="sidebar-submenu">
							<ul>
								<li><a href="/payment/admin_payment.do">결제현황</a></li>
								<li><a href="#">결제수단</a></li>
								<li><a href="#">총매출</a></li>
							</ul>
						</div></li>
				</ul>
			</div>
			<!-- sidebar-menu  -->
		</div>
		<div class="sidebar-footer">
			<a href="/home.do"><i class="fas fa-home custom-color"></i></a>
		</div>
		<!-- sidebar-content  -->
	</nav>
<script type="text/javascript">
	$(".page-wrapper").removeClass('toggled');
$(".sidebar-dropdown > a").click(function() {
	  $(".sidebar-submenu").slideUp(200);
	  if (
	    $(this)
	      .parent()
	      .hasClass("active")
	  ) {
	    $(".sidebar-dropdown").removeClass("active");
	    $(this)
	      .parent()
	      .removeClass("active");
	  } else {
	    $(".sidebar-dropdown").removeClass("active");
	    $(this)
	      .next(".sidebar-submenu")
	      .slideDown(200);
	    $(this)
	      .parent()
	      .addClass("active");
	  }
	});

	$("#close-sidebar").click(function() {
	  $(".page-wrapper").toggleClass("toggled");
	});
	$("#show-sidebar").click(function() {
	  $(".page-wrapper").addClass("toggled");
	});


</script>