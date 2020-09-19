$(function(){

	
	$.ajax({
		type:"POST",
		url:"/managerMate/mateManagementJson.do",
		success:function(result){
			printPage(result);
		}
		
		
		
	})
	//page클릭
	$('tfoot').on('click','.pageno',function(){
		
		var pageNo = $(this).data('pageno');
		$.ajax({
			url:'/managerMate/mateManagementJson.do',
			type:'POST',
			data:{
				"pageNo":pageNo
			},
			success:function(result){
				printPage(result);
			}
			
		})
	})
	//이전
	$('tfoot').on('click','.beforePage',function(){
		var pageNo = $(this).data('pageno');
		$.ajax({
			url:'/managerMate/mateManagementJson.do',
			type:'POST',
			data:{
				"pageNo":pageNo
			},
			success:function(result){
				printPage(result);
			}
			
		})
	})
	
	
	//다음
	$('tfoot').on('click','.afterPage',function(){
		var pageNo = $(this).data('pageno');
		$.ajax({
			url:'/managerMate/mateManagementJson.do',
			type:'POST',
			data:{
				"pageNo":pageNo
			},
			success:function(result){
				printPage(result);
			}
			
		})
	})
	
	
	//모달 클릭
	$('#matelist-table tbody').on('click', '#matelist-detail-btn', function(){
		
		$('#mate-detail-modal').modal('show');
		var pId = $(this).data('performanceid');
		
		$.ajax({
			type:"POST",
			url:"/managerMate/mateManagementDetail.do",
			data:{
				"performanceId":pId
			},
			success:function(result){
				var detail = result.detail[0];
				var performance = result.detail[0].performance;
				var schedule = performance.schedule[0];
				
				var pTitle = performance.title;
				var pCat = performance.category;
				var pShowDate = schedule.showDate;
				var pShowTime = schedule.showTime;
				var pShowNumber = schedule.showNumber;
				var pImg = performance.imagePath;
				var mateTotalCnt = detail.totalCnt;
				var hallTotalCnt = detail.totalHallSeat;
				
				var rStatusArray = detail.rStatus;
				var sStatusArray = detail.sStatus;
				var aStatusArray = detail.aStatus;
				var mateCatArray = detail.categories;
				
				
				var rSeats = detail.rseats;
				var sSeats = detail.sseats;
				var aSeats = detail.aSetas;
				var pImagePath = '';
				if(pImg.substring(0,4) != 'http'){
					pImagePath = '/resources/sample-images/'+pImg;
				} else {
					pImagePath = pImg;
				}
				$('#pImg').attr('src', pImagePath);
				$('#pName').text(pTitle);
				$('#pCat').text(pCat);
				$('#pDate').text(pShowDate);
				$('#pTime').text(pShowTime);
				$('#pNum').text(pShowNumber);
				$('#totalSeats').text(hallTotalCnt);
				$('#totalMates').text(mateTotalCnt);
				$('#mate-category').empty();
				for(var i in rStatusArray){
					if(rStatusArray[i].status == '모집중'){
						$('#mate-R-progress').text(rStatusArray[i].statusCnt);
					} else if(rStatusArray[i].status == '모집완료'){
						$('#mate-R-complete').text(rStatusArray[i].statusCnt);
					} else if(rStatusArray[i].status == '빈방'){
						$('#mate-R-empty').text(rStatusArray[i].statusCnt);
					}
				}
				for(var i in sStatusArray){
					if(sStatusArray[i].status == '모집중'){
						$('#mate-S-progress').text(sStatusArray[i].statusCnt);
					} else if(sStatusArray[i].status == '모집완료'){
						$('#mate-S-complete').text(sStatusArray[i].statusCnt);
					} else if(sStatusArray[i].status == '빈방'){
						$('#mate-S-empty').text(sStatusArray[i].statusCnt);
					}
				}
				for(var i in aStatusArray){
					if(aStatusArray[i].status == '모집중'){
						$('#mate-A-progress').text(aStatusArray[i].statusCnt);
					} else if(aStatusArray[i].status == '모집완료'){
						$('#mate-A-complete').text(aStatusArray[i].statusCnt);
					} else if(aStatusArray[i].status == '빈방'){
						$('#mate-A-empty').text(aStatusArray[i].statusCnt);
					}
				}
				var rows = '';
				for(var i in mateCatArray){
					rows += '<div class="col-12">';
					rows += '<h6><span>'+mateCatArray[i].category+' / </span><span>'+mateCatArray[i].catCnt+'</span></h6>'
					rows += '</div>';
				}
				$('#mate-category').append(rows);
				
				$('#mate-detail-table tbody span').addClass('text-primary');
				$('#mate-detail-table tbody div').addClass('text-primary').addClass('h6');
				
				
				var rGroupSizeArray = detail.rGroupsize;
				var sGroupSizeArray = detail.sGroupsize;
				var aGroupSizeArray = detail.aGroupsize;
				console.log(rGroupSizeArray);
				
				var rows2 = '';
				for(var i in rGroupSizeArray){
					var count = rGroupSizeArray[i].groupSizecnt;
					var groupSize = rGroupSizeArray[i].groupSize;
					rows2 += '<div><span>'+groupSize+'인방 : </span><span>'+count+'</span></div>'
				}
				
				var rows3 = '';
				for(var i in sGroupSizeArray){
					var count = sGroupSizeArray[i].groupSizecnt;
					var groupSize = sGroupSizeArray[i].groupSize;
					rows3 += '<div><span>'+groupSize+'인방 : </span><span>'+count+'</span></div>'
				}
				var rows4 = '';
				for(var i in aGroupSizeArray){
					var count = aGroupSizeArray[i].groupSizecnt;
					var groupSize = aGroupSizeArray[i].groupSize;
					rows4 += '<div><span>'+groupSize+'인방 : </span><span>'+count+'</span></div>'
				}

				$('#sGroupSize').empty();
				$('#rGroupSize').empty();
				$('#aGroupSize').empty();
				
				$('#sGroupSize').append(rows2);
				$('#rGroupSize').append(rows3);
				$('#aGroupSize').append(rows4);
				
				
			}
		})
		
	})
	
	//수정버튼 클릭
	$('#matelist-table').on('click','#matelist-update-btn',function(){
		var performanceId = $(this).data('performanceid');
		location.href = '/managerMate/mateManagerUpdate.do?performanceId='+performanceId;
	})
	//삭제버튼 클릭
	$('#matelist-table').on('click','#matelist-delete-btn',function(){
		var performanceId = $(this).data('performanceid');
		var check = confirm("해당 방을 삭제하면 해당 정보가 모두 삭제 됩니다. 정말 삭제하시겠습니까?");
		if(check != true){
			return;
		}
		$.ajax({
			url:"/managerMate/deleteMate.do",
			type:"POST",
			data:{
				"performanceId":performanceId
			},
			success:function(data){
				alert(data.message);
				history.go(0);
			},
			beforeSend:function(){
				$('#loading').show();
			},
			complete:function(){
				$('#loading').hide();
			},
			error:function(){
				alert('실패하였습니다.');
			}
		})
	})
	
	
	
})



//pagination print funtion
function printPage(result){
	var list = result.mateList;
	
	var $tbody = $('#matelist-table tbody');
	$tbody.empty();
	var rows = '';
	for(var i in list){
		
		var performance = list[i].performance;
		var pId = performance.id;
		var pTitle = performance.title;
		var pCat = performance.category;
		var pImg = performance.imagePath;
		
		var schedule = performance.schedule[0];
		var showDate = schedule.showDate;
		var showTime = schedule.showTime;
		var showNumber = schedule.showNumber;
		
		var totalCnt = list[i].totalCnt;
		var aSeat = list[i].aseats;
		var sSeat = list[i].sseats;
		var rSeat = list[i].rseats;
		var pImagePath = '';
		if(pImg.substring(0,4) != 'http'){
			pImagePath = '/resources/sample-images/'+pImg;
		} else {
			pImagePath = pImg;
		}	
		rows += '<tr>';
		rows += '<td>'+pId+'</td>';
		rows += '<td><img class="img-thumbnail" style="width:100px;" src="'+pImagePath+'" alt="" /><div>'+pTitle+'</div></td>'
		rows += '<td>'+pCat+'</td>'
		rows += '<td>'+showDate+'</td>'	;
		rows += '<td>'+showTime+'</td>' ;
		rows += '<td>'+showNumber+'</td>'
		rows += '<td>'+rSeat+'</td>';
		rows += '<td>'+sSeat+'</td>';
		rows += '<td>'+aSeat+'</td>';
		rows += '<td>'+totalCnt+'</td>';
		rows += '<td><button class="btn btn-primary" id="matelist-update-btn" data-performanceid="'+pId+'" type="button">수정</button></td>'
		rows += '<td><button class="btn btn-danger" id="matelist-delete-btn" data-performanceid="'+pId+'" type="button">삭제</button></td>'	
		rows += '<td><button class="btn btn-warning" id="matelist-detail-btn" data-performanceid="'+pId+'" type="button">상세</button></td>'	
		rows += '</tr>'
		
	
	}
	$tbody.append(rows);
	$('#matelist-table tbody tr td').addClass('align-middle');
	
	var length = result.mateList.length;
	
	var pagination = result.pagination;
	var pageNo = pagination.pageNo;
	var beginPage = pagination.beginPage;
	var endPage = pagination.endPage;
	
	console.log(pagination);
	
	$tfoot = $('#matelist-table tfoot td');
	$tfoot.empty();
	var rows = '';
	rows += '<nav class="page navigation mx-auto" style="width:273px">'
	rows += '<ul class="pagination mx-auto">'	
	
	if(pageNo > beginPage){
		rows += '<li class="page-item"><a href="#" class="page-link beforePage" data-pageno="'+(pageNo-1)+'" >이전</a></li>'
	}	
	for(var page = beginPage; page <= endPage; page++){
		var active = (pageNo == page) ? "active" : "";	
		rows += '<li class="page-item '+active+'"><a href="#" class="page-link pageno"  data-pageno="'+page+'">'+page+'</a></li>'
	}
	
	if(pageNo < endPage){
		rows += '<li class="page-item"><a href="#" class="page-link afterPage" data-pageno="'+(pageNo+1)+'">다음</a></li>'
	}
	rows +=	'</ul></nav>'
	$tfoot.append(rows);


}


