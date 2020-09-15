<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>같이 보자! 공공연한사이</title>
    <link rel="stylesheet"
          href="https://maxcdn.bootstrapcdn.com/bootstrap/4.5.0/css/bootstrap.css">
    <link rel="stylesheet"
          href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.14.0/css/all.min.css"/>
    <link rel="stylesheet" href="/resources/css/style.css"/>
    <link rel="stylesheet" href="/resources/css/card.css"/>
    <link rel="stylesheet" href="/resources/css/mypage.css"/>

    <script src="https://code.jquery.com/jquery-3.5.1.min.js"></script>
    <script
            src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/2.4.4/umd/popper.min.js"></script>
    <script
            src="https://maxcdn.bootstrapcdn.com/bootstrap/4.5.0/js/bootstrap.js"></script>
    <script type="text/javascript" src="/resources/js/jquery.color.js"></script>
    <script type="text/javascript" src="/resources/js/custom.js"></script>
    <script type="text/javascript" src="/resources/js/mypage/myprofile.js"></script>

    <style>
        #mypage-card .card:hover {
            background-color: #FFF;
            color: #000;
        }

        #mypage-card .card-body:hover {
            background-color: #FFF;
            color: #000;
        }
    </style>

</head>
<body>
<div class="header">
    <%@ include file="../common/navi.jsp" %>
</div>
<div class="body mt-5">
    <div class="container-fluid mb-4">
        <div class="row">
            <%@ include file="./mypagemenubar.jsp" %>
            <div class="col-8 mt-4">
                <div class="container">
                    <%@ include file="./mypageheader.jsp" %>
                    <div class="mypage-card-header mt-3">
                        <div class="row">
                            <div class="col-12">
                                <h2 class="font-weight-bold">내 상세 정보</h2>
                            </div>
                        </div>
                    </div>
                    <div class="card mt-3" id="mypage-card">
                        <div class="card-body">
                            <div class="row">
                                <div class="col-12 mt-2 mb-2">
                                    <div class="row">
                                        <div class="col-4">
                                            <h1><span id="nickname">user nickname</span>님</h1>
                                        </div>
                                        <div class="col-4">
                                            <h4>가입일 : <span id="reg-date"></span></h4>
                                        </div>
                                        <div class="col-4">
                                            <h4>회원등급 : <span id="grade"></span></h4>
                                        </div>
                                    </div>
                                </div>
                            </div>
                            <hr>
                            <div class="col-12">
                                <h4> 자기소개</h4>
                                <div class="card mt-3">
                                    <div class="row">
                                        <div class="card-body">

                                            <div class=row>
                                                <div class="col-12" id="intro-tags">
                                                </div>
                                            </div>

                                            <div class="row">
                                                <div class="col-2 offset-10">
                                                    <!-- Button trigger modal -->
                                                    <button class="btn btn-outline-secondary"  data-toggle="modal" data-target="#intro-tag-update-modal" data-whatever="124125">
                                                        추가/삭제
                                                    </button>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                            <br>
                            <div class="col-12">
                                <h4 id="interest-header"> 관심분야</h4>
                                <div class="card mt-3">
                                    <div class="row">
                                        <div class="card-body">
                                            <div class="row">
                                                <div class="col-2">공연장르</div>
                                                <div class="col-10" id="interest-genre"></div>
                                            </div>
                                            <hr>
                                            <div class="row">
                                                <div class="col-2">아티스트</div>
                                                <div class="col-10" id="interest-artist"></div>
                                            </div>
                                            <hr>
                                            <div class="row">
                                                <div class="col-2">공연명</div>
                                                <div class="col-10" id="interest-performance"></div>
                                            </div>
                                            <div class="row">
                                                <div class="col-2 offset-10">
                                                    <button class="btn btn-outline-secondary" data-toggle="modal" data-target="#interest-modal" data-interest-upate="">
                                                        추가/삭제
                                                    </button>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>


                        </div>
                    </div>

                    <!-- intro form Modal -->
                    <div class="modal fade" id="intro-tag-update-modal" tabindex="-1" role="dialog" aria-labelledby="intro-modal-label" aria-hidden="true">
                        <div class="modal-dialog modal-dialog-centered" role="document">
                            <div class="modal-content">
                                <div class="modal-header">
                                    <h5 class="modal-title" id="intro-modal-label">자기소개를 해쉬태그로 등록해보세요!</h5>
                                    <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                                        <span aria-hidden="true">&times;</span>
                                    </button>
                                </div>
                                <div class="modal-body">
                                    <form>
                                        <div class="form-group">
                                            <label for="introduce-tag" class="col-form-label">자기소개</label>
                                            <input type="text" class="form-control" id="introduce-tag" placeholder="자기소개를 태그로 입력해보세요"/>
                                        </div>
                                    </form>
                                </div>
                                <div class="modal-footer">
                                    <button type="button" class="btn btn-secondary" data-dismiss="modal">닫기</button>
                                    <button type="button" class="btn btn-primary" id="update-intro">저장하기</button>
                                </div>
                            </div>
                        </div>
                    </div>
                    <!-- Modal -->
                    <div class="modal fade" id="interest-modal" tabindex="-1" role="dialog" aria-labelledby="interest-modal-label" aria-hidden="true">
                        <div class="modal-dialog modal-dialog-centered" role="document">
                            <div class="modal-content">
                                <div class="modal-header">
                                    <h5 class="modal-title" id="interest-modal-label">내가 좋아하는 것들을 해쉬태그로 입력해주세요</h5>
                                    <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                                        <span aria-hidden="true">&times;</span>
                                    </button>
                                </div>
                                <div class="modal-body">
                                    <form>
                                        <div class="form-group">
                                            <label for="introduce-tag" class="col-form-label">공연 장르</label>
                                            <input type="text" class="form-control" id="genre-tag" placeholder="좋아하는 장르를 입력해주세요"/>
                                        </div>
                                        <div class="form-group">
                                            <label for="introduce-tag" class="col-form-label">아티스트</label>
                                            <input type="text" class="form-control" id="artist-tag" placeholder="좋아하는 아티스트를 입력해주세요"/>
                                        </div>
                                        <div class="form-group">
                                            <label for="introduce-tag" class="col-form-label">공연명</label>
                                            <input type="text" class="form-control" id="performance-tag" placeholder="좋아하는 공연을 입력해주세요"/>
                                        </div>
                                    </form>
                                </div>
                                <div class="modal-footer">
                                    <button type="button" class="btn btn-secondary" data-dismiss="modal">닫기</button>
                                    <button type="button" class="btn btn-primary" id="update-interest">저장하기</button>
                                </div>
                            </div>
                        </div>
                    </div>

                </div>
            </div>
        </div>
    </div>
    <div class="footer">
        <%@ include file="../common/footer.jsp" %>
    </div>
    <script type="text/javascript">


    </script>
</div>
</body>
</html>