<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>WhatFlix - Admin Dashboard</title>

<script src="https://code.highcharts.com/highcharts.js"></script>
<script src="https://code.jquery.com/jquery-3.7.1.js"></script>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
<script src="https://cdnjs.cloudflare.com/ajax/libs/bootstrap/5.3.0/js/bootstrap.bundle.min.js"></script>

<style>
/* [1] Design Tokens (기존 코드 유지 및 활용) */
:root {
	--primary-red: #E50914;
	--primary-red-hover: #B20710;
	--bg-main: #141414;
	--bg-surface: #181818;
	--text-white: #FFFFFF;
	--text-gray: #BCBCBC;
	--shadow-elevation: 0 10px 40px -10px rgba(0, 0, 0, 0.7);
}

body {
	background-color: var(--bg-main);
	color: var(--text-white);
	font-family: 'Pretendard', sans-serif;
	overflow-x: hidden;
}

/* [2] Dashboard Layout (새로 추가된 부분) */
.dashboard-container {
    max-width: 1400px;
    margin: 100px auto 100px;
    padding: 0 20px;
}

.dashboard-title {
    font-size: 1.8rem;
    font-weight: 800;
    margin-bottom: 30px;
    border-left: 5px solid var(--primary-red);
    padding-left: 15px;
    display: flex;
    align-items: center;
    gap: 10px;
}

/* 그리드 레이아웃: 위 2개, 아래 1개 */
.dashboard-grid {
    display: grid;
    grid-template-columns: repeat(2, 1fr); /* 2열 */
    gap: 25px;
}

/* 차트 박스 디자인 (기존 .chart-container 업그레이드) */
.chart-box {
    background-color: var(--bg-surface);
    padding: 25px;
    border-radius: 12px;
    border: 1px solid #333;
    box-shadow: var(--shadow-elevation);
    transition: transform 0.3s ease;
}

.chart-box:hover {
    border-color: #555;
}

/* 하단 랭킹 차트는 가로로 길게 쓰기 */
.full-width {
    grid-column: 1 / -1; /* 처음부터 끝까지 차지 */
}

/* 반응형: 모바일에서는 한 줄에 하나씩 */
@media (max-width: 768px) {
    .dashboard-grid {
        grid-template-columns: 1fr;
    }
}
</style>
</head>
<body>
    <jsp:include page="../main/nav.jsp" />
    <jsp:include page="../login/loginModal.jsp" />
    <jsp:include page="../profile/profileModal.jsp"/>

    <div class="dashboard-container">
        <h2 class="dashboard-title">
            <i class="bi bi-speedometer2" style="color: var(--primary-red);"></i> 
            WHATFLIX ANALYTICS
        </h2>

        <div class="dashboard-grid">
            
            <div class="chart-box">
                <div id="genreChart" style="width: 100%; height: 350px;"></div>
            </div>

            <div class="chart-box">
                <div id="genderChart" style="width: 100%; height: 350px;"></div>
            </div>

            <div class="chart-box full-width">
                <div id="rankChart" style="width: 100%; height: 400px;"></div>
            </div>
            
        </div>
    </div>

<script>
$(document).ready(function() {
    // 모든 차트 로드 함수 호출
    drawGenreChart();
    drawGenderChart();
    drawRankChart();
});

// [공통 설정] 넷플릭스 테마 (중복 코드 제거용)
const commonTheme = {
    chart: {
        backgroundColor: '#181818', // --bg-surface 색상
        style: { fontFamily: 'Pretendard, sans-serif' }
    },
    title: {
        style: { color: '#E50914', fontSize: '18px', fontWeight: 'bold' }
    },
    credits: { enabled: false }, // 로고 숨김
    tooltip: {
        backgroundColor: 'rgba(0, 0, 0, 0.9)',
        style: { color: '#fff' },
        borderRadius: 8
    },
    legend: {
        itemStyle: { color: '#BCBCBC' }, // 범례 글자색
        itemHoverStyle: { color: '#FFF' }
    },
    // X, Y축 라벨 색상
    xAxis: {
        labels: { style: { color: '#BCBCBC' } },
        lineColor: '#333'
    },
    yAxis: {
        labels: { style: { color: '#BCBCBC' } },
        gridLineColor: '#333',
        title: { style: { color: '#BCBCBC' } }
    }
};

// 1. 장르별 점유율 (Pie)
function drawGenreChart() {
    $.ajax({
        url : "${pageContext.request.contextPath}/chart/genreData.jsp", // 경로 확인 필요
        type : "get",
        dataType : "json",
        success : function(data) {
        	Highcharts.chart('genreChart', Highcharts.merge(commonTheme, {
        	    chart: { type: 'pie' },
        	    title: { text: '장르별 콘텐츠 점유율' },
        	    
        	    // [▼ 여기를 수정하세요] 툴팁 디자인 변경
        	    tooltip: {
        	        // [디자인] 툴팁 배경을 더 진하고 투명하게 (넷플릭스 스타일)
        	        backgroundColor: 'rgba(20, 20, 20, 0.95)',
        	        borderColor: '#333',
        	        borderRadius: 8,
        	        style: { color: '#fff' },
        	        
        	        // [핵심] 마우스 올렸을 때 보이는 내용 포맷
        	        // {point.key}: 장르 이름 (예: 액션)
        	        // {point.percentage:.1f}: 퍼센트 (소수점 1자리)
        	        // {point.y}: 실제 조회수
        	        headerFormat: '<span style="font-size: 13px; color: #BCBCBC">{point.key}</span><br/>',
        	        pointFormat: '<span style="color: #E50914; font-size: 16px; font-weight: bold">{point.percentage:.1f}%</span><br/>' +
        	                     '<span style="font-size: 11px; color: #777">({point.y:,0f}회 조회)</span>'
        	    },

        	    plotOptions: {
        	        pie: {
        	            innerSize: '50%',
        	            borderWidth: 0,
        	            dataLabels: {
        	                enabled: true,
        	                // 차트 위에 떠있는 라벨도 퍼센트로 바꿀까요? 
        	                // 이름만 보이게 하려면 '{point.name}'
        	                // 퍼센트도 같이 보이려면 '{point.name}: {point.percentage:.1f}%'
        	                format: '<b>{point.name}</b>', 
        	                style: { color: '#ccc', textOutline: 'none' },
        	                connectorColor: '#555'
        	            }
        	        }
        	    },
                colors: ['#E50914', '#B20710', '#831010', '#555', '#444'], // 레드 톤
                series: [{ name: '점유율', data: data }]
            }));
        },
        error: function() { $("#genreChart").html("<p class='text-center text-muted mt-5'>데이터 로드 실패</p>"); }
    });
}

// 2. 회원 성비 (Pie)
function drawGenderChart() {
    $.ajax({
        // [주의] 이 파일(memberGenderData.jsp)이 /chart/ 폴더에 있어야 합니다.
        url : "${pageContext.request.contextPath}/chart/memberGenderData.jsp", 
        type : "get",
        dataType : "json",
        success : function(data) {
            Highcharts.chart('genderChart', Highcharts.merge(commonTheme, {
                chart: { type: 'pie' },
                title: { text: '회원 성별 분포' },
                plotOptions: {
                    pie: {
                        borderWidth: 0,
                        dataLabels: {
                            enabled: true,
                            format: '{point.name}: {point.percentage:.1f} %',
                            style: { color: '#ccc', textOutline: 'none' }
                        }
                    }
                },
                // 남성은 회색, 여성은 넷플릭스 레드 포인트 (세련된 조합)
                colors: ['#555555', '#E50914', '#999'], 
                series: [{ name: '인원', data: data }]
            }));
        }
    });
}

// 3. 인기 영화 랭킹 (Bar)
function drawRankChart() {
    $.ajax({
        // [주의] 이 파일(movieRankData.jsp)이 /chart/ 폴더에 있어야 합니다.
        url : "${pageContext.request.contextPath}/chart/movieRankData.jsp", 
        type : "get",
        dataType : "json",
        success : function(data) {
            Highcharts.chart('rankChart', Highcharts.merge(commonTheme, {
                chart: { type: 'bar' }, // 가로 막대 그래프
                title: { text: '실시간 인기 콘텐츠 TOP 5' },
                xAxis: {
                    categories: data.titles, // 영화 제목
                    title: { text: null }
                },
                yAxis: {
                    min: 0,
                    title: { text: '누적 조회수', align: 'high' }
                },
                plotOptions: {
                    bar: {
                        borderRadius: 4,
                        borderWidth: 0,
                        dataLabels: { enabled: true, color: '#fff', style: { textOutline: 'none' } }
                    }
                },
                legend: { enabled: false }, // 범례 숨김 (단일 시리즈라 불필요)
                series: [{
                    name: '조회수',
                    data: data.views,
                    color: '#E50914' // 막대 색상: 넷플릭스 레드
                }]
            }));
        }
    });
}
</script>
</body>
<footer>
<jsp:include page="../main/footer.jsp" />
</footer>
</html>