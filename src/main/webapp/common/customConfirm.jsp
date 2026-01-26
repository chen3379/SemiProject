<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<style>
:root {
  --confirm-bg: #181818;
  --confirm-red: #E50914;
  --confirm-red-hover: #ff1f2a;
  --confirm-text: #fff;
  --confirm-shadow-red: rgba(229, 9, 20, 0.5);
  --confirm-ease: cubic-bezier(0.25, 0.8, 0.25, 1);
}

/* overlay */
#custom-confirm-overlay{
  display:none;
  position:fixed;
  inset:0;
  background:rgba(0,0,0,.85);
  backdrop-filter:blur(8px);
  z-index:99999;
  justify-content:center;
  align-items:flex-start;
  padding-top:100px;
  opacity:0;
  transition:opacity .4s var(--confirm-ease);
}

/* active */
#custom-confirm-overlay.active{
  display:flex;
  opacity:1;
}

/* box */
.custom-confirm-box{
  width:420px;
  max-width:92%;
  background:linear-gradient(180deg,#1f1f1f 0%,var(--confirm-bg) 100%);
  border-radius:16px;
  box-shadow:
    0 -1px 0 rgba(255,255,255,.1) inset,
    0 20px 60px rgba(0,0,0,.9);
  transform:translateY(10px) scale(.95);
  transition:transform .4s var(--confirm-ease);
  text-align:center;
  overflow:hidden;
}

#custom-confirm-overlay.active .custom-confirm-box{
  transform:translateY(0) scale(1);
}

/* header */
.confirm-header{
  padding:20px 0 15px;
}
.confirm-header h2{
  color:var(--confirm-red);
  font-size:1.6rem;
  font-weight:900;
  letter-spacing:2px;
  text-transform:uppercase;
  text-shadow:0 0 20px var(--confirm-shadow-red);
  margin:0;
}

/* body */
.confirm-body{
  padding:0 40px 30px;
  color:var(--confirm-text);
  font-size:.95rem;
  line-height:1.7;
  opacity:.9;
  word-break:keep-all;
}

/* footer */
.confirm-footer{
  display:flex;
  gap:12px;
  justify-content:center;
  padding-bottom:26px;
}

/* buttons */
.confirm-footer button{
  min-width:90px;
  padding:8px 0;
  border:none;
  border-radius:8px;
  font-size:.95rem;
  font-weight:700;
  cursor:pointer;
  transition:.3s var(--confirm-ease);
}

/* cancel */
.btn-confirm-cancel{
  background:#444;
  color:#fff;
}
.btn-confirm-cancel:hover{
  background:#555;
}

/* ok */
.btn-confirm-ok{
  background:linear-gradient(180deg,var(--confirm-red) 0%,#B20710 100%);
  color:#fff;
  box-shadow:0 4px 15px rgba(0,0,0,.3);
}
.btn-confirm-ok:hover{
  background:linear-gradient(180deg,var(--confirm-red-hover) 0%,var(--confirm-red) 100%);
  box-shadow:0 8px 25px var(--confirm-shadow-red);
  transform:translateY(-2px);
}
.btn-confirm-ok:active{
  transform:translateY(1px);
}
</style>

<div id="custom-confirm-overlay">
  <div class="custom-confirm-box">
    <div class="confirm-header">
      <h2>WHATFLIX</h2>
    </div>
    <div class="confirm-body" id="custom-confirm-msg"></div>
    <div class="confirm-footer">
      <button class="btn-confirm-cancel">취소</button>
      <button class="btn-confirm-ok">확인</button>
    </div>
  </div>
</div>

<script>
var confirmCallback = null;

function openCustomConfirm(msg, callback){
  confirmCallback = (typeof callback === "function") ? callback : null;

  if(msg) msg = msg.replace(/\n/g,"<br>");
  document.getElementById("custom-confirm-msg").innerHTML = msg;

  document.getElementById("custom-confirm-overlay").classList.add("active");
  setTimeout(function(){
    var okBtn = document.querySelector("#custom-confirm-overlay .btn-confirm-ok");
    if(okBtn) okBtn.focus();
  }, 100);
}

function closeCustomConfirm(isOk){
  document.getElementById("custom-confirm-overlay").classList.remove("active");

  // 핵심: confirmed(boolean) 전달
  if(confirmCallback){
    confirmCallback(!!isOk);
  }
  confirmCallback = null;
}

/* 바인딩을 안전하게(중복 include/로드순서 문제 방지) */
document.addEventListener("click", function(e){
  var overlay = document.getElementById("custom-confirm-overlay");
  if(!overlay) return;

  if(e.target.closest("#custom-confirm-overlay .btn-confirm-ok")){
    closeCustomConfirm(true);
  }
  if(e.target.closest("#custom-confirm-overlay .btn-confirm-cancel")){
    closeCustomConfirm(false);
  }
});

// 키보드
document.addEventListener("keydown", function(e){
  var o = document.getElementById("custom-confirm-overlay");
  if(!o || !o.classList.contains("active")) return;

  if(e.key === "Enter") closeCustomConfirm(true);
  if(e.key === "Escape") closeCustomConfirm(false);
});
</script>