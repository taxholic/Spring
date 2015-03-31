<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<script type="text/javascript" src="/extjs/adapter/ext/ext-base.js"></script>
<script type="text/javascript" src="/extjs/ext-all.js"></script>
<link rel="stylesheet" type="text/css" href="/extjs/resources/css/ext-all.css"/>	

<script>

var store = null; 													//data store
var grid = null; 													//grid
var fields = null;
var storeUrl = "./newsJson.do";						//검색페이지 URL
					

Ext.onReady(function(){

    // Data Store 설정
	
	store = new Ext.data.Store({
		proxy: new Ext.data.HttpProxy({
			url: storeUrl +  "?" + $("#frm").serialize(),
   	     	method: 'POST'
		}),

		reader: new Ext.data.JsonReader(
			{ root: 'dataList'  },
			fields = Ext.data.Record.create([
				'seqNo','itemGroup','itemNm','newsNm','newsLink',{name: 'stp', type: 'int'},'flag','charset','useYn','editCd'
			])
		)
	});
     

    // Grid 패널/컬럼 정의
	var sm = new Ext.grid.CheckboxSelectionModel( { id: "seqNo", width:30 } );		//체그박스
	var fm = Ext.form;
	grid = new Ext.grid.EditorGridPanel({
        el:'GridDataList',
		height:500,
        width:970,
        title:'RSS 뉴스목록',
        store: store,
        loadMask: {msg:'로딩 ...'},
        stripeRows: true,							//로우구분 컬로 표시
		
		sm: sm,
		columns: [
			sm,
            {header: "구분", width: 50, align: 'center', sortable: true, dataIndex: 'flag', renderer : renderType },
            {header: "그룹명", width: 80, align: 'center', sortable: true, dataIndex: 'itemGroup',editor: new fm.TextField({allowBlank: false}) },
            {header: "아이템명", width: 80, align: 'center', sortable: true, dataIndex: 'itemNm'},
            {header: "뉴스명", width: 150, sortable: true, dataIndex: 'newsNm',editor: new fm.TextField({allowBlank: false}) },
            {header: "뉴스링크", width: 320, sortable: true, dataIndex: 'newsLink',editor: new fm.TextField({allowBlank: false}) },
            {header: "인코딩", width: 80, align: 'center', sortable: true, dataIndex: 'charset',editor: new fm.TextField({allowBlank: false}) },
            {header: "사용여부", width: 80, align: 'center', sortable: true, dataIndex: 'useYn',editor: new fm.TextField({allowBlank: false}) },
            {header: "순서", width: 70, align: 'center', sortable: true, dataIndex: 'stp', editor: new fm.NumberField( { allowBlank : false, allowNegative : false }) }
        ],

    }); 

	grid.addListener("rowmousedown", function() { return false; } );
	
    // render it
    grid.render();

 	// trigger the data store load
	store.load();
	
	//------------------------------------------------------  사용자 함수
	 function renderType(value,p,record){
		var type = "";
		
		if(record.data.flag == "stock"){
			type = "증권";
		}else if(record.data.flag == "economy"){
			type = "경제";
		}else if(record.data.flag == "society"){
			type = "사회";
		}else if(record.data.flag == "culture"){
			type = "문화";
		}else if(record.data.flag == "nation"){
			type = "국제";
		}else if(record.data.flag == "sports"){
			type = "스포츠";
		}else if(record.data.flag == "entertain"){
			type = "연예";
		}
	    return type;
    }
	

});

//-------------------------------------------  매매코드 수정
function saveCode(){
	
	zpop.confirm("저장하겠습니까.",function(){
		modifyRecordProc();
	});
	
}
function modifyRecordProc(){

	var params = {
		lstSeqNo : [],
		lstItemGroup : [],
		lstNewsNm : [],
		lstNewsLink : [],
		lstCharset : [],
		lstUseYn : [],
		lstStp : [],
		lstEditCd : [],
		flag :  $("#flag").val()
	};

	var modifyRecords = store.getModifiedRecords();	//수정된 레코드 모두 찾기
	var len = modifyRecords.length;

	if(len > 0){
		for(var i = 0; i < len ; i++){
			params.lstSeqNo.push( modifyRecords[i].get('seqNo') );
			params.lstItemGroup.push( modifyRecords[i].get('itemGroup') );
			params.lstNewsNm.push( modifyRecords[i].get('newsNm') );
			params.lstNewsLink.push( modifyRecords[i].get('newsLink') );
			params.lstCharset.push( modifyRecords[i].get('charset') );
			params.lstUseYn.push( modifyRecords[i].get('useYn') );
			params.lstStp.push( modifyRecords[i].get('stp') );
			params.lstEditCd.push( modifyRecords[i].get('editCd') );
		}

		$.ajax({
			url: 'newsInsert.do',
			type: 'POST',
			data: jQuery.param(params,true),
			timeout : 3000,
			error: function(){
				zpop.alert("저장에 실패하였습니다.");
			},
			success: function(msg){
				search();
			}
		});

		store.commitChanges();					//isDirty Flag 없애기
	
	}else{
		zpop.alert("변경된 자료가 없습니다.");
	}
}

//----------------------------------------------- 뉴스 등록
function addCode(){

	if(!$("#flag").val()){
		zpop.alert("분류을 선택해주세요");
		
		return;
	}

	var r = new fields( {
			itemGroup : 'sort1',
			//itemNm : 'item0',
			newsNm : '새뉴스명',
			newsLink : 'http://',
			charset : 'euc-kr',
			useYn : 'Y',
			stp : 999,
			editCd : 'I',					// 등록 상태
		});
		grid.stopEditing();
		store.insert(0, r);
		grid.startEditing(0, 0);		// 등록할 rowIndex, colIndex 위치
}

//------------------------------------------------ 뉴스 삭제
function deleteCode() {
	
	if(grid.getSelectionModel().getSelections().length == 0) return;
	
	zpop.confirm("삭제하겠습니까",function(){
		deleteRecordProc();
	});

}
function deleteRecordProc(){

	var params ={lstSeqNo: []};

	var chk = grid.getSelectionModel().getSelections();
	 for( var i = 0; i < chk.length; i++) {
		params.lstSeqNo.push( chk[i].data.seqNo);   
	} 
 	
	if(chk.length > 0){
		$.ajax({
			url: 'newsDelete.do',
			type : 'POST',
			data : jQuery.param(params,true),
			timeout : 3000,

			error: function(){
				zpop.alert("삭제에 실패하였습니다.");
			},
			success: function(msg){
				search();
			}
		});

	}else{
		zpop.alert("대상을 선택해주세요.");
	}
}


function search(){
	store.proxy.conn.url = storeUrl + "?" + $("#frm").serialize();
	store.load();
}

</script>
	
<div id="wrapper">
	
	<div class="title">코드관리 > 뉴스관리</div>
	
	<!-- 매매코드 -->
	<div class="searchBox" style="width:958px;">
			<form name="frm" id="frm" onSubmit="search();return false">
			<select name="flag" id="flag" onChange="search()" style="width:70px">
				<option value="">분류</option>
				<option value="stock">증권</option>
				<option value="economy">경제</option>
				<option value="society">사회</option>
				<option value="culture">문화</option>
				<option value="nation">국제</option>
				<option value="entertain">연예</option>
				<option value="sports">스포츠</option>
			</select>
			
			<input type="text" name="newsNm" class="inputBox" style="ime-mode:active">
			<button class="word2">검색</button>
			</form>
	</div>
	
	<div style="float:left">
		
		<div id="GridDataList"></div>	

		<div style="margin-top:10px;">
			<div style="float:left">
			<button class="word2" onClick="deleteCode()">삭제</button>
			</div>

			<div style="float:right">
			<button class="word2" onClick="addCode()">등록</button>
			<button class="word2" onClick="saveCode()">저장</button>
			</div>
		</div>
	</div>


	
</div>

