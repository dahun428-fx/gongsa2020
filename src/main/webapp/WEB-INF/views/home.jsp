<%@page import="com.sample.web.view.User"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@taglib prefix="rutil" uri="com.sample.gongsa" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>같이 보자! 공공연한사이</title>
<link rel="stylesheet" href="/resources/css/jquery.fullPage.css">
<link rel="stylesheet" href="/resources/css/style.css" />
<link rel="stylesheet"
	href="https://maxcdn.bootstrapcdn.com/bootstrap/4.5.0/css/bootstrap.css">
<link rel="stylesheet"
	href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.8.2/css/all.min.css" />
<script src="https://code.jquery.com/jquery-3.5.1.min.js"></script>
<script
	src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.16.0/umd/popper.min.js"></script>
<script type="text/javascript" src="/resources/js/custom.js"></script>
<script
	src="https://maxcdn.bootstrapcdn.com/bootstrap/4.5.0/js/bootstrap.js"></script>
<script type="text/javascript" src="/resources/js/jquery.color.js"></script>
</head>
<style>
.card-img-top:hover{
	 cursor:pointer;
	 transform: scale(1.1);
	 -webkit-transition: transform 0.7s ease-in-out;
	 background-color: rgba(1,1,1,0.7);
}
</style>
<body>
	<!-- header start -->
	<header>
<%@ include file="common/navi.jsp" %>
	</header>
	<!-- header end -->
	<!-- body -->
	<div class="body">
		<div id="fullpage">
			<div class="section" id="section1">
				<c:if test="${not empty conserts }">
				<c:forEach var="consert" items="${conserts }">
					<div class="slide">
						<div class="row">
							<div class="col-4 text-center ele-opacity" style="margin: auto 0;">
								<div class="text-white font-weight-bolder" style="font-size: 2rem;">${consert.category }</div>
								<hr style="background-color: #fff;"/>
								<div class="text-white font-weight-bold" style="font-size: 4rem;" >${consert.title }</div>
								<div class="text-white" style="font-size: 2rem;">
									<span><fmt:formatDate value="${consert.startDate }"
											pattern="yyyy.MM.dd" /></span> <span>~</span> <span><fmt:formatDate
										value="${consert.endDate }" pattern="yyyy.MM.dd" /></span>
									<div>${consert.hallName }</div>
								</div>
							</div>
							<div class="col-4">
								<div class="d-flex justify-content-center">
								<!-- card -->
									<div class="card shadow transfrom-card" style="width: 30rem;">
										<div class="card-body">
										<c:choose>
											 <c:when test="${fn:substring(consert.imagePath, 0,4) eq 'http' }">
											 	<c:set var="path" value="${consert.imagePath }"/>
											 </c:when>
											 <c:otherwise>
											 	<c:set var="path" value="/resources/sample-images/${consert.imagePath }"/>
											 </c:otherwise>
										 </c:choose> 
										 	<a href="/performance/totalList.do?title=${rutil:replaceTag(consert.title)}">
												<img class="card-img-top" style="width: 438px; height: 613px;" src="${path }" alt="" />
										 	</a>
										</div>
										<div class="card-footer">
											<div class="row">
												<div>
													<c:if test="${consert.title }"></c:if>
												</div>
												<div class="col-9 text-center">
												 	<div class="d-flex justify-content-start">
														 <c:forEach var="genre" items="${consert.genres }"> 
															 <a	style="padding: 0; margin: 0" class="btn btn-link text-left" href="/performance/list.do?category=${consert.category }&genre=${genre }">
															 	#${genre }
															 </a>
														</c:forEach>
												 	</div>
												</div>
												<div class="col-3 text-right">
													<a href="/performance/totalList.do?title=${rutil:replaceTag(consert.title)}" class="btn">
														<i class="fas fa-chevron-circle-right fa-2x text-danger"></i>
													</a>
												</div>
											</div>
										</div>
									</div>
								<!-- card -->
								</div>
							</div>
							<div class="col-4 text-center" style="margin: auto 0; padding: 100px;">
								<div class="row">
									<div class="col-12 card bg-dark shadow">
									
										<div class="row mt-3 mb-2">
											<div class="col-12 bg-white rounded-top shadow" style="padding: 30px;">
												<div class="text-secondary h3 font-weight-bold">메이트 모집중
												</div>
											</div>
											<div class="col-12 text-white">
											<c:forEach items="${consertSeatList }" var="seat">
												<c:if test="${seat.title eq consert.title }">
												
												<div class="row">
													<div class="col-4 bg-primary p-3">
														<span class="h3">R석</span>
														<div class="h5 mt-2">${seat.R } <span>석</span></div>
													</div>
													<div class="col-4 bg-warning p-3">
														<span class="h3">S석</span>
														 <div class="h5 mt-2">${seat.S } <span>석</span></div>
													</div>
													<div class="col-4 bg-danger p-3">
														<span class="h3">A석</span>
														<div class="h5 mt-2">${seat.A } <span>석</span></div>
													</div>
												</div>
												</c:if>
											</c:forEach>
											</div>
											<div class="col-12 bg-white rounded-bottom shadow">
												<div class="mt-4 mb-4">
													<div class="d-flex justify-content-center">
														<a class="btn btn-outline-primary btn-lg" href="/payment/step1.do?no=${consert.id }">
															예매하기
														</a>
													</div>
												</div>
											</div>
										</div>
									</div>
								</div>
							</div>
						</div>
					</div>
				</c:forEach>
				</c:if>
			</div>
			<div class="section" id="section2">
			<c:if test="${not empty musicals }">
				<c:forEach var="musical" items="${musicals }">
					<div class="slide">
						<div class="row">
							<div class="col-4 text-center ele-opacity" style="margin: auto 0;">
								<div class="text-white font-weight-bolder" style="font-size: 2rem;">${musical.category }</div>
								<hr style="background-color: #fff;"/>
								<div class="text-white font-weight-bold" style="font-size: 4rem;" >${musical.title }</div>
								<div class="text-white" style="font-size: 2rem;">
									<span><fmt:formatDate value="${musical.startDate }"
											pattern="yyyy.MM.dd" /></span> <span>~</span> <span><fmt:formatDate
										value="${musical.endDate }" pattern="yyyy.MM.dd" /></span>
									<div>${musical.hallName }</div>
								</div>
							</div>
							<div class="col-4">
								<div class="d-flex justify-content-center">
								<!-- card -->
									<div class="card shadow transfrom-card" style="width: 30rem;">
										<div class="card-body">
										<c:choose>
											 <c:when test="${fn:substring(musical.imagePath, 0,4) eq 'http' }">
											 	<c:set var="path" value="${musical.imagePath }"/>
											 </c:when>
											 <c:otherwise>
											 	<c:set var="path" value="/resources/sample-images/${musical.imagePath }"/>
											 </c:otherwise>
										 </c:choose>
										
										 	<a href="/performance/totalList.do?title=${rutil:replaceTag(musical.title)}">
												<img class="card-img-top" style="width: 438px; height: 613px;" src="${path }" alt="" />
										 	</a>
										</div>
										<div class="card-footer">
											<div class="row">
												<div class="col-9 text-center">
												 <c:forEach var="genre" items="${musical.genres }"> 
												 <a	class="btn btn-link" href="/performance/list.do?category=${musical.category }&genre=${genre }">
												 	#${genre }
												 </a>
												</c:forEach>
												</div>
												<div class="col-3 text-right">
													<a href="/performance/totalList.do?title=${rutil:replaceTag(musical.title)}" class="btn">
														<i class="fas fa-chevron-circle-right fa-2x text-danger"></i>
													</a>
												</div>
											</div>
										</div>
									</div>
								<!-- card -->
								</div>
							</div>
							<div class="col-4 text-center" style="margin: auto 0; padding: 100px;">
								<div class="row">
									<div class="col-12 card bg-dark shadow">
									
										<div class="row mt-3 mb-2">
											<div class="col-12 bg-white rounded-top shadow" style="padding: 30px;">
												<div class="text-secondary h3 font-weight-bold">메이트 모집중
												</div>
											</div>
											<div class="col-12 text-white">
											<c:forEach items="${musicalsSeatList }" var="seat">
												<c:if test="${seat.title eq musical.title }">
												
												<div class="row">
													<div class="col-4 bg-primary p-3">
														<span class="h3">R석</span>
														<div class="h5 mt-2">${seat.R } <span>석</span></div>
													</div>
													<div class="col-4 bg-warning p-3">
														<span class="h3">S석</span>
														 <div class="h5 mt-2">${seat.S } <span>석</span></div>
													</div>
													<div class="col-4 bg-danger p-3">
														<span class="h3">A석</span>
														<div class="h5 mt-2">${seat.A } <span>석</span></div>
													</div>
												</div>
												</c:if>
											</c:forEach>
											</div>
											<div class="col-12 bg-white rounded-bottom shadow">
												<div class="mt-4 mb-4">
													<div class="d-flex justify-content-center">
														<a class="btn btn-outline-primary btn-lg" href="/payment/step1.do?no=${musical.id }">
															예매하기
														</a>
													</div>
												</div>
											</div>
										</div>
									</div>
								</div>
							</div>
						</div>
					</div>
				</c:forEach>
			</c:if>	
			</div>
			<div class="section" id="section3">
			<c:if test="${not empty theaters }">
				<c:forEach var="theater" items="${theaters }">
					<div class="slide">
						<div class="row">
							<div class="col-4 text-center ele-opacity" style="margin: auto 0;">
								<div class="text-white font-weight-bolder" style="font-size: 2rem;">${theater.category }</div>
								<hr style="background-color: #fff;"/>
								<div class="text-white font-weight-bold" style="font-size: 4rem;" >${theater.title }</div>
								<div class="text-white" style="font-size: 2rem;">
									<span><fmt:formatDate value="${theater.startDate }"
											pattern="yyyy.MM.dd" /></span> <span>~</span> <span><fmt:formatDate
										value="${theater.endDate }" pattern="yyyy.MM.dd" /></span>
									<div>${theater.hallName }</div>
								</div>
							</div>
							<div class="col-4">
								<div class="d-flex justify-content-center">
								<!-- card -->
									<div class="card shadow transfrom-card" style="width: 30rem;">
										<div class="card-body">
										<c:choose>
											 <c:when test="${fn:substring(theater.imagePath, 0,4) eq 'http' }">
											 	<c:set var="path" value="${theater.imagePath }"/>
											 </c:when>
											 <c:otherwise>
											 	<c:set var="path" value="/resources/sample-images/${theater.imagePath }"/>
											 </c:otherwise>
										 </c:choose>
										 	<a href="/performance/totalList.do?title=${rutil:replaceTag(theater.title)}">
												<img class="card-img-top" style="width: 438px; height: 613px;" src="${path }" alt="" />
										 	</a>
										</div>
										<div class="card-footer">
											<div class="row">
												<div class="col-9 text-center">
												 <c:forEach var="genre" items="${theater.genres }"> 
												 <a	class="btn btn-link" href="/performance/list.do?category=${theater.category }&genre=${genre }">
												 	#${genre }
												 </a>
												</c:forEach>
												</div>
												<div class="col-3 text-right">
													<a href="/performance/totalList.do?title=${rutil:replaceTag(theater.title)}" class="btn">
														<i class="fas fa-chevron-circle-right fa-2x text-danger"></i>
													</a>
												</div>
											</div>
										</div>
									</div>
								<!-- card -->
								</div>
							</div>
							<div class="col-4 text-center" style="margin: auto 0; padding: 100px;">
								<div class="row">
									<div class="col-12 card bg-dark shadow">
									
										<div class="row mt-3 mb-2">
											<div class="col-12 bg-white rounded-top shadow" style="padding: 30px;">
												<div class="text-secondary h3 font-weight-bold">메이트 모집중
												</div>
											</div>
											<div class="col-12 text-white">
											<c:forEach items="${theatersSeatList }" var="seat">
												<c:if test="${seat.title eq theater.title }">
												
												<div class="row">
													<div class="col-4 bg-primary p-3">
														<span class="h3">R석</span>
														<div class="h5 mt-2">${seat.R } <span>석</span></div>
													</div>
													<div class="col-4 bg-warning p-3">
														<span class="h3">S석</span>
														 <div class="h5 mt-2">${seat.S } <span>석</span></div>
													</div>
													<div class="col-4 bg-danger p-3">
														<span class="h3">A석</span>
														<div class="h5 mt-2">${seat.A } <span>석</span></div>
													</div>
												</div>
												</c:if>
											</c:forEach>
											</div>
											<div class="col-12 bg-white rounded-bottom shadow">
												<div class="mt-4 mb-4">
													<div class="d-flex justify-content-center">
														<a class="btn btn-outline-primary btn-lg" href="/payment/step1.do?no=${theater.id }">
															예매하기
														</a>
													</div>
												</div>
											</div>
										</div>
									</div>
								</div>
							</div>
						</div>
					</div>
				</c:forEach>
			</c:if>	
			</div>
			<!-- home footer -->
			<div class="fp-auto-height section" id="section4">
				<div class="footer" style="height: 200px;">
					 <%@ include file="common/footer.jsp" %>
				</div>
			</div>
		</div>
	</div>
	<!-- body -->

	<script
		src="https://cdnjs.cloudflare.com/ajax/libs/fullPage.js/2.8.9/jquery.fullPage.min.js"></script>
	<script type="text/javascript">
		$(document).ready(function() {
			$('.ele-opacity').css('opacity','0').animate({
				opacity:'1'
			}, 2000);
			
			
			$('#fullpage').fullpage({
				//options here
				slidesNavigation : true,
				slidesNavPosition : 'bottom',
				autoScrolling : true,
				navigation : true,
				controlArrows : false,
				navigationPosition : 'right',
				sectionsColor : [ '#4F5051', '#C87D26', '#740039', '#000000' ],
				keyboardScrolling : true,
				afterRender: function () {
					setInterval(function () {
				    	$.fn.fullpage.moveSlideRight();
				    	$('.ele-opacity').css('opacity','0').animate({
							opacity:'1'
						}, 2000);
				    }, 5000);
			   }

			});

		});
	</script>

</body>
</html>