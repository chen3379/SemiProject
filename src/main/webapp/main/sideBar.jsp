<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<style>
    .sidebar-wrapper {
        position: fixed; /* Grid 안에서 고정 */
        top: var(--nav-height);
        left: 0;
        width: var(--sidebar-width);
        height: calc(100vh - var(--nav-height));
        background-color: var(--bg-main);
        border-right: 1px solid var(--border-glass);
        padding: 30px 20px;
        overflow-y: auto;
    }

    .sidebar-menu-title {
        font-size: 0.75rem;
        color: var(--text-muted);
        font-weight: 700;
        text-transform: uppercase;
        margin-bottom: 15px;
        padding-left: 10px;
        letter-spacing: 1px;
    }

    .sidebar-list {
        display: flex;
        flex-direction: column;
        gap: 5px;
        margin-bottom: 30px;
    }

    .sidebar-item {
        display: flex;
        align-items: center;
        padding: 12px 15px;
        color: var(--text-gray);
        border-radius: 8px;
        font-size: 0.95rem;
        transition: all 0.2s var(--ease-smooth);
    }

    .sidebar-item i {
        margin-right: 12px;
        font-size: 1.1rem;
        color: #666;
        transition: color 0.2s;
    }

    .sidebar-item:hover {
        background-color: rgba(255, 255, 255, 0.05);
        color: var(--text-white);
    }

    .sidebar-item:hover i {
        color: var(--primary-red);
    }

    .sidebar-item.active {
        background-color: rgba(229, 9, 20, 0.1);
        color: var(--primary-red);
        font-weight: 600;
    }
    
    .sidebar-item.active i {
        color: var(--primary-red);
    }
</style>

<div class="sidebar-wrapper">
    <div class="sidebar-menu-title">Discover</div>
    <ul class="sidebar-list">
        <li><a href="#" class="sidebar-item active"><i class="bi bi-compass"></i> 홈</a></li>
        <li><a href="#" class="sidebar-item"><i class="bi bi-fire"></i> 인기 콘텐츠</a></li>
        <li><a href="#" class="sidebar-item"><i class="bi bi-collection-play"></i> 장르별</a></li>
    </ul>

    <div class="sidebar-menu-title">Library</div>
    <ul class="sidebar-list">
        <li><a href="#" class="sidebar-item"><i class="bi bi-bookmark-heart"></i> 찜한 콘텐츠</a></li>
        <li><a href="#" class="sidebar-item"><i class="bi bi-clock-history"></i> 시청 기록</a></li>
    </ul>
</div>