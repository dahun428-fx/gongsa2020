let isLast = false
$(function(){
    activateMenu()
    $("#myModal .card-body").unbind('mouseenter mouseleave')
    $(window).scroll(() => {
        const scrollTop = $(window).scrollTop()
        const windowHeight = $(window).height()
        const docHeight = $(document).height()

        if(scrollTop > docHeight - windowHeight - 30){
            generateList()
        }
    })
    generateList()
    openDetailModal()
    $(document).on('click','#modalBuyBtn', (event)=>{
        const performanceNo = $(event.target).data('no')
        const url = '/payment/step1.do?no='+performanceNo
        $(location).attr('href',url)
    })




})


const dateToYMD = function (date) {
    return `${date.getFullYear()}.${date.getMonth()+1}.${date.getDate()}`;
}

let currNo = 0;
let generateList = function(){
    if(isLast){
        return
    }
    let user = {
        id:$('#login-user-id').text(),
        point : currNo
    }
    var template = $("#like-list-template").clone()
    $("#like-list-template").remove()


    $.ajax({
        url:'/mypage/myLikes.do',
        type:'POST',
        contentType : 'application/json; charset=utf-8',
        data:JSON.stringify(user),
        datatype: 'json'
    }).done(result => {
        var likes = result.likes

        if(likes.length != 0){
            if(likes.length < 5){
                isLast = true
            }
            currNo += likes.length

            likes.forEach((like)=>{

                let newId = 'like-list-'+like.id
                template.attr('id', newId)
                template.addClass('like-list')
                template.attr('data-performance-id',like.id)
                newId = '#'+newId
                $(".container").append(template.clone())
                $(`${newId} .like-img`).attr('src',`${like.imagePath}`)
                $(`${newId} .like-title`).text(like.title)
                $(`${newId} .like-category`).text(like.category)
                $(`${newId} .like-genre`).empty()
                like.genre.forEach((name) =>{
                    $(newId+" .like-genre").append(`<span>${name}</span>`)
                })
                $(`${newId} .like-running-time`).text(like.runningTime)
                $(`${newId} .like-provider    `).text(like.provider.length > 8 ? like.provider.substring(0,8)+'...' : like.provider)
                $(`${newId} .like-start-date  `).text(dateToYMD(new Date(like.startDate)))
                $(`${newId} .like-end-date    `).text(dateToYMD(new Date(like.endDate)))
                $(`${newId} .like-hall-name   `).text(like.hallInfo.name)
                $(`${newId} .like-explain     `).text(like.explain.length > 50 ? like.explain.substring(0,49)+'...' : like.explain)
            })
        }else {
        	$('#myperformance-likes-null').removeClass('d-none')
        }
    }).fail(function(){

    }).always(function(){

    })
}
let numberWithComma = function(num) {
    let regexp = /\B(?=(\d{3})+(?!\d))/g;
    return num.toString().replace(regexp, ',');
}

const activateMenu = ()=>{
    $("#mypagemenu li").click(function(){
        const req = $(this).data('href')
        $(location).attr('href', req)
    })
}
const openDetailModal = function(){
	$(document).on('click','.like-list',function(){
        const performanceId = $(this).data('performanceId')
        const loginUser = $('#login-user-id').text()
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


			var modalImagePath = performance.imagePath;
			if (modalImagePath.substring(0,4) != 'http') {
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
			$("#modalAfterParty").text();

			$("#modalDetailtitle").text(performance.title);
			$("#modalDetailHallName p:eq(0)").text(performance.hallName);
			$("#modalDetailHallName p:eq(1)").text("("+performance.hallAddress+")");
			$("#modalDetailPeriod").text(period);
			// $("#modalDetailTime").text(performance.expla);
			$("#modalDetailRunningTime").text(performance.runningTime);
			$("#modalDetailSeatInfo").text(seatPrices);

			if (rating != '전체') {
				rating = "만 "+rating+"이상 관람가";
			}else {
				rating = rating+"관람가";
			}

			$("#modalDetailAge").text(rating);
			$("#modalDetailExplain").text(performance.explain);


			$("#modalBuyBtn").data("no", performance.id);
			$("#showMateGroupBtn").data("no", performance.id);
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
				cutoutPercentage: 30, // 도넛두께 : 값이 클수록 얇아짐
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

			var $chDonut = $("#chartGender");
			var $defaultChart = $("#defaultChart");

			if ((manReserveCount == 0) && (womanReserveCount == 0)) {

				var defaultImage = "<img class='mt-5' src='/resources/sample-images/notPrepared.png' width='140px'/>";
				defaultImage += "<p class='mt-4 mb-4 font-weight-bold'>아직 성별 예매정보가 없습니다.</p>";

				$defaultChart.html(defaultImage);
				$defaultChart.show();
				$chDonut.hide();
			} else {
				$defaultChart.hide();
				$chDonut.show();
				if ($chDonut) {
					new Chart($chDonut, {
						type: 'pie',
						data: chDonutData,
						options: donutOptions
						}
					);
				}

			} // 데이터 값이 있을 때 그래프 그리기


		} // success 끝
	})
    })
}
const kakaoMap = function (id, hallInfo) {

	// 카카오맵 api script 부분 by LMS (2020.08.26)
	var mapContainer = id, // 지도를 표시할 div
	mapOption = {
	    center: new kakao.maps.LatLng(hallInfo.gpsX, hallInfo.gpsY), // 지도의
																		// 중심좌표
	    level: 3 // 지도의 확대 레벨
	};

	// 지도를 생성합니다
	var map = new kakao.maps.Map(mapContainer, mapOption);

	// 주소-좌표 변환 객체를 생성합니다
	var geocoder = new kakao.maps.services.Geocoder();

	// 주소로 좌표를 검색합니다
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
