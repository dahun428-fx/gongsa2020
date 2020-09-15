<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
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
<link rel="stylesheet" href="/resources/css/card.css" />
<link rel="stylesheet" href="/resources/css/chat.css" />

<script src="https://code.jquery.com/jquery-3.5.1.min.js"></script>
<script
	src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.16.0/umd/popper.min.js"></script>
<script
	src="https://maxcdn.bootstrapcdn.com/bootstrap/4.5.0/js/bootstrap.js"></script>
<script type="text/javascript" src="https://cdnjs.cloudflare.com/ajax/libs/jqueryui/1.12.1/jquery-ui.min.js"></script>
<script type="text/javascript" src="/resources/js/jquery.color.js"></script>
<script type="text/javascript" src="/resources/js/custom.js"></script>
<script type="text/javascript" src="/resources/js/mate.js"></script>
</head>
<body  style="background-color: rgba(0, 0, 0, 0.6);">
	<div class="header">
		<%@ include file="../common/navi.jsp"%>
	</div>
	<div class="body">
		<div class="mt-5 container">
			<div class="row">
				<div class="offset-3 col-9 mt-3">
					<div id="container">
						<aside>
							<header>
								<div class="row h5 text-white font-weight-bold">
									<div class="col-3">
										<span style="display: none; cursor: pointer;"
											id="mate-card-left"><i class="fas fa-chevron-left"></i></span>
									</div>
									<div class="col-9">
										<span class="">참여한 메이트</span>
									</div>
								</div>
							</header>
							<ul>
								<c:choose>
									<c:when test="${not empty mate }">
										<c:forEach items="${mate }" var="user" varStatus="status">
									<li>
										<!-- user image --> <img
										src="/resources/sample-images/user_icon.png" alt="">
										<div>
											<!-- user id -->
											<h2>${user.nickname }</h2>
											<h3>
												<span class="text-primary"></span>
											</h3>
										</div>
									</li>
										</c:forEach>
									</c:when>
								</c:choose>
								
							</ul>
							<div class="col-12">
								<a href="mate.do?pid=${pid }" class="btn btn-warning btn-lg">
									<i class="fas fa-arrow-left fa-2x"></i>
								</a>
								<span class="text-white">이전</span>
							</div>
							<div class="col-12 text-center mt-4">
								<button id="mate-out-btn" type="button" class="btn btn-danger btn-sm">메이트방 탈퇴</button>
							</div>
						</aside>
						<div class="main">
							<header>
								<div class="col-12 mt-3">
									<div class="input-group">
										<select class="custom-select" id="mCat"
											aria-label="Example select with button addon">
											
										<c:forEach items="${categories }" var="cat">
											<option value="${cat.id }">${cat.category }</option>
										</c:forEach>

										</select>
										<div class="input-group-append">
											<button id="cat-change-btn" class="btn btn-outline-secondary" type="button">변경</button>
										</div>
										
									</div>
								</div>
								<div class="col-12 ml-3 mt-3">
									<span class="text-primary" id="mTag"></span>
									<button id="mate-plus-hastag" type="button"
										class="btn btn-primary btn-sm">
										<i class="fas fa-plus"></i>
									</button>
								</div>
								<div class="col-12 text-right">
									<hr class="m-2" />
									<button type="button" data-mate="${mnum }" class="btn btn-primary seat-preview-btn">좌석보기</button>
								</div>
								<div id="mate-plus-hastag-box" class="col-12"
									style="display: none; position: absolute; top: 120px; width: 600px;">
									<div class="card">
										<div class="input-group m-3">
											<input type="text" class="form-control"
												id="tag-update-input-box">
											<div class="input-group-append mr-5">
												<button class="btn btn-outline-secondary" type="button"
													id="tag-update-btn">등록</button>
											</div>
										</div>

									</div>
								</div>

							</header>
							<ul id="chat">
							</ul>
							<footer>
								<textarea id="chat-content-box" placeholder="메시지를 입력해주세요"></textarea>
								<div class="col-12 text-right">
								 <button id="chat-submit-btn" class="btn btn-outline-primary">등록</button>
								</div>
							</footer>
						</div>
					</div>
				</div>
			</div>

		</div>
	</div>
	<div id="mate-override-card" class='music-card playing'>
		<div id="card-x-btn" class="text-right m-2 text-white"
			style="position: absolute; z-index: 20; cursor: pointer;">
			<i class="far fa-times-circle fa-2x"></i>
		</div>
		<div class='image' id="pImage">
		</div>

		<div class='wave'></div>
		<div class='wave'></div>
		<div class='wave'></div>

		<div class='info'>
			<div class="row mt-4">
				<div class="col-12">
					<h4 style="display: inline-block;">
						<span id="seatRate"></span>석 메이트방
					</h4>
				</div>
				<div class="col-12 text-left ml-3">
					<div class="card font-weight-bolder" style="width: 270px;">
						<div class="text-white h4 badge badge-info text-wrap"><span id="pCat"></span></div>
						<div class="ml-2">
							<table class="table table-boderless">
								<tbody>
									<tr>
										<td><i class="far fa-calendar-alt"></i> 공연기간 <div><small
											class="ml-2"> 
											<span id="pStartDate"></span> <span>~</span>
												<span id="pEndDate"></span>
										</small></div></td>
									</tr>
									<tr>
										<td>
											<i class="fas fa-map-marker-alt"></i>공연장소
											<small><span id="pPlace"></span></small>
										</td>
									</tr>
									<tr>
										<td>
											<i class="fas fa-map-marker-alt"></i>공연시간
											<small><span id="pShowDate"></span></small>
											<small><span id="pShowTime"></span></small>
											<small><span id="pShowNumber"></span>회차</small>
										</td>
									</tr>
									<tr>
										<td>
											<i class="fas fa-registered"></i>
											<small><span id="pRating"></span>세</small>
										</td>
									</tr>
								</tbody>
							</table>
						
							
						</div>
						<div class="ml-2">
							
						</div>

					</div>
				</div>
				<div class="col-12 mt-2"></div>
			</div>
		</div>
		<input type="hidden" value="" id="totalLength"/>
		<input type="hidden" value="${pid }" id="pid"/>
		<input type="hidden" value="${mnum }" id="mnum" />
	</div>
	<!-- seat preview modal -->
	<div class="modal fade" id="seat-preview-modal" tabindex="-1"
		aria-hidden="true">
		<div class="modal-dialog modal-xl">
			<div class="modal-content">
				<div class="modal-header">
					<h5 class="modal-title">Modal title</h5>
					<button type="button" class="close" data-dismiss="modal"
						aria-label="Close">
						<span aria-hidden="true">&times;</span>
					</button>
				</div>
				<div class="modal-body">
					<div class="container">
						<div class="row">
							<div class="col-12">
								<div class="card">
									<div class="card-body text-center">
										<span>좌석 현황</span>
									</div>
								</div>
							</div>
							<div class="col-12">
								<div class="row">
									<div class="col-12">
										<div class="card">
											<div class="card-header text-center">
												<span style="font-size: 50px;"><strong>STAGE</strong></span>
											</div>
										</div>
									</div>
								</div>
							</div>
							<div class="col-12">
								<div class="row">
									<div class="offset-3 col-6 offset-3">
										<div class="row">
											<div id="R-seats1" class="col-6"></div>
											<div id="R-seats2" class="col-6"></div>
										</div>
									</div>
								</div>
								<br />
								<div class="row">
									<div class="col-12">
										<div class="row">
											<div id="S-seats1" class="col-3"></div>
											<div id="S-seats2" class="col-3"></div>
											<div id="S-seats3" class="col-3"></div>
											<div id="S-seats4" class="col-3"></div>
										</div>
									</div>
								</div>
								<br />
								<div class="row">
									<div class="col-12">
										<div class="row">
											<div id="A-seats1" class="col-3"></div>
											<div id="A-seats2" class="col-3"></div>
											<div id="A-seats3" class="col-3"></div>
											<div id="A-seats4" class="col-3"></div>
										</div>
									</div>
								</div>
							</div>
						</div>
					</div>
				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-primary"
						data-dismiss="modal">닫기</button>
				</div>
			</div>
		</div>
	</div>
<script>
$(function(){
	
	//mateRoomOutFunction
	$('#mate-out-btn').click(function(){
		var confirmedOut = confirm('정말로 해당 방에서 나가겠습니까?')
		if(!confirmedOut){
			return;
		}
		
		var performanceId = $('#pid').val();
		var mateId = $('#mnum').val();
		var userId = '<c:out value="${LOGIN_USER.id }" />'
		console.log(performanceId, mateId, userId);
		$.ajax({
			type:"POST",
			url:"/mate/mateOut.do",
			data:{
				"performanceMainId":performanceId,
				"mateId":mateId,
				"userId":userId
			},
			success:function(){
				location.href = '/mate/mate.do?pid='+performanceId;
			}
		})
	})
	
	//좌석 미리보기 모달
	$('.seat-preview-btn').click(function(){
		$('#seat-preview-modal').modal('show');
		
		$('#R-seats1').empty();
		$('#R-seats2').empty();
		$('#S-seats1').empty();
		$('#S-seats2').empty();
		$('#S-seats3').empty();
		$('#S-seats4').empty();
		$('#A-seats1').empty();
		$('#A-seats2').empty();
		$('#A-seats3').empty();
		$('#A-seats4').empty();
		
			//버튼 이벤트
			var rseats1 = $('#R-seats1');
			var rseats2 = $('#R-seats2');
			var sseats1 = $('#S-seats1');
			var sseats2 = $('#S-seats2');
			var sseats3 = $('#S-seats3');
			var sseats4 = $('#S-seats4');
			var aseats1 = $('#A-seats1');
			var aseats2 = $('#A-seats2');
			var aseats3 = $('#A-seats3');
			var aseats4 = $('#A-seats4');
			
			createSeat(rseats1);
			createSeat(rseats2);
			createSeat(sseats1);
			createSeat(sseats2);
			createSeat(sseats3);
			createSeat(sseats4);
			createSeat(aseats1);
			createSeat(aseats2);
			createSeat(aseats3);
			createSeat(aseats4);
			
			function createSeat($div){
				
				for (var i=1;i<5;i++) {
					for (var j=1;j<13;j++) {
						var seat = document.createElement('button');
						seat.style.width='20px'
						seat.style.height='20px'
						seat.style.padding='1px'
						seat.style.margin='0'
									
						seat.setAttribute("class"," btn btn-sm btn-outline-secondary seatBtn")
						var seatClass = '';
	
						//Seat 구역번호 지정
						if($div.hasClass('A')){
							seatClass = 'A';
						} else if ($div.hasClass('B')){
							seatClass = 'B';
						} else if ($div.hasClass('C')){
							seatClass = 'C';
						} else if ($div.hasClass('D')){
							seatClass = 'D';
						} else if ($div.hasClass('E')){
							seatClass = 'E';
						} else if ($div.hasClass('F')){
							seatClass = 'F';
						} else if ($div.hasClass('G')){
							seatClass = 'G';
						} else if ($div.hasClass('H')){
							seatClass = 'H';
						} else if ($div.hasClass('I')){
							seatClass = 'I';
						} else if ($div.hasClass('J')){
							seatClass = 'J';
						}
						
						seat.setAttribute('data-seatblock', seatClass)
						seat.setAttribute('data-seatrow', i);
						seat.setAttribute('data-seatcol', j);
						$div.append(seat);
					}
				}
			}
	
			
			var $rseatsBtn1 = $('#R-seats1 button')
			var $rseatsBtn2 = $('#R-seats2 button');
			var $sseatsBtn1 = $('#S-seats1 button');
			var $sseatsBtn2 = $('#S-seats2 button');
			var $sseatsBtn3 = $('#S-seats3 button');
			var $sseatsBtn4 = $('#S-seats4 button');
			var $aseatsBtn1 = $('#A-seats1 button');
			var $aseatsBtn2 = $('#A-seats2 button');
			var $aseatsBtn3 = $('#A-seats3 button');
			var $aseatsBtn4 = $('#A-seats4 button');
	
			$rseatsBtn1.addClass('bg-secondary').addClass('R-class-seat');
			$rseatsBtn2.addClass('bg-secondary').addClass('R-class-seat');
			$sseatsBtn1.addClass('bg-secondary').addClass('S-class-seat');
			$sseatsBtn2.addClass('bg-secondary').addClass('S-class-seat');
			$sseatsBtn3.addClass('bg-secondary').addClass('S-class-seat');
			$sseatsBtn4.addClass('bg-secondary').addClass('S-class-seat');
			$aseatsBtn1.addClass('bg-secondary').addClass('A-class-seat');
			$aseatsBtn2.addClass('bg-secondary').addClass('A-class-seat');
			$aseatsBtn3.addClass('bg-secondary').addClass('A-class-seat');
			$aseatsBtn4.addClass('bg-secondary').addClass('A-class-seat');
	
			//버튼 이벤트
				var pId = $('#pid').val();
				var mateId = $('#mnum').val();
				$.ajax({
					url:'/mate/seatPreview.do',
					Type:'POST',
					contentType:"application/json",
					data:{
						"performanceId":pId,
						"mateId":mateId
					},
					success:function(result){
						
						//seats
						var seatsArray = result.seats;
				        var aSeatArray = new Array();
				        var bSeatArray = new Array();
				        var cSeatArray = new Array();
				        var dSeatArray = new Array();
				        var eSeatArray = new Array();
				        var fSeatArray = new Array();
				        var gSeatArray = new Array();
				        var hSeatArray = new Array();
				        var iSeatArray = new Array();
				        var jSeatArray = new Array();
				        var rSeatRate = new Array();
				        var sSeatRate = new Array();
				        var aSeatRate = new Array();
				        
						for(var i in seatsArray){
				        	var seatBlock = seatsArray[i].seatBlock;
				        	var seatRow = seatsArray[i].seatRow;
				        	var seatCol = seatsArray[i].seatCol;
				        	var seatRate = seatsArray[i].seatRate;
				        	var groupSize = seatsArray[i].groupSize;
				        	var mateNo = seatsArray[i].mateNo;
				        	var catId = seatsArray[i].categoryId;
				        	var seatStatus = seatsArray[i].seatStatus;
				        	
				        	if(seatBlock == 'A'){
				        		aSeatArray.push(seatsArray[i]);
				        	} else if (seatBlock == 'B'){
				        		bSeatArray.push(seatsArray[i]);
				        	} else if (seatBlock == 'C'){
				        		cSeatArray.push(seatsArray[i]);
				        	} else if (seatBlock == 'D'){
				        		dSeatArray.push(seatsArray[i]);
				        	} else if (seatBlock == 'E'){
				        		eSeatArray.push(seatsArray[i]);
				        	} else if (seatBlock == 'F'){
				        		fSeatArray.push(seatsArray[i]);
				        	} else if (seatBlock == 'G'){
				        		gSeatArray.push(seatsArray[i]);
				        	} else if (seatBlock == 'H'){
				        		hSeatArray.push(seatsArray[i]);
				        	} else if (seatBlock == 'I'){
				        		iSeatArray.push(seatsArray[i]);
				        	} else {
				        		jSeatArray.push(seatsArray[i]);
				        	}
				        	if(seatRate == 'R'){
				        		rSeatRate.push(seatsArray)
				        	} else if (seatRate == 'S'){
				        		sSeatRate.push(seatsArray)
				        	} else if (seatRate == 'A')
				        		aSeatRate.push(seatsArray)
				        }
						seatSetFunction(aSeatArray, $rseatsBtn1);
						seatSetFunction(bSeatArray, $rseatsBtn2);
						seatSetFunction(cSeatArray, $sseatsBtn1);
						seatSetFunction(dSeatArray, $sseatsBtn2);
						seatSetFunction(eSeatArray, $sseatsBtn3);
						seatSetFunction(fSeatArray, $sseatsBtn4);
						seatSetFunction(gSeatArray, $aseatsBtn1);
						seatSetFunction(hSeatArray, $aseatsBtn2);
						seatSetFunction(iSeatArray, $aseatsBtn3);
						seatSetFunction(jSeatArray, $aseatsBtn4);
				       
						//해당 좌석만 표시
						var mateSeats = result.mateSeats;
						var targetMate = mateSeats[0].mateGroup;
						var $btnArray = $('button.seatBtn');
						for(var i = 0; i < $btnArray.length; i++){
							var mateData = $($btnArray[i]).data('mate');
							if(targetMate == mateData){
								$($btnArray[i]).removeClass('bg-secondary').addClass('bg-primary');
							}
							
						}
						
						
					}
					
			
		})
	})
		
})
function seatSetFunction(array, targetBtnArray){
		for(var i = 0; i < array.length; i++ ){
			$(targetBtnArray[i]).attr('data-groupsize', array[i].groupSize)
			    		  .attr('data-mate', array[i].mateNo)
			    		  .attr('data-category', array[i].catId)
			    		  .attr('data-seatstatus', array[i].seatStatus);
		}
	}
</script>
</body>
</html>