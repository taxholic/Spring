<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<script type='text/javascript' src='/dwr/interface/httpFetch.js'></script>
<script type='text/javascript' src='/dwr/interface/httpStockSync.js'></script>
<script type='text/javascript' src='/dwr/engine.js'></script>

<link rel="stylesheet" href="/css/batch.css" type="text/css">


<script>

//------------------------------------------------------------- stockPrice Sync
function getStockPriceSync(){
	httpStockSync.fetchStockPrice();
}
function setStockPriceSyncMsg() {
	$("#stockSyncBtn").attr("disabled","true");
	$("#stockPriceSync").find("p").remove();
	$("#stockPriceSync").append("<p><img src='/images/common/loading.gif' border='0'></p><p style='margin-top:10px'>동기화중 ...</p>");
}
function stockPriceSyncFinsh(msg){
	$("#stockSyncBtn").attr("disabled","");
	$("#stockPriceSync").find("p").remove();
	$("#stockPriceSync").append("<p style='margin-top:5px'>" + msg + "</p>");
}

//------------------------------------------------------------- stockPrice Update
function getStockPriceUpdate(){
	httpFetch.quartzStockPrice();
}
function setStockPriceUpdateMsg() {
	$("#stockUpdateBtn").attr("disabled","true");
	$("#stockPriceBatch").find("p").remove();
	$("#stockPriceBatch").append("<p><img src='/images/common/loading.gif' border='0'></p><p style='margin-top:10px'>업데이트중 ...</p>");
}
function stockPriceUpdateFinsh(msg){
	$("#stockUpdateBtn").attr("disabled","");
	$("#stockPriceBatch").find("p").remove();
	$("#stockPriceBatch").append("<p style='margin-top:5px'>" + msg + "</p>");
}

//------------------------------------------------------------- chart
function getChart(){
	httpFetch.quartzStockChart();
}
function setChartMsg(msg) {
	$("#chartBtn").attr("disabled","true");
	$("#chartBatch").append("<p>" + msg + "</p>");
	$("#chartBatch").prop("scrollTop",$("#chartBatch").prop("scrollHeight"))
}
function chartFetchFinsh(msg){
	if(msg == 'finished'){
		$("#chartBtn").attr("disabled","");
	}
}

//------------------------------------------------------------- news
function getNews(){
	httpFetch.quartzNewsRss();
}
function setRssNewsMsg(msg) {
	$("#newstBtn").attr("disabled","true");
	$("#newsBatch").append("<p>" + msg + "</p>");
	$("#newsBatch").prop("scrollTop",$("#newsBatch").prop("scrollHeight"));
	
}
function newsFetchFinsh(msg){
	if(msg == 'finished'){
		$("#newstBtn").attr("disabled","");
	}
}

//------------------------------------------------------------- Sever Info
var barCnt = 20;
function setServerInfo(msg) {

	var data = eval('(' + msg + ')') ;
	if(data == null) return;

	$("#appMem .lineWraper").find("DIV").remove();
	
	var appRate = Math.round( (data.appRate/10) * (barCnt/10) );
	$("#appMem .appRate .digit").text( data.appRate );
	$("#appMax").text( data.appMax );
	$("#appUsed").text( data.appUsed );
	$("#appAvail").text( data.appAvail );
	for(i = barCnt ; i >= 1; i--){
		if(i > appRate){
			$("#appMem .lineWraper").append("<div class='lineBase'></div>");
		}else{
			$("#appMem .lineWraper").append("<div class='lineActive'></div>");
		}
	}

}

//------------------------------------------------------------- Company info
function getCompanyInfo(){
	httpStockSync.fetchCompanyInfo();
}
function setCompanyInfoMsg(msg) {
	$("#comBtn").attr("disabled","true");
	$("#comFetch").append("<p>" + msg + "</p>");
	$("#comFetch").prop("scrollTop",$("#comFetch").prop("scrollHeight"))
}
function companyInfoFinsh(msg){
	if(msg == 'finished'){
		$("#comBtn").attr("disabled","");
	}
}


jQuery(document).ready(function () {
	dwr.engine.setActiveReverseAjax(true);

	for(i = barCnt ; i >= 1; i--){
		$("#appMem .lineWraper").append("<div class='lineBase'></div>");
	}
});


</script>

<div id="wrapper">
	

    	<table cellspacing="10" cellpadding="0" border="0">
		<tr>
            <td width="450" rowspan="2">
				
			<table cellspacing="5" cellpadding="0" border="0">
			<tr>
				<td width="130" align="center">메모리(MB)</td>
			</tr>
            <tr>
				<td style="padding:2px;border:1px solid #2B6AB9;text-align:center">
					<div id="appMem">
        				 <div class="memTitle">100%</div>
        				 <div class="lineWraper"></div>
                         <div class="appRate">
                        	<div class='digit'>0</div>
                        	<div class="per">%</div>
                         </div>
        			</div>
					<div id="appMemStatus">
    					<p>최대 : <span id="appMax" style="font-size:8pt"></span></p> 
    					<p>사용 : <span id="appUsed" style="font-size:8pt"></span></p> 
    					<p>여유 : <span id="appAvail" style="font-size:8pt"></span></p>
    				</div>
				</td>
			</tr>
            </table>
				
			</td>
            <td  width="550" align="right">
				<div id="stockSyncDiv"><button id="stockSyncBtn" class="word7" onClick="getStockPriceSync()">현재가 동기화</button></div>
				<div id="stockUpdateDiv"><button id="stockUpdateBtn" class="word8" onClick="getStockPriceUpdate()">현재가 업데이트</button></div>
			</td>
        </tr>
		<tr>
            <td>
				<div id="stockPriceSync"></div>
				<div id="stockPriceBatch"></div>
			</td>
        </tr>
    	<tr>
            <td align="right"><button id="chartBtn" class="word7" onClick="getChart()">차트 가져오기</button></td>
            <td align="right"><button id="newstBtn" class="word7" onClick="getNews()">뉴스 가져오기</button></td>
        </tr>
    	<tr>
            <td class="batchBox"><div id="chartBatch"></div></td>
            <td class="batchBox"><div id="newsBatch"></div></td>
        </tr>
		<tr><td colspan="2" height="10"></td></tr>
		
		<tr>
            <td align="right"><button id="comBtn" class="word9" onClick="getCompanyInfo()">기업정보 가져오기</button></td>
            <td align="right">&nbsp;</td>
        </tr>
    	<tr>
            <td class="batchBox"><div id="comFetch"></div></td>
            <td>&nbsp;</td>
        </tr>
		
		
    	
        </table>
    		
</div>

	

