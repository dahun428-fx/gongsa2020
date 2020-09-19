
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>같이 보자! 공공연한사이</title>
<link rel="stylesheet" href="/resources/css/jquery.fullPage.css">
<link rel="stylesheet"
	href="https://maxcdn.bootstrapcdn.com/bootstrap/4.5.0/css/bootstrap.css">
<link rel="stylesheet"
	href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.8.2/css/all.min.css" />
<link rel="stylesheet" href="/resources/css/style.css" />

<script src="https://code.jquery.com/jquery-3.5.1.min.js"></script>
<script
	src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.16.0/umd/popper.min.js"></script>
<script
	src="https://maxcdn.bootstrapcdn.com/bootstrap/4.5.0/js/bootstrap.js"></script>
<script type="text/javascript" src="/resources/js/jquery.color.js"></script>
<script type="text/javascript" src="/resources/js/custom.js"></script>
<script src='https://kit.fontawesome.com/a076d05399.js'></script>
<script src="https://cdn.jsdelivr.net/npm/chart.js@2.8.0"></script>

</head>
<body>
	<div class="header">
		<%@ include file="../common/navi.jsp"%>
	</div>

	<div class="body" style="margin-top: 50px;">
		<div class="container-fluid">
			<div class="row">
				<div class="col-12 mt-5 p-3 text-center">
					<div class="pl-3 font-weight-bold" style="font-size: 4rem;">
						<c:choose>
							<c:when test="${category eq '콘서트' }">
							CONSERT
						</c:when>
							<c:when test="${category eq '뮤지컬' }">
							MUSICAL
						</c:when>
							<c:when test="${category eq '연극' }">
							PLAY
						</c:when>
						</c:choose>
					</div>
				</div>
			</div>
			
			<div class="row h-50">
				<div class="col-12">
					<!-- 배너광고 슬라이드 시작  -->
					<div id="demo" class="carousel slide " data-ride="carousel">
						<ol class="carousel-indicators">
							<c:if test="${not empty slidePerformances }">
								<c:forEach var="performance" items="${slidePerformances }"
									varStatus="status">
									<li data-target="#demo" data-slide-to="${status.index }"
										class="${status.index == 0 ? 'active' : '' }"></li>
								</c:forEach>
							</c:if>
						</ol>
						<div class="carousel-inner ">
							<!--  한 슬라이드당 이미지 3개 -->
							<c:if test="${not empty slidePerformances }">
								<c:forEach var="performance" items="${slidePerformances }"
									varStatus="status">
									<c:set var="index" value="0" />
									<div
										class="carousel-item ${status.index == index ? 'active' : '' } bg-dark mb-5 pb-1 pt-4">
										<div class="row"
											style="width: 70%; height: 530px; float: none; margin: 0 auto;">
											<div class="col-12">
												<div class="row d-flex justify-content-center">
													<div class="col-4 text-center ele-opacity"
														style="margin: auto 0;">
														<div class="text-white font-weight-bolder"
															style="font-size: 2rem;">${performance.category }<c:out
																value="${status.end }"></c:out>
														</div>
														<hr style="background-color: #fff;" />
														<div class="text-white font-weight-bold slide-title-summary"
															style="font-size: 3rem;"><c:out value="${performance.title }"></c:out>
															</div>
														<div class="text-white mt-2" style="font-size: 1.8rem;">
															<span> <fmt:formatDate
																	value="${performance.startDate }" pattern="yyyy년 M월 d일" /> <br />
																~ <fmt:formatDate value="${performance.endDate }"
																	pattern="yyyy년 M월 d일" />
															</span>
															<div class="mt-4 slide-hallname-summary" style="font-size: 1.5rem;">${performance.hallName }</div>
														</div>
													</div>
													<div class="col-4">
														<div class="d-flex justify-content-center">
															<!-- card -->
															<div class="card shadow transfrom-card"
																style="width: 30rem;">
																<div class="card-body">
																	<c:choose>
																		<c:when
																			test="${fn:substring(performance.imagePath, 0,4) eq 'http' }">
																			<c:set var="path" value="${performance.imagePath }" />
																		</c:when>
																		<c:when test="${performance.imagePath eq '' }">
																		 	<c:set var="path" value="/resources/sample-images/noimage.png"/>
																		 </c:when>
																		<c:otherwise>
																			<c:set var="path"
																				value="/resources/sample-images/${performance.imagePath }" />
																		</c:otherwise>
																	</c:choose>
																	<img class="card-img-top img-thumbnail" src="${path }"
																		alt="" onclick="showDetail(${performance.id})"
																		style="cursor: pointer; width: 438px; height: 463px;" />																																		
																</div>
															</div>
															<!-- card 끝 -->
														</div>
													</div>
													<div class="col-4 text-center ele-opacity"
														style="margin: auto 0;">														
														<div class="text-white font-weight-bolder"
															style="font-size: 2rem;">
															<c:choose>
																<c:when test="${performance.rating eq 0 }">
																			전체관람가
																		</c:when>
																<c:when test="${performance.rating eq 12 }">
																			만 12세이상 관람
																		</c:when>
																<c:when test="${performance.rating eq 15 }">
																			만 15세이상 관람
																		</c:when>
																<c:when test="${performance.rating eq 19 }">
																			청소년관람불가
																		</c:when>
															</c:choose>
														</div>
														<hr style="background-color: #fff;" />
														<div class="text-white mt-2" style="font-size: 2rem;">
															<div>좋아요수: <label id="${performance.id }likesSlide">${performance.likes }</label></div>
															<div>예매횟수: ${performance.reserveCount }</div>
														</div>														  
														<div class="text-white mt-3" style="font-size: 1.5rem;">
															<c:forEach var="seat" items="${performance.seatPrices }">
																<div>
																	${seat.seatRate }석
																	<fmt:formatNumber value="${seat.price }" />
																	원
																</div>
															</c:forEach>
														</div>														
														<div class="text-white mt-3" style="font-size: 1.5rem;">
															<c:forEach var="genre" items="${performance.genres }">
																<a class="btn btn-link text-white"
																	href="/performance/list.do?category=${performance.category }&genre=${genre }"
																	style="font-size: 1.2rem;">
																	#${genre } </a>																
															</c:forEach>
														</div>																												
														<div class="mt-3">
															<button type="button" class="btn btn-info btn-lg mr-3"
																onclick="showDetail(${performance.id})">상세보기</button>
															<button type="button" class="btn btn-danger btn-lg"
																onclick="buyTicket(${performance.id})">예매하기</button>
														</div>
													</div>
												</div>
											</div>
										</div>
									</div>
									<!-- 한 슬라이드 끝 -->
									<c:set var="index" value="${index + 1 }" />
								</c:forEach>
							</c:if>
						</div>
						<a class="carousel-control-prev" href="#demo" role="button"
							data-slide="prev"> <span class="carousel-control-prev-icon"
							aria-hidden="true"></span> <span class="sr-only">Previous</span>
						</a> <a class="carousel-control-next" href="#demo" role="button"
							data-slide="next"> <span class="carousel-control-next-icon"
							aria-hidden="true"></span> <span class="sr-only">Next</span>
						</a>
					</div>
					<!-- 배너광고 슬라이드 끝  -->
				</div>
			</div>			
			<!-- 배너 광고 끝 -->
						
			<div class="row mt-5 justify-content-center">
				<div class="col-8">
					<div class="d-flex justify-content-between">
						<div class="p-2">
							<h5 class="text-danger d-inline bolder">${category }</h5>
							<span>검색결과</span>
						</div>
						<div class="p-2">
							<button type="button" class="btn btn-link ${param.order eq 'dateOrder' || empty param.order? 'text-danger' : 'text-dark' }"
								onclick="selectOrder('dateOrder')" id="dateOrder">개봉일순</button>
							<button type="button" class="btn btn-link ${param.order eq 'likeOrder'? 'text-danger' : 'text-dark' }"
								onclick="selectOrder('likeOrder')" id="likeOrder">좋아요순</button>
							<button type="button" class="btn btn-link ${param.order eq 'salesOrder'? 'text-danger' : 'text-dark' }"
								onclick="selectOrder('salesOrder')" id="salesOrder">예매순</button>
						</div>
					</div>
					<hr />
				</div>
			</div>

			<div class="row mt-2 justify-content-center">
				<div class="col-8 border p-3">
					<form method="get" id="search-form">
						<input type="hidden" name="order" id="listOrder" value="${param.order }" />
						<input type="hidden" name="category" value="${category }" /> <input
							type="hidden" name="pageNo" id="pageNo" /> <input type="hidden"
							name="changed" id="formChanged" value="N" />
						<div class="form-group">
							<label>공연명</label> <input type="text" class="form-control"
								name="title" id="performanceName" value="${param.title }" />
						</div>
						<div class="form-group">
							<label class="">공연장르</label>
							<div class="btn-group-toggle  ">
								<label
									class="btn ${(empty param.genre || param.genre eq '전체'  ) ? 'btn-danger' : 'btn-outline-danger'} mb-2">
									<input type="checkbox" name="genre" value="전체"
									${(empty param.genre || param.genre eq '전체'  ) ? "checked" : ""}
									id="genreAll">전체
								</label>
								<c:set var="searchGenres" value="${paramValues.genre }" />
								<c:forEach var="genre" items="${genres }">
									<c:set var="searched" value="N" />
									<c:forEach var="paramGenre" items="${searchGenres }">
										<c:choose>
											<c:when test="${genre eq paramGenre }">
												<c:set var="searched" value="Y" />
											</c:when>
										</c:choose>
									</c:forEach>
									<c:choose>
										<c:when test="${searched eq 'N' }">
											<label class="btn btn-outline-danger mb-2"> <input
												type="checkbox" name="genre" value="${genre }">${genre }
											</label>
										</c:when>
										<c:otherwise>
											<label class="btn btn-danger mb-2"> <input
												type="checkbox" name="genre" checked value="${genre }">${genre }
											</label>
										</c:otherwise>
									</c:choose>
								</c:forEach>
							</div>
						</div>
						<div class="form-group">
							<div class="form-inline ">
								<div>
									<label>공연기간</label>
								</div>
								<div class="ml-3">
									<input type="date" class="form-control d-inline"
										name="startDay" id="performanceStartDay"
										value="${param.startDay }" /> ~ <input type="date"
										class="form-control d-inline" name="endDay"
										id="performanceEndDay" value="${param.endDay }" />
								</div>
							</div>
						</div>
						<div class="form-group">
							<label>관람연령</label>
							<div class="btn-group-toggle  " data-toggle="buttons">

								<label class="btn btn-outline-danger mb-2"> <input
									type="radio" name="age" value="0"
									${(empty param.age || param.age eq '0') ? "checked" : '' }
									id="ageAll">전체
								</label> <label class="btn btn-outline-danger mb-2"> <input
									type="radio" name="age" value="12"
									${param.age eq '12' ? "checked" : '' }>12세이상
								</label> <label class="btn btn-outline-danger mb-2"> <input
									type="radio" name="age" value="15"
									${param.age eq '15' ? "checked" : '' }>15세이상
								</label> <label class="btn btn-outline-danger mb-2"> <input
									type="radio" name="age" value="19"
									${param.age eq '19' ? "checked" : '' }>청소년관람불가
								</label>
							</div>
						</div>
						<div class="d-flex justify-content-end">
							<button type="submit" class="btn btn-danger mr-4">검색</button>
						</div>
					</form>
				</div>
			</div>

			<!-- 공연 목록 row시작 -->
			<div class="row mt-4 justify-content-center">
				<!-- 공연 목록 시작 -->
				<div class="col-8 mt-3">
					<c:forEach var="performance" items="${performances }">
						<div class="row mt-2 mb-3">
							<!-- 공연정보 카드 1 시작 -->
							<div class="col-12">
								<div class="card">
									<div class="card-body">
										<div class="row"> <!-- 이미지 및 공연기본정보 시작-->
											<div class="col-3">
												<c:choose>
													<c:when
														test="${fn:substring(performance.imagePath, 0,4) eq 'http' }">
														<c:set var="path" value="${performance.imagePath }" />
													</c:when>
													<c:when test="${performance.imagePath eq '' }">
													 	<c:set var="path" value="/resources/sample-images/noimage.png"/>
													</c:when>
													<c:otherwise>
														<c:set var="path"
															value="/resources/sample-images/${performance.imagePath }" />
													</c:otherwise>
												</c:choose>
												<img src="${path }" class="img-thumbnail">
											</div>
											<div class="col-9">
												<div class="row mb-2">
													<div class="col-12">
														<span class="badge badge-pill badge-warning mr-2">
															<c:choose>
																<c:when test="${performance.rating eq 0}">
       														전체
    													</c:when>
																<c:otherwise>
      														${performance.rating }
    													</c:otherwise>
															</c:choose>
														</span>
														<h5 class="d-inline font-weight-bold">
															<c:out value="${performance.title }" />
														</h5>
													</div>
												</div>
												<div class="row mb-2">
													<div class="col-7 ">
														<table class="table table-borderless">
															<colgroup>
																<col width="20%" />
																<col width="80%" />
															</colgroup>
															<tr>
																<th>장르</th>
																<td><c:forEach var="genre"
																		items="${performance.genres }"> 
																${genre }&nbsp;
															</c:forEach></td>
															</tr>
															<tr>
																<th>러닝타임</th>
																<td>${performance.runningTime }</td>
															</tr>
															<tr>
																<th>공연기간</th>
																<td><fmt:formatDate
																		value="${performance.startDate }"
																		pattern="yyyy년 M월 d일" /> ~ <fmt:formatDate
																		value="${performance.endDate }" pattern="yyyy년 M월 d일" />
																</td>
															</tr>
															<tr>
																<th>분류</th>
																<td>${performance.category }</td>
															</tr>
															<tr>
																<th>공연장소</th>
																<td>${performance.hallName }</td>
															</tr>
															<tr>
																<th>좌석정보</th>
																<td><c:forEach var="seat"
																		items="${performance.seatPrices }">
																${seat.seatRate }석 
																<fmt:formatNumber value="${seat.price }" />원																
															</c:forEach></td>
															</tr>
															<tr>
																<td colspan="2"><label class=""> <c:forEach
																			var="genre" items="${performance.genres }">
																			<button class="btn btn-link"
																				onclick="searchGenre('${genre}')">#${genre
																				}</button>
																		</c:forEach>
																</label></td>
															</tr>
														</table>
													</div>
													<!-- 공연 간단 정보창 끝 -->													
													<div class="col-5">														
													</div>												
												</div>
												<!-- 공연정보 표시끝 -->
											</div>
										</div><!-- 이미지 및 공연기본정보 끝-->
										<div class="row  p-2 ">
											<!-- 좋아요수, 예메횟수, 예매하기, 상세보기 버튼그룹 -->
											<div class="col-12 d-flex justify-content-between">
												<div>
													<!-- 좋아요수 표시 -->
													<div class="d-inline mr-2">
														<i class='fas fa-heart mr-2'
															style='font-size: 24px; color: red;'></i><label
															id="${performance.id }likes">${performance.likes }</label>
													</div>
													<!-- 예매횟수 -->													  
													<div class="d-inline" >
														<i class='fas fa-cart-arrow-down mr-2' style='font-size: 24px'></i><label>${performance.reserveCount }</label>
													</div>													
												</div>
												<div>
													<button type="button" class="btn btn-danger mr-2"
														onclick="buyTicket(${performance.id})">예매하기</button>
													<button type="button" class="btn btn-outline-dark"
														onclick="showDetail(${performance.id})">상세보기</button>
												</div>
											</div>
										</div>										
									</div>
									<!-- card body 끝 -->
								</div>
								<!-- card 끝 -->
							</div>
							<!-- 카드 row col-12끝 -->
						</div>
						<!-- 카드 row끝 공연정보카드1 끝남-->
					</c:forEach>
					<!-- 카드 row끝 -->
				</div>
			</div>
			<!-- 공연목록 끝 -->

			<!-- 공연 상세정보 모달창 -->
			<div class="modal" id="myModal">
				<div class="modal-dialog"
					style="max-width: 100%; width: 80%; display: table;">
					<div class="modal-content">

						<!-- Modal Header -->
						<div class="modal-header">
							<h6 class="modal-title font-weight-bold">공연 상세정보</h6>
							<button type="button" class="close" data-dismiss="modal">&times;</button>
						</div>

						<!-- Modal body -->
						<div class="modal-body">
							<div class="card">
								<div class="card-body">
									<div class="row">
										<div class="col-3">
											<img src="/resources/sample-images/noimage.png"
												class="img-thumbnail" id="modalImg">
										</div>
										<div class="col-9">
											<div class="row mb-2">
												<div class="col-12">
													<span class="badge badge-pill badge-warning mr-2"
														id="modalAge"></span>
													<h5 class="d-inline font-weight-bold" id="modalTitle"></h5>
												</div>
											</div>
											<div class="row mb-2">
												<div class="col-7 ">
													<table class="table table-borderless">
														<colgroup>
															<col width="20%" />
															<col width="80%" />
														</colgroup>
														<tr>
															<th>장르</th>
															<td id="modalGenre"></td>
														</tr>
														<tr>
															<th>러닝타임</th>
															<td id="modalRunningTime"></td>
														</tr>
														<tr>
															<th>공연기간</th>
															<td id="modalPeriod"></td>
														</tr>
														<tr>
															<th>분류</th>
															<td id="modalCategory"></td>
														</tr>
														<tr>
															<th>공연장소</th>
															<td id="modalHallName"></td>
														</tr>
														<tr>
															<th>좌석정보</th>
															<td id="modalSeatInfo"></td>
														</tr>
														<tr>
															<td colspan="2"><label class="" id="modalTags">
															</label></td>
														</tr>
													</table>
												</div>
												<!-- 공연 간단 정보창 끝 -->
												<!-- 지도  -->
												<div class="col-5">
													<div class="row justify-content-center">
														<div class="col-12">
															<div class="card">																
																<!-- 카카오맵 api by LMS (start 2020.08.26) -->
																<div class="card-body">
																	<div id="map" style="width: 380px; height: 300px;"></div>
																</div>
															</div>
														</div>
													</div>
												</div>
												<!-- 지도  끝 -->
											</div>
											<!-- 공연정보 표시끝 -->
										</div>
									</div>
									<div class="row mt-2 ">
										<div class="col-12 d-flex justify-content-between">
											<div>
												<!-- 좋아요수 표시 -->
												<div class="d-inline mr-2">
													<button type="button" class="btn btn-sm" id="clickLike"
														data-no="" data-liked="">
														<i class='far fa-heart mr-2' style='font-size: 24px;'></i>
													</button>
													<label id="modalLikes"></label>
												</div>
												<!-- 예매수 표시 -->
												<div class="d-inline" style="display:none;">
													<i class='fas fa-cart-arrow-down mr-2' style='font-size: 24px'></i>													
													<label id="modalReserveCount"></label>
												</div>											
											</div>
										</div>
									</div>
									<div class="row justify-content-center">										
										<button type="button"
											class="btn btn-danger mr-4 btn-lg" id="modalBuyBtn"
											data-no="">예매하기</button>										
									</div>								
								</div>
								<!-- card body 끝 -->
							</div>
							<!-- card 끝 -->
							<div>
								<!-- 공연상세 정보 -->
								<div class="mt-3 p-2">
									<h5 class="font-weight-bold">공연정보</h5>
									<table class="table table-bordered mt-3">
										<colgroup>
											<col width="20%">
											<col width="80%">
										</colgroup>
										<tbody>
											<tr>
												<th>공연명</th>
												<td id="modalDetailtitle"></td>
											</tr>
											<tr>
												<th>공연장소</th>
												<td id="modalDetailHallName">
													<p></p>
													<p></p>
												</td>
											</tr>
											<tr>
												<th>공연기간(개봉일)</th>
												<td id="modalDetailPeriod"></td>
											</tr>											
											<tr>
												<th>러닝타임</th>
												<td id="modalDetailRunningTime"></td>
											</tr>
											<tr>
												<th>좌석등급 및 가격</th>
												<td id="modalDetailSeatInfo"></td>
											</tr>
											<tr>
												<th>관람연령</th>
												<td id="modalDetailAge"></td>
											</tr>
										</tbody>
									</table>
								</div>
								<!-- 공연정보 테이블 끝 -->
								<div class="mt-3 p-2">
									<!-- 공연 -->
									<h5 class="font-weight-bold">내용</h5>
									<div class="mt-3" style="width: 85%">
										<p id="modalDetailExplain"></p>
									</div>
								</div>
								
								<div class="mt-3 p-2">
									<h5 class="font-weight-bold">성별 나이별 관람추이</h5>
									<div class="row mt-3 p-2 justify-content-start">
										<div class="col-5">
											<div class="card">
												<div class="card-body">
													<div id="chartGenderDiv">
														<canvas id="chartGender">
														</canvas>													
													</div>
													<div id="defaultChart" class="text-center"
														style="display: none;"></div>
												</div>
											</div>
										</div>
										<div class="col-5">
											<div class="card" >
												<div class="card-body">
													<div id="chartAgeDiv">
														<canvas id="chartAge">
														</canvas>													
													</div>
													<div id="defaultAgeChart" class="text-center"
														style="display: none;"></div>
												</div>
											</div>
										</div>
									</div>
								</div>
								<!-- 공연 상세정보 -->
							</div>
							<!-- 공연상세정보 끝 -->
						</div>
					</div>
				</div>
			</div>
			<!-- 공연 상세정보 모달창 끝 -->

			<div class="row mt-5 justify-content-center">
				<!-- 페이지네이션 -->
				<nav aria-label="Page navigation example">
					<c:if test="${pageNo > 1 }">
						<button class="btn btn-light" onclick="goPage('${pageNo-1}')">이전</button>
					</c:if>
					<c:forEach var="idx" begin="${pagination.beginPage }"
						end="${pagination.endPage }" step="1">
						<button
							class="btn btn-light paging-num ${pageNo == idx? 'active': '' }"
							onclick="goPage('${idx}')">${idx }</button>
					</c:forEach>
					<c:if test="${pageNo < totalPageCount }">
						<button class="btn btn-light" onclick="goPage('${pageNo+1}')">다음</button>
					</c:if>
				</nav>
			</div>
			<!-- 페이지네이션 끝 -->
		</div>
		<!-- container 끝 -->

	</div>
	<!-- body 끝 -->
	<div class="footer" style="height: 200px;">
		<%@ include file="../common/footer.jsp"%>
	</div>

	<script type="text/javascript" src="/resources/jquery/jquery.min.js"></script>
	<script type="text/javascript"
		src="/resources/bootstrap/js/bootstrap.min.js"></script>
	<script type="text/javascript" src="//dapi.kakao.com/v2/maps/sdk.js?appkey=6c5c46e14c9e30d8a93ecc7d29bfaeab&libraries=services"></script>	
<script type="text/javascript">
$(function(){	
	var $checkedAge = $("input[name='age']:checked");
		
	$($checkedAge).closest('label').siblings().find('input').prop("checked", false);
	$($checkedAge).closest('label').removeClass("btn-danger").addClass("btn-outline-danger");
	
	if ($checkedAge.val() != 0) {
		$("#ageAll").prop("checked", false);
		$("#ageAll").closest('label').removeClass("btn-outline-danger").addClass("btn-outline-danger");
	}
		
	var slides = $(".slide-title-summary");
	for (var i = 0; i<slides.length; i++) {
		var slide = $(".slide-title-summary:eq("+i+")");
		
		var slideText = $.trim(slide.html());
		if (slideText.length > 18) {
			slideText = slideText.substring(0,18)+"...";			
		}
		
		slide.html(slideText);		
	}	
});

$("#search-form").find("input").change(function() {
	var $changed = $("#search-form input[name=changed]");	
	$changed.val("Y");	
	
});

$(":input[name=genre]").closest('label').click(function(event) {
	var $changed = $("#search-form input[name=changed]");
	$changed.val("Y");
	
});

$(":input[name=age]").closest('label').click(function(event) {
	var $changed = $("#search-form input[name=changed]");
	$changed.val("Y");
	
});


function goPage(no) {		
	$("#pageNo").val(no);
	$("#search-form").submit();
}

function searchGenre(genre) {	
	var checked = $("#search-form input[name=genre]:checked");		
	var genreVals = $("#search-form input[name=genre]");
	
	for (var idx = 0; idx < genreVals.length; idx++ ) {
		
		var genreBtn = genreVals[idx];
		
		if ($(genreBtn).val() == genre) {
			$(genreBtn).prop("checked", true);			
		}else {
			$(genreBtn).prop("checked", false);	
		}		
	}
	
	$("#search-form").submit();	
	
}

function selectOrder(option) {
	var optionId = "#"+option;
	
	$(optionId).removeClass("text-dark").addClass("text-danger");
	$(optionId).siblings().removeClass("text-danger").addClass("text-dark");
	$("#listOrder").val(option);
	
	var $changed = $("#search-form input[name=changed]");
	$changed.val("Y");
	
	// 이후 form submit 출력
	$("#search-form").submit();
}

$("#performanceStartDay").change(function() {
	
	var now = new Date().toISOString().substring(0, 10);		
	var $endDay = $("#performanceEndDay");
	
	if ($endDay.val() == "") return;
	if ($endDay.val() < $(this).val()) {
		$(this).val($endDay.val());
	}
})

$("#performanceEndDay").change(function() {
	var now = new Date().toISOString().substring(0, 10);	
	
	var $startDay = $("#performanceStartDay");
	if ($(this).val() < now) {	// 입력한 종료날짜가 오늘보다 이전이면
		$(this).val(now);	// 종료날짜를 오늘로 바꿔준다.
	}
	if ($(this).val() < $startDay.val()) {
		$(this).val("");		
	}
	
})

function buyTicket(no) {	
	location.href='/payment/step1.do?no='+no;
}

$("#modalBuyBtn").click(function() {
	var no = $("#modalBuyBtn").data("no");
	buyTicket(no);
})

function numberWithComma(num)
{
	var regexp = /\B(?=(\d{3})+(?!\d))/g;
	return num.toString().replace(regexp, ',');
}

function textWithBr(text) {
	var text2 = "";
	for (var i = 0; i < text.length; i++) {
		if (text.charAt(i) == "\n") {
			text2 += "</br>";
		} else {
			text2 += text.charAt(i);
		}
	}
	return text2;
}

function showDetail(performanceId) {	
	console.log("performanceId="+performanceId);
	var loginUser="${ LOGIN_USER.id}";
		
	$.ajax({
		type:"GET",
		url:"/performance/detail.do",
		data: {id:performanceId, userId:loginUser},
		dataType: 'json',
		success: function(data) {
			var hallInfo = data.hallInfo;
			var performance = data.performance;
			var userLiked = data.userLiked;
			
			var manReserveCount = data.manReserveCount;
			var womanReserveCount = data.womanReserveCount;
			var age10ReserveStats = data.age10ReserveStats;
			var age20ReserveStats = data.age20ReserveStats;
			var age30ReserveStats = data.age30ReserveStats;
			var age40ReserveStats = data.age40ReserveStats;
			var age50ReserveStats = data.age50ReserveStats;
						
			var modalImagePath = performance.imagePath;

			if (modalImagePath == '' ) {
				modalImagePath = "/resources/sample-images/noimage.png";	
			} else if (modalImagePath.substring(0,4) != 'http') {
				modalImagePath="/resources/sample-images/"+performance.imagePath;
			}
			
			$("#modalImg").attr("src", modalImagePath);			
			var rating = performance.rating;
			if (performance.rating == "0") {
				rating = "전체";
			}
						
			$("#modalAge").text(rating);
			$("#modalTitle").text(performance.title);
			
			var performanceGenres = "";						
			for (var idx=0; idx < performance.genres.length; idx++) {
				performanceGenres += performance.genres[idx]+ " ";				
			}			
			
			$("#modalGenre").text(performanceGenres);				
			$("#modalRunningTime").text(performance.runningTime);
			
			var period = performance.startDate + " ~ " +  performance.endDate;		
			$("#modalPeriod").text(period);
			$("#modalCategory").text(performance.category);
			$("#modalHallName").text(performance.hallName);
						
			var seatPrices = "";
			for (var idx=0; idx < performance.seatPrices.length; idx++) {
				seatPrices += performance.seatPrices[idx].seatRate + "석 "
				+ numberWithComma(performance.seatPrices[idx].price) + "원 ";
			}
			
			$("#modalSeatInfo").text(seatPrices);
			
			var tags="";
			for (var idx=0; idx < performance.genres.length; idx++) {
				tags += "#"+performance.genres[idx];				
			}	
			
			$("#modalTags").text(tags).css("color", "#06F");
			
			$("#modalLikes").text(performance.likes);
			$("#modalReserveCount").text(performance.reserveCount);
			
			$("#modalDetailtitle").text(performance.title);
			$("#modalDetailHallName p:eq(0)").text(performance.hallName);
			$("#modalDetailHallName p:eq(1)").text("("+performance.hallAddress+")");
			$("#modalDetailPeriod").text(period);
			$("#modalDetailRunningTime").text(performance.runningTime);
			$("#modalDetailSeatInfo").text(seatPrices);
			
			if (rating != '전체') {
				rating = "만 "+rating+"이상 관람가";	
			}else {
				rating = rating+"관람가";
			}			
			
			$("#modalDetailAge").text(rating);												
			$("#modalDetailExplain").html(textWithBr(performance.explain));						
			
			$("#modalBuyBtn").data("no", performance.id);
			$("#modalDeleteBtn").data("no", performance.id);
			$("#modalUpdateBtn").data("no", performance.id);
			$("#clickLike").data("no", performance.id);
			$("#clickLike").data("liked", userLiked);	// 이전에 좋아요를 눌렀는지 여부 
						
			// 이전에 좋아요 했으면 빨간 하트
			if (userLiked == "Y") {
				$("#clickLike").find("i").removeClass("far").addClass("fas").css("color", "red");
			} else {
				$("#clickLike").find("i").removeClass("fas").addClass("far").css("color", "black");
			}
						
			var id = document.getElementById('map');
			kakaoMap(id, hallInfo);
						
			// 통계 그래프 그리기			
			// 성별 그래프
			var genderColors=['skyblue', '#e23b3b'];
			
			var donutOptions= {
				cutoutPercentage: 30, //도넛두께 : 값이 클수록 얇아짐 
				legend: {
							position:'bottom', 
							padding:5, 
							labels: {
								pointStyle:'circle', 
								usePointStyle:true
							}
						}
			};
									
			var chDonutData = {
				labels: ['남자', '여자'], 
				datasets: [ { 
					backgroundColor: genderColors.slice(0,2), 
					borderWidth: 0, 
					data: [manReserveCount,womanReserveCount] // 데이터
				} ]
			};
			
			var $defaultChart = $("#defaultChart");			
			var $chGenderDiv= $("#chartGenderDiv").empty();
			$chGenderDiv.html("<canvas id='chartGender'></canvas>");
			var $chDonut = $("#chartGender"); 
			
			if ((manReserveCount == 0) && (womanReserveCount == 0)) {
				
				var defaultImage = "<img class='mt-5' src='/resources/sample-images/notPrepared.png' width='140px'/>";
				defaultImage += "<p class='mt-4 mb-4 font-weight-bold'>아직 성별 예매정보가 없습니다.</p>";
				
				$defaultChart.html(defaultImage);
				$defaultChart.show();
				$chGenderDiv.hide();
			} else {
				$defaultChart.hide();
				$chGenderDiv.show();
				if ($chDonut) { 
					new Chart($chDonut, { 
						type: 'pie', 
						data: chDonutData, 
						options: donutOptions 
						}
					); 
				}
			
			} // 데이터 값이 있을 때 그래프 그리기 
			
			// 나이대별 관람추이
			var $chAgeDiv= $("#chartAgeDiv").empty();
			var $defaultAgeChart = $("#defaultAgeChart");
			$chAgeDiv.html("<canvas id='chartAge'></canvas>");
			var $chBar = $("#chartAge");
									
			if ((age10ReserveStats == 0) && (age20ReserveStats == 0) && 
					(age30ReserveStats == 0) && (age40ReserveStats == 0) &&
					(age50ReserveStats == 0)) {
				
				var defaultImage = "<img class='mt-5' src='/resources/sample-images/notPrepared.png' width='140px'/>";
				defaultImage += "<p class='mt-4 mb-4 font-weight-bold'>아직 연령대별 예매정보가 없습니다.</p>";
				
				$defaultAgeChart.html(defaultImage);
				$defaultAgeChart.show();
				$chAgeDiv.hide();
			} else {
				$defaultAgeChart.hide();
				$chAgeDiv.show();
				
				if ($chBar) {
					new Chart($chBar, {
						type: 'bar',
						data: {
							labels: ['10대↓', '20대', '30대', '40대', '50대↑'],
							datasets: [{
								label: '# of ReserveCount',
								data: [age10ReserveStats, age20ReserveStats,
									age30ReserveStats, age40ReserveStats, age50ReserveStats],	// 퍼센트 구해서 넣기
								backgroundColor: [
									'rgba(54, 162, 235, 0.2)',
									'rgba(54, 162, 235, 0.2)',
									'rgba(54, 162, 235, 0.2)',
									'rgba(54, 162, 235, 0.2)',
									'rgba(54, 162, 235, 0.2)'
								],
								borderColor: [
									'rgba(54, 162, 235, 1)',
									'rgba(54, 162, 235, 1)',
									'rgba(54, 162, 235, 1)',
									'rgba(54, 162, 235, 1)',
									'rgba(54, 162, 235, 1)'
								],
								borderWidth: 1
							}]
						},
						options: {
							scales: {
								yAxes: [{
									ticks: {
										beginAtZero: true
									}
								}]
							}
						}
						
					})		
				}// bar 끝				
			} // 연령대별 예매정보가 있다면 끝
					
		} // success 끝
	})
	
	$("#myModal").modal("show");
	// modal 창이 열리는 시점(스타일이 변경되는 시점)에서 지도 영역이 변경되었다고 알려주는 함수 호출

		
};

$("#clickLike").click(function(){
	
	// 로그인 여부 확인하고 로그인 상태이면, 좋아요 표시
	var loginUser="${ LOGIN_USER.id}";
	
	if (loginUser == "") {
		location.href="/signin.do";
		return;
	} 
	
	var performanceId = $("#clickLike").data("no");
	var liked = $("#clickLike").data("liked")
	var modalLike = parseInt($("#modalLikes").text());
	var listModalLike = parseInt($("#"+performanceId+"likes").text());
			
	if (liked == "N"){	// 빈 하트라면, 좋아요를 하지 않았다면,
			
		$.ajax({
			type:"GET",
			url:"/performance/insertLikes.do",
			data: {id:performanceId, userId:loginUser},
			dataType: 'json',
			success: function(data) {
				var successYn = data.successYn;
				
				$("#clickLike").data("liked","Y");	// 좋아요를 눌렀다고 정보변경
				$("#clickLike").find("i").removeClass("far").addClass("fas").css("color", "red"); // 하트 색깔 변경
				
				var updateLikes = modalLike+1;
				$("#modalLikes").text(updateLikes);	// 모달에서 보이는 좋아요 수 변경
				$("#"+performanceId+"likes").text(updateLikes);	// 공연목록에서 보이는 좋아요 수 변경
				$("#"+performanceId+"likesSlide").text(updateLikes);	// 공연슬라이드에서 좋아요 수 변경
			}
		})
		
	} else if (liked == "Y"){	// 좋아요 취소
			
		$.ajax({
			type:"GET",
			url:"/performance/deleteLikes.do",
			data: {id:performanceId, userId:loginUser},
			dataType: 'json',
			success: function(data) {
				var successYn = data.successYn;
				
				$("#clickLike").data("liked", "N");	// 좋아요를 취소햇다고 정보변경
				$("#clickLike").find("i").removeClass("fas").addClass("far").css("color", "black");	// 하트 색깔 변경
				
				var updateLikes = modalLike-1;
				
				$("#modalLikes").text(updateLikes);	// 모달에서 보이는 좋아요 수 변경
				$("#"+performanceId+"likes").text(updateLikes);	// 공연목록에서 보이는 좋아요 수 변경
				$("#"+performanceId+"likesSlide").text(updateLikes);	// 공연슬라이드에서 좋아요 수 변경
				
			}
		})		
	}	
})


$(function() {
	$(":input[name=genre]").closest('label').click(function(event) {
		event.preventDefault();

		$(this).find('input').prop("checked", !($(this).find('input').prop("checked")))
				
		
		if ($(this).find('input').prop("checked")) {
						
			$(this).removeClass("btn-outline-danger").addClass("btn-danger");
						
			// 전체 누르면 다른 버튼은 취소되도록
			if ($(this).find('input').val()=="전체") {				
				$(this).siblings().find('input').prop("checked", false);
				$(this).siblings().removeClass("btn-danger").addClass("btn-outline-danger");				
			}else {	// 전체 말고 다른 버튼 눌렀을 때 전체 버튼이 이미 눌러져 있는경우 전체버튼 체크해제됨
				if ($("#genreAll").prop("checked")) {
					//다른 장르버튼 눌렀을때 전체버튼이 체크되어있는가
					$("#genreAll").closest('label').removeClass("btn-danger").addClass("btn-outline-danger");	
					$("#genreAll").prop("checked", false);
				}				
			}			
			
		} else {
			$(this).removeClass("btn-danger").addClass("btn-outline-danger");
		}
	})
})

function kakaoMap(id, hallInfo) {
	
	// 카카오맵 api script 부분 by LMS (2020.08.26)
	var mapContainer = id, // 지도를 표시할 div 
	mapOption = {
	    center: new kakao.maps.LatLng(hallInfo.gpsX, hallInfo.gpsY), // 지도의 중심좌표
	    level: 3 // 지도의 확대 레벨
	};  
	
	//지도를 생성합니다    
	var map = new kakao.maps.Map(mapContainer, mapOption); 
	// modal 창이 열리는 시점(스타일이 변경되는 시점)에서 지도 영역이 변경되었다고 알려주는 함수 호출
	map.relayout();	
	//주소-좌표 변환 객체를 생성합니다
	var geocoder = new kakao.maps.services.Geocoder();
	
	//주소로 좌표를 검색합니다
	geocoder.addressSearch(hallInfo.address, function(result, status) {
	
	// 정상적으로 검색이 완료됐으면 
		 if (status === kakao.maps.services.Status.OK) {
		
		    var coords = new kakao.maps.LatLng(result[0].y, result[0].x);
		
		    // 결과값으로 받은 위치를 마커로 표시합니다
		    var marker = new kakao.maps.Marker({
		        map: map,
		        position: coords
		    });
		
		    // 인포윈도우로 장소에 대한 설명을 표시합니다
		    var infowindow = new kakao.maps.InfoWindow({
		        content: '<div style="width:150px;text-align:center;padding:6px 0;">'+hallInfo.name+'</div>'
		    });
		    infowindow.open(map, marker);
		
		    // 지도의 중심을 결과값으로 받은 위치로 이동시킵니다
		    map.setCenter(coords);
		} 
	})
}
</script>
</body>
</html>