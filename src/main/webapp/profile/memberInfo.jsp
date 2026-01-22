<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

<style>
    /* [WHATFLIX Profile Style] */
    .profile-content-wrapper {
        max-width: 800px;
        animation: fadeInUp 0.6s var(--ease-smooth);
    }

    /* 검색 영역 */
    .search-container {
        background: var(--bg-surface);
        padding: 20px;
        border-radius: 12px;
        border: 1px solid var(--border-glass);
        margin-bottom: 30px;
        display: flex;
        gap: 10px;
    }

    .search-container input {
        flex: 1;
        background: #222;
        border: 1px solid #333;
        color: white;
        padding: 10px 15px;
        border-radius: 6px;
    }

    .search-container input:focus {
        outline: none;
        border-color: var(--primary-red);
    }

    #btnSearch {
        background: var(--primary-red);
        color: white;
        border: none;
        padding: 0 25px;
        border-radius: 6px;
        font-weight: 600;
        transition: 0.2s;
    }

    #btnSearch:hover { background: var(--primary-red-hover); }

    /* 프로필 카드 영역 */
    .member-info {
        background: var(--bg-surface);
        border-radius: 16px;
        padding: 40px;
        border: 1px solid var(--border-glass);
        display: flex;
        gap: 40px;
        align-items: flex-start;
    }

    .member-photo img {
        width: 180px;
        height: 180px;
        border-radius: 12px;
        object-fit: cover;
        border: 2px solid var(--border-glass);
    }

    .info-details { flex: 1; }

    .info-details dl {
        display: grid;
        grid-template-columns: 100px 1fr;
        gap: 15px 0;
        margin: 0;
    }

    .info-details dt {
        color: var(--text-gray);
        font-size: 0.9rem;
        font-weight: 500;
    }

    .info-details dd {
        color: var(--text-white);
        font-size: 1rem;
        margin: 0;
        font-weight: 600;
    }

    /* 비공개 정보 영역 */
    .is-private {
        display: none; 
        grid-column: 1 / span 2;
        margin-top: 15px;
        padding-top: 15px;
        border-top: 1px solid var(--border-glass);
        grid-template-columns: 100px 1fr;
        gap: 15px 0;
    }

    /* 메시지 및 버튼 */
    #info-message {
        background: rgba(229, 9, 20, 0.1);
        color: var(--primary-red);
        padding: 15px;
        border-radius: 8px;
        text-align: center;
    }

    .btn-group {
        display: none; 
        margin-top: 30px;
        gap: 15px;
        justify-content: flex-end;
    }

    #editBtn {
        background: #333;
        color: white;
        border: none;
        padding: 10px 20px;
        border-radius: 4px;
        transition: 0.2s;
    }

    #editBtn:hover { background: #444; }

    #deleteBtn {
        background: transparent;
        color: var(--text-muted);
        border: 1px solid var(--text-muted);
        padding: 10px 20px;
        border-radius: 4px;
        transition: 0.2s;
    }

    #deleteBtn:hover { border-color: var(--primary-red); color: var(--primary-red); }
</style>

<div class="profile-content-wrapper" data-context-path="${pageContext.request.contextPath}">
    <!-- 검색 폼 -->
    <div class="search-container">
        <form id="searchForm" action="memberSearchAction.jsp" method="post" class="d-flex w-100 gap-2">
            <input type="text" name="nickname" id="searchNickname" placeholder="검색할 닉네임을 입력하세요">
            <button type="submit" id="btnSearch">검색</button>
        </form>
    </div>

    <p id="info-message" style="display:none;"></p>

    <!-- 회원 정보 카드 -->
    <div class="member-info shadow-lg" style="display:none;">
        <div class="member-photo">
            <img id="photo" src="${pageContext.request.contextPath}${sessionScope.memberInfo.photo}" alt="프로필 이미지" />
        </div>
        
        <div class="info-details">
            <dl>
                <dt>닉네임</dt>
                <dd id="memberNickname"></dd>
                
                <dt>아이디</dt>
                <dd id="memberIdPublic"></dd>
                
                <dt>가입일</dt>
                <dd id="memberCreateDay"></dd>

                <!-- 내 프로필일 때만 보여지는 상세 정보 영역 -->
                <div class="is-private">
                    <dt>회원번호</dt>
                    <dd id="memberIdx"></dd>
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

            <div class="btn-group">
                <button id="editBtn" type="button"><i class="bi bi-pencil-square me-2"></i>정보 수정</button>
                <form id="deleteForm" action="memberDeleteAction.jsp" method="post">
                    <input type="hidden" name="id" value="${sessionScope.memberInfo.id}">
                    <button type="button" id="deleteBtn">회원탈퇴</button>
                </form>
            </div>
        </div>
    </div>
</div>

<script>
    $(document).ready(function () {
        var urlParams = new URLSearchParams(window.location.search);
        // [수정] JSP 파라미터 -> URL 파라미터 -> 세션 로그인ID 순으로 Fallback 처리
        var targetId = "${param.id}" 
                       || urlParams.get('id') 
                       || "${sessionScope.memberInfo.id}";
 
        if (!targetId || targetId === "null") {
            $('.member-info').html('<p class="text-center py-5">로그인이 필요하거나 잘못된 접근입니다.</p>').show();
            return;
        }

        // 회원 검색 로직 보존
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
                    if (data && data.status == "SUCCESS") {
                        renderProfile(data);
                    } else if (data && data.status == "NOT_FOUND") {
                        $('.member-info').hide();
                        $('#info-message').text('회원 정보를 찾을 수 없습니다.').show();
                    } else if (data && data.status == "GUEST") {
                        $('.member-info').hide();
                        $('#info-message').text('비회원입니다.').show();
                    }
                },
                error: function () {
                    $('.member-info').html('<p class="text-center">데이터 통신 오류가 발생했습니다.</p>');
                }
            });
        });

        // 초기 데이터 로드 로직 보존
        $.ajax({
            url: "memberInfoAction.jsp",
            type: "post",
            data: { id: targetId },
            dataType: "json",
            success: function (data) {
                if (data && data.status == "SUCCESS") {
                    renderProfile(data);
                    $('#info-message').hide();
                } else {
                    $('.member-info').hide();
                    $('#info-message').text(data.message || '회원 정보를 불러올 수 없거나 존재하지 않습니다.').show();
                }
            },
            error: function () {
                $('.member-info').hide();
                $('#info-message').text('서버와의 통신에 실패했습니다.').show();
            }
        });

        // 회원정보 수정 로드 로직 보존
        $('#editBtn').click(function () {
            $("#content-area").load("memberInfoEdit.jsp?id=" + targetId);
        });

        // 회원탈퇴 로직 보존
        $('#deleteBtn').click(function () {
            if (confirm("정말 WHATFLIX를 떠나시겠습니까? 모든 정보가 삭제됩니다.")) {
                $('#deleteForm').submit();
            }
        });
    });

    // 데이터 렌더링 함수 로직 보존
    function renderProfile(data) {
        const contextPath = $('.profile-content-wrapper').data('context-path');
        $('#info-message').hide();
        $('.member-info').css('display', 'flex');
        targetId = data.id;
        
        // [수정] 사진 없을 시 기본 이미지 처리
        var photoPath = data.photo ? (contextPath + data.photo) : (contextPath + "/save/no_photo.png");
        $('#photo').attr('src', photoPath);
        
        $('#memberNickname').text(data.nickname);
        $('#memberIdPublic').text(data.id); // 공개용 아이디
        $('#memberCreateDay').text(data.createDay);

        // [수정] 권한에 따른 분기 처리 및 정보 클리어
        if (data.isMine) {
            $('#memberIdx').text(data.memberIdx);
            $('#memberName').text(data.name);
            $('#memberGender').text(data.gender);
            $('#memberAge').text(data.age);
            $('#memberHp').text(data.hp);
            $('#memberAddr').text(data.addr);
            $('.is-private').css('display', 'grid');
            $('.btn-group').css('display', 'flex');
        } else {
            // 타인 프로필일 경우 개인정보 필드 초기화 및 숨김
            $('#memberIdx, #memberName, #memberGender, #memberAge, #memberHp, #memberAddr').text('');
            $('.is-private').hide();
            $('.btn-group').hide();
        }
    }
</script>
