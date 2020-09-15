<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>공공연한사이 관리자페이지</title>
<link rel="stylesheet" href="/resources/css/style.css" />
<link rel="stylesheet"
	href="https://maxcdn.bootstrapcdn.com/bootstrap/4.5.0/css/bootstrap.css">
<link rel="stylesheet"
	href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.8.2/css/all.min.css" />
<link rel="stylesheet" href="/resources/css/manager.css" />
<script src="https://code.jquery.com/jquery-3.5.1.min.js"></script>
<script
	src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.16.0/umd/popper.min.js"></script>
<script type="text/javascript" src="/resources/js/custom.js"></script>
<script
	src="https://maxcdn.bootstrapcdn.com/bootstrap/4.5.0/js/bootstrap.js"></script>
<script type="text/javascript" src="/resources/js/jquery.color.js"></script>
<script type="text/javascript" src="/resources/js/manager/manager.js"></script>
<script src="https://cdn.amcharts.com/lib/4/core.js"></script>
<script src="https://cdn.amcharts.com/lib/4/charts.js"></script>
<script src="https://cdn.amcharts.com/lib/4/themes/animated.js"></script>
<script src="https://cdn.amcharts.com/lib/4/lang/ko_KR.js"></script>
<script src="https://cdn.amcharts.com/lib/4/lang/ko_KR.js.map"></script>
</head>
<body>
  		<div class="custom-top" >
  			<div class="container custom-top-container">
  				<div class="row">
  					<div class="col-12 mt-4">
  						<div class="display-4 font-weight-bold text-white "></div>
  					</div>
  				</div>
  			</div>
  		</div>
 <div class="page-wrapper chiller-theme toggled">
  <%@ include file="../manager/common/managernavi.jsp" %>
  	<div class="container-fluid">
  	</div>
 <div class="page-content">
  <!-- sidebar-wrapper  -->
 <div class="container">
 	<div class="container-fluid">
 		<div class="managerTop">
		    <!-- Breadcrumbs-->
      <ol class="breadcrumb">
        <li class="breadcrumb-item">
          <a href="#">새로운 소식</a>
        </li>
        <li class="breadcrumb-item active">공공연한사이</li>
      </ol>
      <!-- Icon Cards-->
      <div class="row">
        <div class="col-xl-3 col-sm-6 mb-3">
          <div class="card text-white bg-primary o-hidden h-100">
            <div class="card-body">
              <div class="card-body-icon">
              <i class="fas fa-users fa-2x"></i>
              </div>
              <div class="mr-4">이번달 신규 가입자
               <c:if test="${userCount ne null }">
	               <span class="badge badge-light">${userCount }</span>
               </c:if>
               
               </div>
            </div>
            <a class="card-footer text-white clearfix small z-1" href="/adminProfile.do">
              <span class="float-left">View Details</span>
              <span class="float-right">
                <i class="fa fa-angle-right"></i>
              </span>
            </a>
          </div>
        </div>
        <div class="col-xl-3 col-sm-6 mb-3">
          <div class="card text-white bg-warning o-hidden h-100">
            <div class="card-body">
              <div class="card-body-icon">
                <i class="fa fa-fw fa-list fa-2x"></i>
              </div>
              <div class="mr-5">새로운 공지사항 
	            <c:if test="${noticeNowTotal ne null }">
	            	<span class="badge badge-light">${noticeNowTotal }</span>
	            </c:if>  
              </div>
            
            </div>
            <a class="card-footer text-white clearfix small z-1" href="/admin/notice/list.do">
              <span class="float-left">View Details</span>
              <span class="float-right">
                <i class="fa fa-angle-right"></i>
              </span>
            </a>
          </div>
        </div>
        <div class="col-xl-3 col-sm-6 mb-3">
          <div class="card text-white bg-success o-hidden h-100">
            <div class="card-body">
              <div class="card-body-icon">
               <i class="fas fa-chart-line fa-2x"></i>
              </div>
              <div class="mr-5">이번달 결제 현황 
              <c:if test="${paymentTotal ne null }">
              	<span class="badge badge-light">${paymentTotal }</span>
              </c:if>
              </div>
            </div>
            <a class="card-footer text-white clearfix small z-1" href="/payment/admin_payment.do">
              <span class="float-left">View Details</span>
              <span class="float-right">
                <i class="fa fa-angle-right"></i>
              </span>
            </a>
          </div>
        </div>
        <div class="col-xl-3 col-sm-6 mb-3">
          <div class="card text-white bg-danger o-hidden h-100">
            <div class="card-body">
              <div class="card-body-icon">
              <i class="fas fa-question-circle fa-2x"></i>
              </div>
              <div class="mr-5">QnA 답변 미등록
              <c:if test="${noanswerCnt ne null }">
              	<span class="badge badge-light">${noanswerCnt }</span>
              </c:if>
              </div>
            </div>
            <a class="card-footer text-white clearfix small z-1" href="/admin/qna/list.do">
              <span class="float-left">View Details</span>
              <span class="float-right">
                <i class="fa fa-angle-right"></i>
              </span>
            </a>
          </div>
        </div>
      </div>
 		</div>
      <!-- Area Chart Example-->
      <div class="card mb-3">
        <div class="card-header">
          <i class="fa fa-area-chart"></i> 총 매출</div>
        <div class="card-body">
          <div id="chartdiv"></div>
        </div>
        <div class="card-footer small text-muted" id="sales-year"></div>
      </div>
      <div class="row">
        <div class="col-lg-12">
          <!-- Example Bar Chart Card-->
          <div class="card mb-3">
            <div class="card-header">
              <i class="fa fa-bar-chart"></i>올해 공연 예매 순위</div>
            <div class="card-body">
              <div class="row">
                <div class="col-sm-8 my-auto">
                	<div class="">
                	<c:if test="${not empty topReserves }">
                	
                		<div id="carouselExampleIndicators" class="carousel slide" data-ride="carousel">
                			<ol class="carousel-indicators">
                			<c:forEach items="${topReserves }" var="reserve" varStatus="status">
                				<li data-target="#carouselExampleIndicators" data-slide-to="${status.index }" class="${status.index == 0 ? 'active' : '' }"></li>
                			</c:forEach>
                			</ol>
                		<div class="carousel-inner">
                		<c:forEach items="${topReserves }" var="reserve" varStatus="status">
                			<c:set var="index" value="0" />
                			<div class="carousel-item ${status.index == index ? 'active' : '' }">
                			<c:choose>
                				<c:when test="${fn:substring(reserve.performance.imagePath, 0, 4) eq 'http' }">
                					<c:set var="path" value="${reserve.performance.imagePath }"/>
                				</c:when>
                				<c:otherwise>
                					<c:set var="path" value="/resources/sample-images/${reserve.performance.imagePath }"/>
                				</c:otherwise>
                			</c:choose>
                				<img class="img-thumbnail" style="width: 500px; height: 700px;" src="${path }">

                			</div>
                			<c:set var="index" value="${index + 1 }"/>
                		</c:forEach>
                		</div>
                		</div>
                	</c:if>	
					<a class="carousel-control-prev"
						href="#carouselExampleFade" role="button"
						data-slide="prev"> <span
						class="carousel-control-prev-icon" aria-hidden="true"></span>
					<span class="sr-only">Previous</span>
					</a> <a class="carousel-control-next"
						href="#carouselExampleFade" role="button"
						data-slide="next"> <span
						class="carousel-control-next-icon" aria-hidden="true"></span>
					<span class="sr-only">Next</span>
						</a>
					</div>
					</div>
                <div class="col-sm-4 text-center my-auto">
                <c:if test="${not empty topReserves }" >
                <c:forEach items="${topReserves }" var="reserve" varStatus="status">
                	<c:choose>
                		<c:when test="${status.count eq 1 }">
		                	<c:set var="countColor" value="text-primary"/>
                		</c:when>
                		<c:when test="${status.count eq 2 }">
							<c:set var="countColor" value="text-warning"/>
                		</c:when>
                		<c:otherwise>
                			<c:set var="countColor" value="text-success"/>
                		</c:otherwise>
                	</c:choose>
                  <div class="h4 mb-0 ${countColor }"><span>${status.count }</span>위</div>
                  <div class="">${reserve.performance.title }</div>
                  <hr>
                </c:forEach>
                </c:if>
                </div>
              </div>
            </div>
            <div class="card-footer small text-muted">Updated yesterday at 11:59 PM</div>
          </div>
          <!-- Card Columns Example Social Feed-->
         
          <!-- /Card Columns-->
        </div>
        <div class="col-lg-4">
          <!-- Example Pie Chart Card-->
          <!-- Example Notifications Card-->
          </div>
        </div>
      </div>
    
 </div>
 </div>
  <!-- page-content" -->
</div>
</div>
<!-- page-wrapper -->
<script type="text/javascript">
$(function() {
	$.ajax({
		url:"/payment/totalSales.do",
		dataType:"json",
		success:function(data) {
			$('#chartdiv').empty();
			drawLineChart('chartdiv', data);
			console.log(data[0].lineDate.substring(0,4));
			var year = data[0].lineDate.substring(0,4) + '년도 매출 데이터';
			$('#sales-year').text(year);
		}
	})
	var barChart;
	function initBarChart(el) {
		barChart = am4core.create(el, am4charts.XYChart)
		barChart.colors.step = 2;

		barChart.legend = new am4charts.Legend()
		barChart.legend.position = 'top'
		barChart.legend.paddingBottom = 20
		barChart.legend.labels.template.maxWidth = 95

		var xAxis = barChart.xAxes.push(new am4charts.CategoryAxis())
		xAxis.dataFields.category = 'date'
		xAxis.renderer.cellStartLocation = 0.1
		xAxis.renderer.cellEndLocation = 0.9
		xAxis.renderer.grid.template.location = 0;

		var yAxis = barChart.yAxes.push(new am4charts.ValueAxis());
		yAxis.min = 0;
		
		return barChart;
	} 
	
	function createBarChartSeries(value, name) {
	    var series = barChart.series.push(new am4charts.ColumnSeries())
	    series.dataFields.valueY = value
	    series.dataFields.categoryX = 'date'
	    series.name = name

	    series.events.on("hidden", arrangeBarChartColumns);
	    series.events.on("shown", arrangeBarChartColumns);

	    var bullet = series.bullets.push(new am4charts.LabelBullet())
	    bullet.interactionsEnabled = false
	    bullet.dy = 30;
	    bullet.label.text = '{valueY}'
	    bullet.label.fill = am4core.color('#ffffff')

	    return series;
	}
	
	function arrangeBarChartColumns() {
	    var series = barChart.series.getIndex(0);
	    var xAxis = barChart.xAxes.push(new am4charts.CategoryAxis())
	    
	    var w = 1 - xAxis.renderer.cellStartLocation - (1 - xAxis.renderer.cellEndLocation);
	    if (series.dataItems.length > 1) {
	        var x0 = xAxis.getX(series.dataItems.getIndex(0), "dateX");
	        var x1 = xAxis.getX(series.dataItems.getIndex(1), "dateX");
	        var delta = ((x1 - x0) / barChart.series.length) * w;
	        if (am4core.isNumber(delta)) {
	            var middle = barChart.series.length / 2;

	            var newIndex = 0;
	            barChart.series.each(function(series) {
	                if (!series.isHidden && !series.isHiding) {
	                    series.dummyData = newIndex;
	                    newIndex++;
	                }
	                else {
	                    series.dummyData = barChart.series.indexOf(series);
	                }
	            })
	            var visibleCount = newIndex;
	            var newMiddle = visibleCount / 2;

	            barChart.series.each(function(series) {
	                var trueIndex = barChart.series.indexOf(series);
	                var newIndex = series.dummyData;

	                var dx = (newIndex - trueIndex + middle - newMiddle) * delta

	                series.animate({ property: "dx", to: dx }, series.interpolationDuration, series.interpolationEasing);
	                series.bulletsContainer.animate({ property: "dx", to: dx }, series.interpolationDuration, series.interpolationEasing);
	            })
	        }
	    }
	}
	
	var lineChart;
	function initLineChart(el, data) {
		lineChart = am4core.create("chartdiv", am4charts.XYChart);
		lineChart.data = data;		
		lineChart.dateFormatter.inputDateFormat = "yyyy-MM-dd";
	}
	
	function createLineChartAxis() {
		var dateAxis = lineChart.xAxes.push(new am4charts.DateAxis());
		var valueAxis = lineChart.yAxes.push(new am4charts.ValueAxis());

		dateAxis.start =0;
		dateAxis.keepSelection = true;		
	}
	
	function createLineChartSeries() {
		// Create series
		var series = lineChart.series.push(new am4charts.LineSeries());
		series.dataFields.valueY = "totalSales";
		series.dataFields.dateX = "lineDate";
		series.tooltipText = "{value}"
		series.strokeWidth = 2;
		series.minBulletDistance = 15;
	}
	
	
	function drawChartMethod(el, data) {
		am4core.ready(function() {
			initBarChart(el);
			barChart.data = data;
			createBarChartSeries('credit', '무통장입금');
			createBarChartSeries('card', '신용카드');
		});		
	}
	
	function drawChartStatus(el, data) {
		am4core.ready(function() {
			initBarChart(el);
			barChart.data = data;
			createBarChartSeries('payStatus', '결제건수');
			// createSeries('card', '신용카드');
		});		
	}
	
	function drawLineChart(el, data) {
		am4core.ready(function() {
			initLineChart(el, data);
			createLineChartAxis();
			createLineChartSeries();
		})
	}
	
	
		
	
});
</script>

</body>
</html>