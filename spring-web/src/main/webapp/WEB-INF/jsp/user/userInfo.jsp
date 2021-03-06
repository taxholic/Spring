<%@ page contentType="text/html; charset=UTF-8" %>
<html>
<head>

<script type="text/javascript" src="/js/join.js"></script>
<script type="text/javascript" src="/js/sortable/jquery.cookies.js"></script>
<link rel="stylesheet" href="/css/user.css" type="text/css">
	
<script>
function sendForm(){
	var frm = document.regForm;
	
	var email = frm.email1.value + "@"  + frm.email2.value;
	
	if( isValidEmail(email) == false ){	
		modalAlert("메일 형식이 올바르지 않습니다.",function(){
			frm.email1.focus();
		});
		return;
	}
	
	frm.email.value = email;
	
	jQuery.ajax({
		url: './userInfoModify.do',
		type: 'POST',
		data: $("#regForm").serialize(),
		timeout : 3000,
		error: function(){
			modalAlert("수정에 실패하였습니다.");
		},
		success: function(msg){
			var result = eval('(' + msg + ')'); 
			if( result.reg == "success"){
				modalAlert("정보가 수정되었습니다.")	
			}
		}
	});
	
}

$(document).ready(function() {
	var email = "$!info.email".split("@");
	$("#email1").val(email[0]);
	$("#email2").val(email[1]);
	
	$("#email3 > option[value=" + email[1] + "]").attr("selected", "true");
});
</script>

</head>



<body>
	
<div id="headerInfo" style="display:none">
   <span class="headerNav"> 》 Member Info 》 회원정보</span>
</div>


<div class="contents-box">
	<div class="leftBar">&nbsp;</div>
	<div class="leftMenu">
    	<ul>
		<li><a href="#" style="background:#EBF4FC">ㆍ회원정보</a></li>
		<li><a href="./userPw.do">ㆍ비밀번호변경</a></li>
		<li><a href="./userOut.do">ㆍ회원탈퇴</a></li>
		</ul>
	</div>

	<div class="contents">
    
		 <table border="0" cellspacing="0" cellpadding="0">
    <tr><td colspan="2" height="50" class="joinTitle"><img src="/images/icon/icon_10.png" align="absbottom"> 회원정보</td></tr>	
    <tr><td height="2" colspan="2" bgcolor="#5980D6"></td></tr>
    
    <form name="regForm" id="regForm" method="post" action="joinProc.do" onSubmit="return false">
    <tr height="50">
    	<td width="100" class="joinEle">아이디</td>
    	<td width="500">$!info.userId</td>
    </tr>
    <tr><td colspan="2" height="1" bgcolor="EEEEEE"></td></tr>
    
    
    <tr height="50">
    	<td width="100" class="joinEle">닉네임</td>
    	<td width="500">$!info.userNm</td>
    </tr>
    <tr><td colspan="2" height="1" bgcolor="EEEEEE"></td></tr>
    
    
    <tr height="60">
    	<td width="100" class="joinEle">이메일</td>
    	<td width="500">
    		<div style="float:left;margin-right:5px">
    			<input type=text name="email1" id="email1" style="width:100px;ime-mode:inactive" class="inputBox">@<input type=text name="email2" id="email2" style="width:100px" class="inputBox">
    		</div>
    		<div>		
    		<select name="email3" id="email3" onChange="setEmail(this.options[this.selectedIndex].value)">
        		<option value="">이메일선택</option>
        		<option value="gmail.com">gmail.com</option>
        		<option value="naver.com">naver.com</option>
        		<option value="yahoo.co.kr">yahoo.co.kr</option>
        		<option value="nate.com">nate.com</option>
        		<option value="hotmail.com">hotmail.com</option>
        		<option value="empal.com">empal.com</option>
        		<option value="hanmail.net">hanmail.net</option>
        		<option value="dreamwiz.com">dreamwiz.com</option>
        		<option value="freechal.com">freechal.com</option>
        		<option value="netian.com">netian.com</option>
        		<option value="lycos.co.kr">lycos.co.kr</option>
        		<option value="korea.com">korea.com</option>
        		<option value="chollian.net">chollian.net</option>
        		<option value="intizen.com">intizen.com</option>
        		<option value="chollian.net">chollian.net</option>
        		<option value="hanafos.com">hanafos.com</option>
        		<option value="kebi.com">kebi.com</option>
        		<option value="korea.com">korea.com</option>
        		<option value="netsgo.com">netsgo.com</option>
        		<option value="sayclub.com">sayclub.com</option>
    		</select>
            </div>
    		
    	</td>
    </tr>
    <tr><td colspan="2" height="1" bgcolor="EEEEEE"></td></tr>
    
    <tr height="50">
    	<td width="100" class="joinEle">이메일수신여부</td>
    	<td width="500">
    		<input type="radio" name="receive" id="receive" value="Y" #if($!info.receive == 'Y')checked#end>수신 &nbsp;
    		<input type="radio" name="receive" id="receive" value="N" #if($!info.receive == 'N')checked#end>비수신
    	</td>
    </tr>
    <tr><td colspan="2" height="1" bgcolor="EEEEEE"></td></tr>
    
    <tr>
    	<td colspan="2" height="50" align="center">
           <button class="word2" onClick="sendForm()" onFocus="blur()">수정</button>
    	</td>
    </tr>
    
    <input type="hidden" name="email">
    	
    </form>
     <tr><td colspan="2" height="180"></td></tr>
	 </table>
		
	</div>

	<div class="clear"></div>
</div>


	
</body>
</html>