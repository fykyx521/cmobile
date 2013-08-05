var IFun = {
	//var uniqueID="";
    uniqueID:"",
    WinBox: function(id, title, width, height, url, html, elId) {//弹出窗
        //debugger;
        
         //swfobject.getObjectById("flashContent").;
         //alert("WinBox");
    },
    WinBoxData: function(id, param, width, height, elId) {//弹出窗加载
        swfobject.getObjectById("PreLoader").winBoxData(id,param,width,height,uniqueID);
    },
    LoadMapData: function(id, param) {//加载地图数据
        alert("LoadMapData");
    },
    LoadDataById: function(contentStr, winId, param) { //跨窗口加载数据
        alert("LoadDataById");
    },
    Tips: function(o, content, size, c) { //tips窗体
        alert("Tips");
    },
    setUUID:function(uuid){
    	uniqueID=uuid;
    },
    getUUID:function(){
    	return uniqueID;
    }
   
}