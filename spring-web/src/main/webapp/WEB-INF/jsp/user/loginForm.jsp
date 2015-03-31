<%@ page contentType="text/html; charset=UTF-8" %>

<script type="text/javascript">
function keyDown(){ 
	var keyValue = event.keyCode;
	
	if (keyValue == 13){
		if(trim($("#userNm").val()) && !trim($("#passwd").val())){
			$("#passwd").focus();
			return;
		}
		
    	if(trim($("#userNm").val()) && trim($("#passwd").val())){
    		login();
    	}

	}
}


function login(){
	if(!trim($("#userNm").val())){
		$("#notice").html("<font color='#FF6633'>아이디를 입력해주세요</font>")
		$("#userNm").focus();
		return ;
	}
	if(!trim($("#passwd").val())){
	$("#notice").html("<font color='#FF6633'>패스워드를 입력해주세요</font>")
		$("#passwd").focus();
		return ;
	}
	
	$.ajax({    
    	url: "/login",    
    	type: "POST",    
    	data: $("#frm").serialize(),    
    	beforeSend: function (xhr) {        
    		xhr.setRequestHeader("X-Ajax-call", "true");    
    	},    
		error: function (e) {        
    		alert("시스템 에러")
    	},    
    	success: function(result) {  
    		if (result == "OK") {
			
				//rember id
				if( $("#saveId").prop("checked") == true ){
					$.cookie("remberId", $("#userNm").val(), { path: '/', expires: 90 });
				}else if(  $.cookie("remberId") != null ){
					$.cookie("remberId", null, { path: '/', expires: 0 });
				}
				
				if('${redirect}' != ''){
					location.href = "${redirect}";
					return;
				}
			
				var referrer = document.referrer ;

				if(referrer != '' &&  referrer.indexOf("main.do") == -1 ) {
					location.href = referrer;
				}else if(referrer.indexOf("main.do") != -1){
					top.location.href = "/main.do";
				}else{
					top.location.href = "/main.do";
				}

    		} else {
    			$("#notice").html("<font color='#FF6633'>아이디와 패스워드를 확인해 주십시요.</font>")
				$("#userNm").val("");
				$("#passwd").val("");
				$("#userNm").focus();
    		}    
    	}
    });
	
	//document.frm.submit();
}


$(document).ready(function () {

	var cookId = $.cookie("remberId");
	
	if( cookId != null ){
		$("#saveId").prop("checked","true");
		$("#userNm").val(cookId)
		$("#passwd").focus();
	}else{
		$("#userNm").focus();
	}
	
	//login();
});

</script>

<style type="text/css"> 

#login { 
    width: 400px; /* 폭이나 높이가 일정해야 합니다. */ 
    height: 200px; /* 폭이나 높이가 일정해야 합니다. */ 
    position: absolute; 
    top: 40%; /* 화면의 중앙에 위치 */ 
    left: 50%; /* 화면의 중앙에 위치 */ 
    margin: -100px 0 0 -200px; /* 높이의 절반과 너비의 절반 만큼 margin 을 이용하여 조절 해 줍니다. */ 
} 
</style> 


<div id="login">
    <table  border="0" cellspacing="0" cellpadding="0" align="center">
    <tr>
    	<td width=36 height=40><a href="/"><img src='/images/login/login_01.gif'></a>
    	<td width=230 height=40 style='padding:10 0 0 10' id="notice">
    	
    	</td>
    </tr>
    <tr>
    	<td height='4' bgcolor='#5980D6'></td>
    	<td height='4' bgcolor='#AFAFAF'></td>
    </tr>
    
    <tr>
    	<td height='150' colspan='2'>
    
    	<form name="frm" id="frm" method="post" action="/login" onSubmit="return fase">
    	<table  border="0" cellspacing="0" cellpadding="0" align='center'>
		<tr><td height='20' colspan='4'></td></tr>
    	<tr height='25'>
    		<td width='70'>
    			<img src='/images/icon/icon_02.gif' align=absmiddle> 
    			<font color='#6E6E6E'><b>아이디</b></font>
    		</td>
    		<td width='5'></td>
    		<td width='150'><input type="text" name="userNm" id="userNm" tabindex="1"  class="inputBox" onkeyDown="keyDown();"></td>
    		<td width='40' rowspan='2'>
    			<a href='javascript:login()'  tabindex="3"><img src='/images/board/momo_send.gif' border=0 align=absmiddle></a>
    		</td>
    	</tr>
    	<tr height='25'>
    		<td width='70'>
    			<img src='/images/icon/icon_02.gif' align=absmiddle>
    			<font color='#6E6E6E'><b>패스워드</b></font>
    		</td>
    		<td width='5'></td>
    		<td width='150'><input type="password" name="passwd" id="passwd" value="" tabindex="2" class="inputBox" onkeyDown="keyDown();"></td>
    	</tr>

    	<tr height='80'>
    		<td colspan='4'>
    			<!--  
				<p style="text-align:right;margin-bottom:10px"><input type="checkbox" id="saveId"> 아이디저장</p>
				-->
    		<p style="text-align:right;margin-bottom:10px">
                <label>로그인 유지</label>
                <input id="remember-me" name="remember-me" type="checkbox" />
            </p>
				
				
				<p style="text-align:center">
    			<a href="/user/join.do"><img src="/images/login/login_03.gif"></a>&nbsp;&nbsp;
    			<a href="#"><img src="/images/login/login_04.gif"></a>
				</p>
    		</td>
    	</tr>
    	</table>
    
    	
    	</form>
    
    	</td>
    </tr>
    <tr><td height=2 colspan=2 bgcolor=#D0D0D0></td></tr>
    </table>
	
</div>


