// 영화 데이터
const movieData = {
    hero: {
        title: "인터스텔라",
        description: "지구 환경이 악화된 미래, 인류를 구하기 위해 떠나는 우주 여정. 시공간을 넘어서는 감동적인 스토리와 놀라운 시각 효과로 여러분을 설득합니다.",
        image: "https://images.unsplash.com/photo-1419242902214-272b3f66ee7a?w=1920&q=80",
        year: "2014",
        rating: "9.2",
        ageRating: "12+"
    },
    popular: [
        {
            id: 1,
            title: "인터스텔라",
            image: "https://images.unsplash.com/photo-1536440136628-849c177e76a1?w=400&q=80",
            year: "2014",
            rating: "9.2",
            ageRating: "12+"
        },
        {
            id: 2,
            title: "다크 나이트",
            image: "https://images.unsplash.com/photo-1509347528160-9a9e33742cdb?w=400&q=80",
            year: "2008",
            rating: "9.0",
            ageRating: "15+"
        },
        {
            id: 3,
            title: "어벤져스",
            image: "https://images.unsplash.com/photo-1635805737707-575885ab0820?w=400&q=80",
            year: "2012",
            rating: "8.0",
            ageRating: "12+"
        },
        {
            id: 4,
            title: "라라랜드",
            image: "https://images.unsplash.com/photo-1489599849927-2ee91cede3ba?w=400&q=80",
            year: "2016",
            rating: "8.0",
            ageRating: "12+"
        },
        {
            id: 5,
            title: "쇼생크 탈출",
            image: "https://images.unsplash.com/photo-1524712245354-2c4e5e7121c0?w=400&q=80",
            year: "1994",
            rating: "9.3",
            ageRating: "15+"
        },
        {
            id: 6,
            title: "그랜드 부다페스트",
            image: "https://images.unsplash.com/photo-1518676590629-3dcbd9c5a5c9?w=400&q=80",
            year: "2014",
            rating: "8.1",
            ageRating: "12+"
        },
        {
            id: 16,
            title: "셰이프 오브 워터",
            image: "https://images.unsplash.com/photo-1536440136628-849c177e76a1?w=400&q=80",
            year: "2017",
            rating: "7.3",
            ageRating: "15+"
        },
        {
            id: 17,
            title: "미나리",
            image: "https://images.unsplash.com/photo-1524712245354-2c4e5e7121c0?w=400&q=80",
            year: "2020",
            rating: "8.3",
            ageRating: "12+"
        },
        {
            id: 18,
            title: "패러사이트",
            image: "https://images.unsplash.com/photo-1517604931442-7e0c8ed2963c?w=400&q=80",
            year: "2019",
            rating: "8.6",
            ageRating: "15+"
        },
        {
            id: 19,
            title: "그린북",
            image: "https://images.unsplash.com/photo-1489599849927-2ee91cede3ba?w=400&q=80",
            year: "2018",
            rating: "8.2",
            ageRating: "12+"
        }
    ],
    newReleases: [
        {
            id: 20,
            title: "쏘우",
            image: "https://images.unsplash.com/photo-1534447677768-be436bb09401?w=400&q=80",
            year: "2023",
            rating: "7.5",
            ageRating: "12+"
        },
        {
            id: 21,
            title: "해리포터",
            image: "https://images.unsplash.com/photo-1518676590629-3dcbd9c5a5c9?w=400&q=80",
            year: "2001",
            rating: "7.6",
            ageRating: "12+"
        },
        {
            id: 22,
            title: "레미제라블",
            image: "https://images.unsplash.com/photo-1560169897-fc0cdbdfa4d5?w=400&q=80",
            year: "2012",
            rating: "7.8",
            ageRating: "12+"
        },
        {
            id: 7,
            title: "바비",
            image: "https://images.unsplash.com/photo-1560169897-fc0cdbdfa4d5?w=400&q=80",
            year: "2023",
            rating: "7.4",
            ageRating: "12+"
        },
        {
            id: 8,
            title: "오펜하이머",
            image: "https://images.unsplash.com/photo-1518770660439-4636190af475?w=400&q=80",
            year: "2023",
            rating: "8.5",
            ageRating: "15+"
        },
        {
            id: 9,
            title: "아바타 2",
            image: "https://images.unsplash.com/photo-1517604931442-7e0c8ed2963c?w=400&q=80",
            year: "2022",
            rating: "7.6",
            ageRating: "12+"
        },
        {
            id: 10,
            title: "탑건",
            image: "https://images.unsplash.com/photo-1474302770737-173ee21bab63?w=400&q=80",
            year: "2022",
            rating: "8.2",
            ageRating: "12+"
        },
        {
            id: 11,
            title: "에브리씽",
            image: "https://images.unsplash.com/photo-1534447677768-be436bb09401?w=400&q=80",
            year: "2023",
            rating: "8.1",
            ageRating: "12+"
        }
    ],
    viewed: [
        {
            id: 12,
            title: "존윅",
            image: "https://images.unsplash.com/photo-1509347528160-9a9e33742cdb?w=400&q=80",
            year: "2014",
            rating: "7.4",
            ageRating: "18+"
        },
        {
            id: 13,
            title: "매드맥스",
            image: "https://images.unsplash.com/photo-1506318137071-a8bcbf6755dd?w=400&q=80",
            year: "2015",
            rating: "8.1",
            ageRating: "15+"
        },
        {
            id: 14,
            title: "글래디에이터",
            image: "https://images.unsplash.com/photo-1485846234645-a62644f84728?w=400&q=80",
            year: "2000",
            rating: "8.5",
            ageRating: "15+"
        },
        {
            id: 15,
            title: "마블 시리즈",
            image: "https://images.unsplash.com/photo-1635805737707-575885ab0820?w=400&q=80",
            year: "2023",
            rating: "7.8",
            ageRating: "12+"
        },
        {
            id: 23,
            title: "스타워즈",
            image: "https://images.unsplash.com/photo-1419242902214-272b3f66ee7a?w=400&q=80",
            year: "1977",
            rating: "8.6",
            ageRating: "12+"
        },
        {
            id: 24,
            title: "마블",
            image: "https://images.unsplash.com/photo-1635805737707-575885ab0820?w=400&q=80",
            year: "2023",
            rating: "7.9",
            ageRating: "12+"
        },
        {
            id: 25,
            title: "반지의 제왕",
            image: "https://images.unsplash.com/photo-1518770660439-4636190af475?w=400&q=80",
            year: "2001",
            rating: "8.8",
            ageRating: "12+"
        }
    ],
};

// 페이지 로드 시 초기화
document.addEventListener('DOMContentLoaded', () => {
    initHero();
    renderMovieSection('popular', movieData.popular);
    renderMovieSection('new-releases', movieData.newReleases);
    renderMovieSection('viewed', movieData.viewed);
    renderReviewPreview();
    renderQnAPreview();
    initNavbarScroll();
    initWheelScroll();
    initAutoScroll();
});

// 자동 스크롤 기능
function initAutoScroll() {
    const sliders = document.querySelectorAll('.movie-slider');

    sliders.forEach(slider => {
        let scrollAmount = 0;
        let isHovered = false;

        // 호버 시 스크롤 일시 정지
        slider.addEventListener('mouseenter', () => {
            isHovered = true;
        });

        slider.addEventListener('mouseleave', () => {
            isHovered = false;
        });

        function autoScroll() {
            if (!isHovered) {
                slider.scrollLeft += 1; // 스크롤 속도 조절 (1px)

                // 끝에 도달하면 처음으로 복귀 (부드럽게 혹은 즉시)
                if (slider.scrollLeft + slider.clientWidth >= slider.scrollWidth) {
                    slider.scrollLeft = 0;
                }
            }
            requestAnimationFrame(autoScroll);
        }

        // 각 슬라이더마다 약간의 시차를 두고 시작하거나 동시에 시작
        requestAnimationFrame(autoScroll);
    });
}

// 히어로 섹션 초기화
function initHero() {
    const hero = movieData.hero;
    document.getElementById('hero-title').textContent = hero.title;
    document.getElementById('hero-description').textContent = hero.description;
    document.getElementById('hero-background').style.backgroundImage = `url('${hero.image}')`;
}

// 영화 카드 생성
function createMovieCard(movie) {
    const card = document.createElement('div');
    card.className = 'movie-card';
    card.dataset.movieId = movie.id;

    card.innerHTML = `
        <img class="movie-card-image" src="${movie.image}" alt="${movie.title}">
        <div class="movie-card-info">
            <div class="movie-card-title">${movie.title}</div>
            <div class="movie-card-meta">
                <span class="rating">${movie.rating}</span>
                <span class="year">${movie.year}</span>
                <span class="age-rating">${movie.ageRating}</span>
            </div>
        </div>
    `;

    // 클릭 이벤트
    card.addEventListener('click', () => {
        console.log('Movie clicked:', movie.title);
        // TODO: 영화 상세 페이지로 이동
        // window.location.href = `/movie-detail.html?id=${movie.id}`;
    });

    return card;
}

// 영화 섹션 렌더링
function renderMovieSection(sectionId, movies) {
    const container = document.getElementById(sectionId);
    if (!container) return;

    container.innerHTML = '';
    movies.forEach(movie => {
        const card = createMovieCard(movie);
        container.appendChild(card);
    });
}

// 네비게이션 스크롤 효과
function initNavbarScroll() {
    const navbar = document.querySelector('.navbar');

    window.addEventListener('scroll', () => {
        if (window.scrollY > 50) {
            navbar.classList.add('scrolled');
        } else {
            navbar.classList.remove('scrolled');
        }
    });
}

// 휠 스크롤 지원
function initWheelScroll() {
    const sliders = document.querySelectorAll('.movie-slider');

    sliders.forEach(slider => {
        slider.addEventListener('wheel', (e) => {
            if (e.deltaY !== 0) {
                e.preventDefault();
                slider.scrollLeft += e.deltaY;
            }
        });
    });
}

// 검색 기능 (기본 구현)
const searchInput = document.querySelector('.search-box input');
if (searchInput) {
    searchInput.addEventListener('keypress', (e) => {
        if (e.key === 'Enter') {
            const searchTerm = searchInput.value.trim();
            if (searchTerm) {
                console.log('Search:', searchTerm);
                // TODO: 검색 기능 구현
                // window.location.href = `/search.html?q=${encodeURIComponent(searchTerm)}`;
            }
        }
    });
}

// 리뷰 데이터
const reviewData = [
    {
        id: 1,
        userName: "김영화",
        userAvatar: "김",
        movieTitle: "인터스텔라",
        rating: 5,
        date: "2025-01-07",
        content: "정말 감동적인 영화였습니다. 시공간을 넘나드는 이야기가 너무나 아름다웠고, 마지막 장면에서 눈물을 멈출 수 없었습니다.",
        likes: 245,
        comments: 32
    },
    {
        id: 2,
        userName: "이시네마",
        userAvatar: "이",
        movieTitle: "다크 나이트",
        rating: 5,
        date: "2025-01-06",
        content: "히어로 영화의 새로운 기준을 세운 작품입니다. 조커의 연기는 압도적이었고, 브루스 웨인의 내면 갈등을 깊이 있게 그려냈습니다.",
        likes: 189,
        comments: 28
    },
    {
        id: 3,
        userName: "박코믹",
        userAvatar: "박",
        movieTitle: "어벤져스",
        rating: 4,
        date: "2025-01-05",
        content: "마블 히어로들이 모여서 시각적 즐거움은 만점입니다. 하지만 너무 많은 캐릭터 때문에 각 캐릭터의 서사가 부족하다는 느낌이 들었습니다.",
        likes: 156,
        comments: 19
    }
];

// QnA 데이터
const qnaData = [
    {
        id: 1,
        badge: "answered",
        badgeText: "답변완료",
        question: "영화 리뷰는 어떻게 작성하나요?",
        author: "김시네마",
        date: "2025-01-07",
        views: 1250
    },
    {
        id: 2,
        badge: "answered",
        badgeText: "답변완료",
        question: "찜 목록은 어디서 확인할 수 있나요?",
        author: "이영화",
        date: "2025-01-06",
        views: 980
    },
    {
        id: 3,
        badge: "pending",
        badgeText: "대기중",
        question: "앱 버전은 언제 나오나요?",
        author: "최모바일",
        date: "2025-01-04",
        views: 1523
    }
];

// 리뷰 미리보기 렌더링
function renderReviewPreview() {
    const container = document.getElementById('reviewList');
    if (!container) return;

    container.innerHTML = '';
    reviewData.forEach(review => {
        const item = createReviewItem(review);
        container.appendChild(item);
    });
}

// 리뷰 아이템 생성
function createReviewItem(review) {
    const item = document.createElement('div');
    item.className = 'review-item';

    // 별점 생성
    let starsHTML = '';
    for (let i = 1; i <= 5; i++) {
        if (i <= review.rating) {
            starsHTML += '★';
        } else {
            starsHTML += '☆';
        }
    }

    item.innerHTML = `
        <div class="review-item-avatar">${review.userAvatar}</div>
        <div class="review-item-content">
            <div class="review-item-header">
                <span class="review-item-user">${review.userName}</span>
                <span class="review-item-movie">${review.movieTitle}</span>
            </div>
            <p class="review-item-text">${review.content}</p>
            <div class="review-item-meta">
                <span class="review-item-stars">${starsHTML}</span>
                <span>👍 ${review.likes}</span>
                <span>💬 ${review.comments}</span>
            </div>
        </div>
    `;

    item.addEventListener('click', () => {
        window.location.href = 'reviewPage.html';
    });

    return item;
}

// QnA 미리보기 렌더링
function renderQnAPreview() {
    const container = document.getElementById('qnaList');
    if (!container) return;

    container.innerHTML = '';
    qnaData.forEach(qna => {
        const item = createQnAItem(qna);
        container.appendChild(item);
    });
}

// QnA 아이템 생성
function createQnAItem(qna) {
    const item = document.createElement('div');
    item.className = 'qna-item';

    item.innerHTML = `
        <span class="qna-item-badge ${qna.badge}">${qna.badgeText}</span>
        <p class="qna-item-question">${qna.question}</p>
        <div class="qna-item-meta">
            <span>👤 ${qna.author}</span>
            <span>📅 ${qna.date}</span>
            <span>👁️ ${qna.views}</span>
        </div>
    `;

    item.addEventListener('click', () => {
        window.location.href = 'qnaPage.html';
    });

    return item;
}
