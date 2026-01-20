<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <style>
        .is-private,
        .btn-group {
            display: none;
        }
    </style>

    <div class="container">
        <form id="searchForm" action="memberSearchAction.jsp" method="post">
            <input type="text" name="nickname" id="searchNickname" placeholder="닉네임 입력">
            <button type="submit" id="btnSearch">프로필 검색</button>
        </form>
    </div>
    <p id="info-message" style="display:none;"></p>
    <div class="member-info">
        <div class="member-photo">
            <img id="photo" src="${pageContext.request.contextPath}${sessionScope.memberInfo.photo}" alt="프로필" />
        </div>
        <dl>
            <dt>닉네임</dt>
            <dd id="memberNickname"></dd>
            <dt>가입일</dt>
            <dd id="memberCreateDay"></dd>
            <div class="is-private">
                <dt>회원번호</dt>
                <dd id="memberIdx"></dd>
                <dt>아이디</dt>
                <dd id="memberId"></dd>
                <dt>이름</dt>
                <dd id="memberName"></dd>
                <dt>성별</dt>
                <dd id="memberGender"></dd>
                <dt>나이</dt>
                <dd id="memberAge"></dd>
                <dt>전화번호</dt>
                <dd id="memberHp"></dd>
                <dt>주소</dt>
                <dd id="memberAddr"></dd>
            </div>
        </dl>
    </div>
    <div class="btn-group">
        <button id="editBtn" type="button">회원정보 수정</button>
        <form id="deleteForm" action="memberDeleteAction.jsp" method="post">
            <input type="hidden" name="id" value="${sessionScope.memberInfo.id}">
            <button type="button" id="deleteBtn">회원탈퇴</button>
        </form>
    </div>
    <!-- ajax 통신 -->
    <script>
        var urlParams = new URLSearchParams(window.location.search);
        var targetId = urlParams.get('id');

        $(document).ready(function () {
            if (!targetId) {
                $('.member-info').html('<p>잘못된 접근입니다.</p>');
                return;
            }

            // 회원 검색
            $('#searchForm').submit(function (e) {
                e.preventDefault();
                var nickname = $('#searchNickname').val();
                if (!nickname) {
                    alert('닉네임을 입력해주세요.');
                    return;
                }

                $.ajax({
                    url: "memberSearchAction.jsp",
                    type: "post",
                    data: { nickname: nickname },
                    dataType: "json",
                    success: function (data) {
                        $('#info-message').hide();
                        $('.member-info').show();
                        if (data && data.status == "SUCCESS") {
                            renderProfile(data);
                        } else if (data && data.status == "NOT_FOUND") {
                            $('.member-info').hide();
                            $('#info-message').text('회원 정보를 찾을 수 없습니다.').show();
                        } else if (data && data.status == "GUEST") {
                            $('.member-info').hide();
                            $('#info-message').text('비회원입니다.').show();
                        } else {
                            $('.member-info').html('<p>데이터 통신 오류.</p>');
                        }
                    },
                    error: function (xhr, status, error) {
                        console.log(xhr, status, error);
                        $('.member-info').html('<p>데이터 통신 오류.</p>');
                    }
                });
            });

            // 처음 페이지 진입시 조회
            $.ajax({
                url: "memberInfoAction.jsp",
                type: "post",
                data: { id: targetId },
                dataType: "json",
                success: function (data) {

                    if (data && data.status == "SUCCESS") {
                        renderProfile(data);
                        $('#info-message').hide();
                        $('.member-info').show();
                    } else if (data && data.status == "NOT_FOUND") {
                        $('.member-info').hide();
                        $('#info-message').text('회원 정보를 찾을 수 없습니다.').show();
                    } else if (data && data.status == "GUEST") {
                        $('.member-info').hide();
                        $('#info-message').text('비회원입니다.').show();
                    } else {
                        $('.member-info').html('<p>데이터 통신 오류.</p>');
                    }
                },
                error: function (xhr, status, error) {
                    console.log(xhr, status, error);
                    $('.member-info').html('<p>데이터 통신 오류.</p>');
                }
            });
            //회원정보 수정
            $('#editBtn').click(function () {
                $("#content-area").load("memberInfoEdit.jsp?id=" + targetId);
            });
            //회원탈퇴
            $('#deleteBtn').click(function () {
                if (confirm("정말 탈퇴하시겠습니까?")) {
                    $('#deleteForm').submit();
                }
            });
        });


        function renderProfile(data) {

            $('#info-message').hide();
            $('.member-info').show();
            targetId = data.id;
            $('#photo').attr('src', "${pageContext.request.contextPath}" + data.photo);
            $('#memberNickname').text(data.nickname);
            $('#memberCreateDay').text(data.createDay);

            if (data.isMine) {
                $('#memberIdx').text(data.memberIdx);
                $('#memberId').text(data.id);
                $('#memberName').text(data.name);
                $('#memberGender').text(data.gender);
                $('#memberAge').text(data.age);
                $('#memberHp').text(data.hp);
                $('#memberAddr').text(data.addr);
                $('.btn-group').show();
                $('.is-private, .btn-group').show();
            } else {
                $('.is-private, .btn-group').hide();
                $('.is-private span').text('');
                $('.is-private dd').text('');
            }
        }
    </script>