package com.careland {
    import br.com.stimuli.loading.*;
    
    import com.careland.component.*;
    import com.careland.event.*;
    import com.careland.util.CLDConfig;
    
    import flash.display.*;
    import flash.events.*;
    import flash.external.*;
    import flash.net.*;
    import flash.system.*;
    import flash.utils.*;

    public class YDConfig extends EventDispatcher {

        private static var _instance:YDConfig;
      //  private static var jsCode:Class = YDConfig_jsCode;

        private var bulkLoader:BulkLoader;
        public var config:XML;
        public var uiConfig:XML;
        public var ajaxURL:String;
        private var urlloader:URLLoader;
        public var fontLoaded:Boolean = false;
		public var mapConfigLoaded:Boolean = false;
		
        public var proceduces:XMLList;
        public var userID:int = 9;
        public var cssFolder:String = "";
        public var contenturl:String = "http://10.245.101.68/dyhNew/DataServer/AjaxPreView.aspx";
        public var produceurl:String = "http://10.245.101.68/dyhNew/DataServer/AjaxForFlashTouch.aspx";
        public var baseurl:String = "http://10.245.101.68/dyhNew/";
        public var produceweburl:String = "http://10.245.101.68/dyhNew/DataServer/AjaxForWap.aspx";
        private var registerIFrame:Array;
        private var openMenuIDs:Dictionary;
        private var forderLoader:URLLoader;
		
		public var configURL:String="assets/config.xml";
		
		public var maptypeData:Object={};//地图切换工具用到的
		public var webConfig:Boolean=true;
        public function YDConfig(){
            registerIFrame = [];
            openMenuIDs = new Dictionary();
            super();
            if (this != _instance){
                _instance = this;
            };
        }
        public static function instance():YDConfig{
            if (!(_instance)){
                _instance = new (YDConfig)();
            };
            return (_instance);
        }

        public function register(uuid:String, cld:Object):void{
            registerIFrame.push({
                uuid:uuid,
                comp:cld
            });
        }
        public function openFlowLength():String{
            return (String(this.config.openFlowLength));
        }
        public function clear(uuid:String):Object{
            var obj:Object;
            var i:int;
            while (i < this.registerIFrame.length) {
                if (registerIFrame[i].uuid == uuid){
                    obj = registerIFrame[i];
                    registerIFrame.slice(i, 1);
                };
                i++;
            };
            return (obj);
        }
        public function disposeXML(xml:XML):void{
            System.disposeXML(xml);
        }
        public function getIframeByID(uuid:String):Object{
            var obj:Object;
            var i:int;
            while (i < this.registerIFrame.length) {
                if (registerIFrame[i].uuid == uuid){
                    obj = registerIFrame[i];
                };
                i++;
            };
            return (obj);
        }
        public function loadConfig(url:String="",logfun:Function=null):void{
			if(url!="")
			{
				configURL=url;
			}
            bulkLoader = BulkLoader.getLoader("main");
            if (!(bulkLoader)){
                bulkLoader = new BulkLoader("main");
            };
			if(logfun!=null)
			{
				bulkLoader.logFunction=logfun;
			}
            bulkLoader.add(configURL, {id:"config"});
            bulkLoader.addEventListener(BulkProgressEvent.PROGRESS, progress);
            bulkLoader.addEventListener(BulkProgressEvent.COMPLETE, complete);
            bulkLoader.start();
        }
        public function loadFont(url:String):void{
            bulkLoader.remove("config");
            bulkLoader.add(url, {id:"font"});
            bulkLoader.start();
        }
        public function initFoler():void{
			
            var pstr:String = encodeURI(this.getProcedure("skin"));
			if(""==pstr||"null"==pstr)
			{
				pstr=encodeURI("P_FT_获取默认皮肤信息");
			}
            var purl:String = ((((produceurl + "?SpName=") + pstr) + "&") + Math.random());
            var postRequest:URLRequest = new URLRequest(purl);
            postRequest.method = "post";
            forderLoader = new URLLoader();
            forderLoader.addEventListener(IOErrorEvent.IO_ERROR, ioError);
            forderLoader.addEventListener(Event.COMPLETE, loadForderComplete);
            forderLoader.load(postRequest);
        }
        private function loadForderComplete(e:Event):void{
            forderLoader.removeEventListener(Event.COMPLETE, loadForderComplete);
            var data:XML = XML(e.target.data);
			//  this.cssFolder = "../2012113191345"; 
		    
			
			this.cssFolder = data.data[0].@folderName;
			this.cssFolder=this.baseurl+"flash/"+this.cssFolder;
//			if(!this.webConfig)
//			{
//				  
//			}
            loadUIConfig();
        }
        public function loadUIConfig():void{
            var ui:* = null;
            var xmlList:* = null;  
            var procedure:* = null;
            bulkLoader.removeEventListener(BulkProgressEvent.COMPLETE, complete);
            
			this.userID=Number(getProperties("userId"));
            ui = "uiconfig";
            proceduces = config.proceduces;
            xmlList = config.proceduces.proceduce.(@name == ui);
            procedure = xmlList[0];
            this.ajaxURL = config.data[0].@ajaxURL;
            this.loadProduce(uiconfigComplete, procedure);
        }
        public function loadProduce(resultFunction:Function, procedure:String, params:String="", isWeburl:Boolean=false):void{
            var pstr:String = encodeURI(procedure);
            var pparam:String = encodeURI(params);
            var url:String = produceurl;
            if (isWeburl){
                url = produceweburl;
            };
            var purl:String = ((((((url + "?SpName=") + pstr) + "&paramsString=") + pparam) + "&") + Math.random());
            var postRequest:URLRequest = new URLRequest(purl);
            trace(("loadURL" + purl));
            postRequest.method = "post";
            if (!(this.urlloader)){
                urlloader = new URLLoader();
            };
            urlloader.addEventListener(IOErrorEvent.IO_ERROR, ioError);
            urlloader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, securityHandler);
            urlloader.addEventListener(Event.COMPLETE, resultFunction);
            urlloader.load(postRequest);
        }
        public function removeLoadedListener(func:Function):void{
            trace(urlloader.hasEventListener(Event.COMPLETE));
            this.urlloader.removeEventListener(Event.COMPLETE, func);
            this.urlloader.removeEventListener(IOErrorEvent.IO_ERROR, ioError);
            this.urlloader.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, securityHandler);
            trace(("remove" + func));
        }
        private function ioError(e:IOErrorEvent):void{
            trace(e.text);
        }
        private function securityHandler(e:SecurityErrorEvent):void{
            e.target.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, securityHandler);
        }
        public function getProcedure(value:String):String{
            var xmlList:* = null;
            var procedure:* = null;
            var value:* = value;
            xmlList = config.proceduces.proceduce.(@name == value);
            procedure = xmlList[0];
            return (procedure);
        }
        public function getProperties(value:String):String{
            var xmlList:* = null;  
            var value:* = value;
            xmlList = config.props.prop.(@name == value);
            value = xmlList[0];
            return (value);
        }
        private function uiconfigComplete(e:Event):void{
            urlloader.removeEventListener(Event.COMPLETE, uiconfigComplete);
            var data:XML = XML(this.urlloader.data);
            this.uiConfig =data.data[2];// data.data[1];  
			

            bulkLoader.add(((cssFolder + "/") + String(uiConfig.@背景图)), {id:"back"});
            bulkLoader.add((cssFolder + "/") +String(uiConfig.@一级菜单背图), {id:"menuback"});
			 
            bulkLoader.add(((cssFolder + "/") + String(uiConfig.@回收站图片)), {id:"trash"});  
            bulkLoader.add(((cssFolder + "/") + String(uiConfig.@活动区外框)), {id:"activeborder"});
            bulkLoader.add(((cssFolder + "/") + String(uiConfig.@活动区提示框)), {id:"activetip"});
            bulkLoader.add(((cssFolder + "/") + String(uiConfig.@二级菜单外框)), {id:"menu2border"});
            bulkLoader.add(((cssFolder + "/") + String(uiConfig.@二级菜单提示框)), {id:"menu2tip"});
            bulkLoader.add(((cssFolder + "/") + String(uiConfig.@二级菜单隐藏后的提示按钮)), {id:"menu2tipbutton"});
			
			bulkLoader.add((cssFolder + "/main/menu3.png"), {id:"menu3tipbutton"});   //三级菜单隐藏后的提示按钮
			
		   //这2行暂时注释掉
            bulkLoader.add(cssFolder+"/"+String(uiConfig.@二级单个菜单边框), {id:"menu2singleborder"});
            bulkLoader.add(cssFolder+"/"+String(uiConfig.@二级单个菜单点击), {id:"menu2singleclick"});
            bulkLoader.add(((cssFolder + "/") + String(uiConfig.@Logo)), {id:"logo"});
			bulkLoader.add(((cssFolder + "/") + String(uiConfig.@LogoTxt)), {id:"logoTxt"});
			bulkLoader.add((cssFolder + "/main/logoImg.png"), {id:"logoImg"});
			bulkLoader.add((cssFolder + "/")+String(uiConfig.@Logo隐藏前按钮), {id:"logohide"});
			bulkLoader.add((cssFolder + "/")+String(uiConfig.@Logo隐藏后按钮), {id:"logoshow"});   
			
			//bulkLoader.add((cssFolder + "/")+String(uiConfig.@Logo隐藏后按钮), {id:"logoshow"}); 
			
			//地图工具和地图切换  图 
			this.baseUILoad();
            dataGirdUILoad();
            this.listUILoad();
         //   mapUILoad();
            bulkLoader.addEventListener(BulkProgressEvent.COMPLETE, resouceLoaded);
            bulkLoader.addEventListener(BulkProgressEvent.PROGRESS, progress);
            bulkLoader.start();
        }
		public function baseUILoad():void
		{
			bulkLoader.add((cssFolder + "/main/maptool.png"), {id:"maptool"});   
			bulkLoader.add((cssFolder + "/main/maptype1.png"), {id:"maptype"});   
			
			bulkLoader.add((cssFolder + "/main/maptooldown.png"), {id:"maptooldown"});   
			bulkLoader.add((cssFolder + "/main/maptypedown1.png"), {id:"maptypedown"});   
			
			//地图工具 
			bulkLoader.add((cssFolder + "/main/toolback.png"), {id:"maptoolback"}); 
			bulkLoader.add((cssFolder + "/main/poly.png"), {id:"maptool_poly"});   
			bulkLoader.add((cssFolder + "/main/polya.png"), {id:"maptool_polya"});  
			bulkLoader.add((cssFolder + "/main/rect.png"), {id:"maptool_rect"});  
			bulkLoader.add((cssFolder + "/main/recta.png"), {id:"maptool_recta"});  
			bulkLoader.add((cssFolder + "/main/circle.png"), {id:"maptool_circle"});  
			bulkLoader.add((cssFolder + "/main/circlea.png"), {id:"maptool_circlea"}); 
			bulkLoader.add((cssFolder + "/main/clear.png"), {id:"maptool_clear"}); 
			bulkLoader.add((cssFolder + "/main/cleara.png"), {id:"maptool_cleara"}); 
			
			
			//地图地图 机房数据 
			bulkLoader.add((cssFolder + "/main/zxzd.png"), {id:"zxzd"});  
			bulkLoader.add((cssFolder + "/main/dyzx.png"), {id:"dyzx"}); 
			bulkLoader.add((cssFolder + "/main/szw.png"), {id:"szw"}); 
			bulkLoader.add((cssFolder + "/main/sjzc.png"), {id:"sjzc"}); 
			
			//地图切换
			/*
			bulkLoader.add((cssFolder + "/main/maptypebottom.png"), {id:"maptypebottom"}); 
			bulkLoader.add((cssFolder + "/main/maptypetop.png"), {id:"maptypetop"});   
			bulkLoader.add((cssFolder + "/main/maptypecenter.png"), {id:"maptypecenter"});  
			bulkLoader.add((cssFolder + "/main/maptypea.png"), {id:"maptypea"});  
			bulkLoader.add((cssFolder + "/main/maptypeitem.png"), {id:"maptypeitem"});  
			*/
			bulkLoader.add((cssFolder + "/main/maptypeback.png"), {id:"maptypeback"});  //背景
			bulkLoader.add((cssFolder + "/main/nav.png"), {id:"maptypenav"});  //导航图
			bulkLoader.add((cssFolder + "/main/yx.png"), {id:"maptypeyx"});  //影像图
			bulkLoader.add((cssFolder + "/main/2.5d.png"), {id:"maptype2.5d"});  //2.5维图
			
			bulkLoader.add((cssFolder + "/main/navc.png"), {id:"maptypenavc"});  
			bulkLoader.add((cssFolder + "/main/yxc.png"), {id:"maptypeyxc"});  
			bulkLoader.add((cssFolder + "/main/2.5dc.png"), {id:"maptype2.5dc"}); 
			
			//加载窗口图片
			bulkLoader.add((cssFolder + "/window/lefttop.png"), {id:"w_lefttop"});
			bulkLoader.add((cssFolder + "/window/leftbottom.png"), {id:"w_leftbottom"});
			bulkLoader.add((cssFolder + "/window/righttop.png"), {id:"w_righttop"});
			bulkLoader.add((cssFolder + "/window/rightbottom.png"), {id:"w_rightbottom"});
			
			
			bulkLoader.add((cssFolder + "/window/top.png"), {id:"w_top"});
			bulkLoader.add((cssFolder + "/window/bottom.png"), {id:"w_bottom"});
			bulkLoader.add((cssFolder + "/window/left.png"), {id:"w_left"});
			bulkLoader.add((cssFolder + "/window/right.png"), {id:"w_right"});
			bulkLoader.add((cssFolder + "/window/back.png"), {id:"w_back"});
			
			bulkLoader.add((cssFolder + "/window/topbottom.png"), {id:"w_topbottom"});
			bulkLoader.add((cssFolder + "/window/leftright.png"), {id:"w_leftright"});
			//加载窗口图片 end
			
			//相册组件播放----
			bulkLoader.add((cssFolder + "/main/photoplay.png"), {id:"photoplay"});  
			bulkLoader.add((cssFolder + "/main/photoplayc.png"), {id:"photoplayc"});  
			
			bulkLoader.add((cssFolder + "/main/photostop.png"), {id:"photostop"});  
			bulkLoader.add((cssFolder + "/main/photostopc.png"), {id:"photostopc"});  
			
			//--------
			/*
			bulkLoader.add(String(uiConfig.@Logo隐藏前按钮), {id:"logohide"});
			bulkLoader.add(String(uiConfig.@Logo隐藏后按钮), {id:"logoshow"});  
			*/
			bulkLoader.add((cssFolder + "/images/weather/weather.png"), {id:"weather"});
			bulkLoader.add((cssFolder + "/images/tab/left.png"), {id:"win_left"});
			bulkLoader.add((cssFolder + "/images/tab/center.png"), {id:"win_center"});
			bulkLoader.add((cssFolder + "/images/tab/right.png"), {id:"win_right"});
			bulkLoader.add((cssFolder + "/view/to_flow_e.png"), {id:"toflowe"});
			bulkLoader.add((cssFolder + "/view/to_flow_c.png"), {id:"toflowc"});
			bulkLoader.add((cssFolder + "/close/closed.png"), {id:"closed"});
			bulkLoader.add((cssFolder + "/close/closec.png"), {id:"closec"});
			
			if (String(this.config.font.@load) == "true"){
				this.fontLoaded = true;
				if(this.webConfig)
				{
					bulkLoader.add(String(this.config.font), {id:"font"}); //如果是web才加载潜入字体
				}
				//bulkLoader.add(cssFolder+"/"+String(this.config.font), {id:"font"});
				
			};  
			
			if (String(this.config.mapconfig.@load) == "true"){
				this.mapConfigLoaded = true;
				bulkLoader.add(cssFolder+"/"+String(this.config.mapconfig), {id:"mapconfig"});
			};
			
			bulkLoader.add(cssFolder+"/assets/done.gif", {  
				id:"loading",
				type:"binary"
			});
			//bulkLoader.add("assets/CLDPlugin.swf", {id:"plugin"});
		}
		
        public function addMenuID(menuID:String):void{
            openMenuIDs[menuID] = menuID;
        }
        public function containsMenuId(menuID:String){
            return (openMenuIDs[menuID]);
        }
        public function deleteMenuID(menuID:String):void{
            delete openMenuIDs[menuID];
        }
        public function listUILoad():void{
            bulkLoader.add((cssFolder + "/images/list/left.png"), {id:"list_left"});
            bulkLoader.add((cssFolder + "/images/list/center.png"), {id:"left_center"});
            bulkLoader.add((cssFolder + "/images/list/right.png"), {id:"list_right"});
            bulkLoader.add((cssFolder + "/images/list/centerMask.png"), {id:"list_centerMask"});
        }
        public function getPluginComponent(type:String, id:String, timeInteval:Number, autoLoad:Boolean=false):CLDBaseComponent{
            var obj:Object = this.getItem("plugin");
            if (obj){
                return (obj["getComponent"](type, id, timeInteval, autoLoad));
            };
            return (null);
        }
        public function getPluginLayout(viewID:int):CLDLayoutUI{
            var obj:Object = this.getItem("plugin");
            if (obj){
                return (obj["getLayoutByViewID"](viewID));
            };
            return (null);
        }
        public function dataGirdUILoad():void{
//            bulkLoader.add((cssFolder + "/images/window/rightRange.png"), {id:"win_rightRange.png"});
//            bulkLoader.add((cssFolder + "/images/window/leftRange.png"), {id:"win_leftRange.png"});
//            bulkLoader.add((cssFolder + "/images/window/downRightRange.png"), {id:"win_downRightRange.png"});
//            bulkLoader.add((cssFolder + "/images/window/downLeftRange.png"), {id:"win_downLeftRange.png"});
//            bulkLoader.add((cssFolder + "/images/window/closeBtn.png"), {id:"win_closeBtn.png"});
//            bulkLoader.add((cssFolder + "/images/window/line.png"), {id:"win_line.png"});
            bulkLoader.add((cssFolder + "/images/picbox/picBorder.png"), {id:"picBorder"});
            bulkLoader.add((cssFolder + "/images/grild/left.png"), {id:"tableLeft"});
            bulkLoader.add((cssFolder + "/images/grild/center.png"), {id:"tableCenter"});
            bulkLoader.add((cssFolder + "/images/grild/right.png"), {id:"tableRight"});
            bulkLoader.add((cssFolder + "/images/grild/left1.png"), {id:"tableLeft1"});
            bulkLoader.add((cssFolder + "/images/grild/center1.png"), {id:"tableCenter1"});
            bulkLoader.add((cssFolder + "/images/grild/right1.png"), {id:"tableRight1"});
            bulkLoader.add((cssFolder + "/images/grild/line.png"), {id:"tableLine"});
            bulkLoader.add((cssFolder + "/images/grild/bground.png"), {id:"tableBground"});
            bulkLoader.add((cssFolder + "/images/grild/leftPoint.png"), {id:"leftPoint"});
            bulkLoader.add((cssFolder + "/images/grild/rightPoint.png"), {id:"rightPoint"});
            bulkLoader.add((cssFolder + "/images/grild/upPoint.png"), {id:"upPoint"});
            bulkLoader.add((cssFolder + "/images/grild/downPoint.png"), {id:"downPoint"});
            bulkLoader.add((cssFolder + "/images/qqWin/qqLeft.png"), {id:"tabimg0"});
            bulkLoader.add((cssFolder + "/images/qqWin/qqCenter.png"), {id:"tabimg1"});
            bulkLoader.add((cssFolder + "/images/qqWin/qqRight.png"), {id:"tabimg2"});
            bulkLoader.add((cssFolder + "/images/qqWin/qqLogo.png"), {id:"tabimg3"});
            bulkLoader.add((cssFolder + "/images/qqWin/qqLogo2.png"), {id:"tabimg4"});
//            bulkLoader.add((cssFolder + "/images/alarm/bg.png"), {id:"pointBg"});
            bulkLoader.add((cssFolder + "/images/randar/randar.png"), {id:"randar"});
            bulkLoader.add((cssFolder + "/images/randar/point.png"), {id:"randarPoint"});
           // bulkLoader.add((cssFolder + "/images/right_blue.png"), {id:"rightblue"});
            bulkLoader.add((cssFolder + "/images/randar/red.png"), {id:"randarRed"});
            bulkLoader.add((cssFolder + "/images/randar/yellow.png"), {id:"randarYellow"});
            bulkLoader.add((cssFolder + "/images/randar/green.png"), {id:"randarGreen"});
            bulkLoader.add((cssFolder + "/images/randar/orange.png"), {id:"randarOrange"});
//            bulkLoader.add((cssFolder + "/images/1_03.png"), {id:"leftdark"});
//            bulkLoader.add((cssFolder + "/images/1_04.png"), {id:"centerblue"});
//            bulkLoader.add((cssFolder + "/images/1_05.png"), {id:"rightdark"});
//            bulkLoader.add((cssFolder + "/images/1_06.png"), {id:"wholeblue"});
//            bulkLoader.add((cssFolder + "/images/1_07.png"), {id:"centerdark"});
//            bulkLoader.add((cssFolder + "/images/1_09.png"), {id:"wholedark"});
            bulkLoader.add((cssFolder + "/images/tab/left1.png"), {id:"leftdark1"});
            bulkLoader.add((cssFolder + "/images/tab/center1.png"), {id:"center1"});
            bulkLoader.add((cssFolder + "/images/tab/right1.png"), {id:"darkright1"});
            bulkLoader.add((cssFolder + "/images/tab/left.png"), {id:"leftbule"});
            bulkLoader.add((cssFolder + "/images/tab/center.png"), {id:"centerbule1"});
            bulkLoader.add((cssFolder + "/images/tab/right.png"), {id:"rightbule"});
            bulkLoader.add((cssFolder + "/images/tab/line.png"), {id:"tabLine"});
            bulkLoader.add((cssFolder + "/images/timer/timelogo.png"), {id:"timerLogo"});
            bulkLoader.add((cssFolder + "/images/timer/timeline.png"), {id:"timerLine"});
            bulkLoader.add((cssFolder + "/images/button/right.png"), {id:"buttonRight"});
            bulkLoader.add((cssFolder + "/images/button/center.png"), {id:"buttonCenter"});
            bulkLoader.add((cssFolder + "/images/button/left.png"), {id:"buttonLeft"});
			bulkLoader.add((cssFolder + "/images/button/button.png"), {id:"button"});
           // bulkLoader.add((cssFolder + "/images/button/left.png"), {id:"buttonLeft"});
            bulkLoader.add((cssFolder + "/showDesk.png"), {id:"showDesk"});
            bulkLoader.add((cssFolder + "/images/color/leftTopRange.png"), {id:"color_leftTopRange"});
            bulkLoader.add((cssFolder + "/images/color/rightTopRange.png"), {id:"color_rightTopRange"});
            bulkLoader.add((cssFolder + "/images/color/downLeftRange.png"), {id:"color_downLeftRange"});
            bulkLoader.add((cssFolder + "/images/color/downRightRange.png"), {id:"color_downRightRange"});
            bulkLoader.add((cssFolder + "/images/color/bground.png"), {id:"color_bground"});
            bulkLoader.add((cssFolder + "/images/color/topBorder.png"), {id:"color_topBorder"});
            bulkLoader.add((cssFolder + "/images/color/downBorder.png"), {id:"color_downBorder"});
            bulkLoader.add((cssFolder + "/images/color/rightBorder.png"), {id:"color_rightBorder"});
            bulkLoader.add((cssFolder + "/images/color/leftBorder.png"), {id:"color_leftBorder"});
         
           // bulkLoader.add((cssFolder + "/images/button/left.png"), {id:"buttonLeft"});
            bulkLoader.add((cssFolder + "/images/builder/1_1.png"), {id:"1_1"});
            bulkLoader.add((cssFolder + "/images/builder/2_1.png"), {id:"2_1"});
            bulkLoader.add((cssFolder + "/images/builder/3_1.png"), {id:"3_1"});
            bulkLoader.add((cssFolder + "/images/builder/4_1.png"), {id:"4_1"});
            bulkLoader.add((cssFolder + "/images/builder/4_2.png"), {id:"4_2"});
            bulkLoader.add((cssFolder + "/images/builder/4_3.png"), {id:"4_3"});
            bulkLoader.add((cssFolder + "/images/builder/5_1.png"), {id:"5_1"});
            bulkLoader.add((cssFolder + "/images/builder/6_1.png"), {id:"6_1"});
            bulkLoader.add((cssFolder + "/images/alarm/cbg.png"), {id:"cbg"});
            bulkLoader.add((cssFolder + "/images/alarm/dbg.png"), {id:"dbg"});
            bulkLoader.add((cssFolder + "/images/alarm/jbg.png"), {id:"jbg"});
            bulkLoader.add((cssFolder + "/images/alarm/zbg.png"), {id:"zbg"});
        }
        public function dataGirdUILoadTest():void{
            bulkLoader = BulkLoader.getLoader("main");
            if (!(bulkLoader)){
                bulkLoader = new BulkLoader("main");
            };
            bulkLoader.add((cssFolder + "/images/window/rightRange.png"), {id:"win_rightRange.png"});
            bulkLoader.add((cssFolder + "/images/window/leftRange.png"), {id:"win_leftRange.png"});
            bulkLoader.add((cssFolder + "/images/window/downRightRange.png"), {id:"win_downRightRange.png"});
            bulkLoader.add((cssFolder + "/images/window/downLeftRange.png"), {id:"win_downLeftRange.png"});
            bulkLoader.add((cssFolder + "/images/window/closeBtn.png"), {id:"win_closeBtn.png"});
            bulkLoader.add((cssFolder + "/images/window/line.png"), {id:"win_line.png"});
            bulkLoader.add((cssFolder + "/images/picbox/picBorder.png"), {id:"picBorder"});
            bulkLoader.add((cssFolder + "/images/grild/left.png"), {id:"tableLeft"});
            bulkLoader.add((cssFolder + "/images/grild/center.png"), {id:"tableCenter"});
            bulkLoader.add((cssFolder + "/images/grild/right.png"), {id:"tableRight"});
            bulkLoader.add((cssFolder + "/images/grild/left1.png"), {id:"tableLeft1"});
            bulkLoader.add((cssFolder + "/images/grild/center1.png"), {id:"tableCenter1"});
            bulkLoader.add((cssFolder + "/images/grild/right1.png"), {id:"tableRight1"});
            bulkLoader.add((cssFolder + "/images/grild/line.png"), {id:"tableLine"});
            bulkLoader.add((cssFolder + "/images/grild/bground.png"), {id:"tableBground"});
            bulkLoader.add((cssFolder + "/images/grild/leftPoint.png"), {id:"leftPoint"});
            bulkLoader.add((cssFolder + "/images/grild/rightPoint.png"), {id:"rightPoint"});
            bulkLoader.add((cssFolder + "/images/grild/upPoint.png"), {id:"upPoint"});
            bulkLoader.add((cssFolder + "/images/grild/downPoint.png"), {id:"downPoint"});
            bulkLoader.add((cssFolder + "/images/qqWin/qqLeft.png"), {id:"tabimg0"});
            bulkLoader.add((cssFolder + "/images/qqWin/qqCenter.png"), {id:"tabimg1"});
            bulkLoader.add((cssFolder + "/images/qqWin/qqRight.png"), {id:"tabimg2"});
            bulkLoader.add((cssFolder + "/images/qqWin/qqLogo.png"), {id:"tabimg3"});
            bulkLoader.add((cssFolder + "/images/qqWin/qqLogo2.png"), {id:"tabimg4"});
            bulkLoader.add((cssFolder + "/images/qqWin/0_14.png"), {id:"tabimg5"});
            bulkLoader.add((cssFolder + "/images/qqWin/2_09.png"), {id:"tabimg6"});
            bulkLoader.add((cssFolder + "/images/qqWin/2_18.png"), {id:"tabimg7"});
            bulkLoader.add((cssFolder + "/images/qqWin/2_20.png"), {id:"tabimg8"});
            bulkLoader.add((cssFolder + "/images/alarm/bg.png"), {id:"pointBg"});
            bulkLoader.add((cssFolder + "/images/randar/randar.png"), {id:"randar"});
            bulkLoader.add((cssFolder + "/images/randar/point.png"), {id:"randarPoint"});
            bulkLoader.add((cssFolder + "/images/randar/red.png"), {id:"randarRed"});
            bulkLoader.add((cssFolder + "/images/randar/yellow.png"), {id:"randarYellow"});
            bulkLoader.add((cssFolder + "/images/randar/green.png"), {id:"randarGreen"});
            bulkLoader.add((cssFolder + "/images/randar/orange.png"), {id:"randarOrange"});
            bulkLoader.add((cssFolder + "/images/1_03.png"), {id:"leftdark"});
            bulkLoader.add((cssFolder + "/images/1_04.png"), {id:"centerblue"});
            bulkLoader.add((cssFolder + "/images/1_05.png"), {id:"rightdark"});
            bulkLoader.add((cssFolder + "/images/1_06.png"), {id:"wholeblue"});
            bulkLoader.add((cssFolder + "/images/1_07.png"), {id:"centerdark"});
            bulkLoader.add((cssFolder + "/images/1_09.png"), {id:"wholedark"});
            bulkLoader.add((cssFolder + "/images/tab/left1.png"), {id:"leftdark1"});
            bulkLoader.add((cssFolder + "/images/tab/center1.png"), {id:"center1"});
            bulkLoader.add((cssFolder + "/images/tab/right1.png"), {id:"darkright1"});
            bulkLoader.add((cssFolder + "/images/tab/left.png"), {id:"leftbule"});
            bulkLoader.add((cssFolder + "/images/tab/center.png"), {id:"centerbule1"});
            bulkLoader.add((cssFolder + "/images/tab/right.png"), {id:"rightbule"});
            bulkLoader.add((cssFolder + "/images/tab/line.png"), {id:"tabLine"});
            bulkLoader.add((cssFolder + "/images/tab/line.png"), {id:"tabLine"});
            bulkLoader.add((cssFolder + "/images/timer/timelogo.png"), {id:"timerLogo"});
            bulkLoader.add((cssFolder + "/images/timer/timeline.png"), {id:"timerLine"});
            bulkLoader.add((cssFolder + "/images/button/right.png"), {id:"buttonRight"});
            bulkLoader.add((cssFolder + "/images/button/center.png"), {id:"buttonCenter"});
            bulkLoader.add((cssFolder + "/images/button/left.png"), {id:"buttonLeft"});
            bulkLoader.add((cssFolder + "/images/button/left.png"), {id:"buttonLeft"});
            bulkLoader.add((cssFolder + "/showDesk.png"), {id:"showDesk"});
            bulkLoader.add((cssFolder + "/images/color/leftTopRange.png"), {id:"color_leftTopRange"});
            bulkLoader.add((cssFolder + "/images/color/rightTopRange.png"), {id:"color_rightTopRange"});
            bulkLoader.add((cssFolder + "/images/color/downLeftRange.png"), {id:"color_downLeftRange"});
            bulkLoader.add((cssFolder + "/images/color/downRightRange.png"), {id:"color_downRightRange"});
            bulkLoader.add((cssFolder + "/images/color/bground.png"), {id:"color_bground"});
            bulkLoader.add((cssFolder + "/images/color/topBorder.png"), {id:"color_topBorder"});
            bulkLoader.add((cssFolder + "/images/color/downBorder.png"), {id:"color_downBorder"});
            bulkLoader.add((cssFolder + "/images/color/rightBorder.png"), {id:"color_rightBorder"});
            bulkLoader.add((cssFolder + "/images/color/leftBorder.png"), {id:"color_leftBorder"});
            bulkLoader.add((cssFolder + "/images/button/button.png"), {id:"button"});
            bulkLoader.add((cssFolder + "/images/button/left.png"), {id:"buttonLeft"});
            bulkLoader.add((cssFolder + "/images/builder/1_1.png"), {id:"1_1"});
            bulkLoader.add((cssFolder + "/images/builder/2_1.png"), {id:"2_1"});
            bulkLoader.add((cssFolder + "/images/builder/3_1.png"), {id:"3_1"});
            bulkLoader.add((cssFolder + "/images/builder/4_1.png"), {id:"4_1"});
            bulkLoader.add((cssFolder + "/images/builder/4_2.png"), {id:"4_2"});
            bulkLoader.add((cssFolder + "/images/builder/4_3.png"), {id:"4_3"});
            bulkLoader.add((cssFolder + "/images/builder/5_1.png"), {id:"5_1"});
            bulkLoader.add((cssFolder + "/images/builder/6_1.png"), {id:"6_1"});
            bulkLoader.add((cssFolder + "/images/alarm/cbg.png"), {id:"cbg"});
            bulkLoader.add((cssFolder + "/images/alarm/dbg.png"), {id:"dbg"});
            bulkLoader.add((cssFolder + "/images/alarm/jbg.png"), {id:"jbg"});
            bulkLoader.add((cssFolder + "/images/alarm/zbg.png"), {id:"zbg"});
            bulkLoader.add(cssFolder+"/FontMsyh.swf", {id:"font0"});
            if (!(bulkLoader.hasEventListener(BulkProgressEvent.COMPLETE))){
                bulkLoader.addEventListener(BulkProgressEvent.COMPLETE, resouceLoaded);
            };
            bulkLoader.start();
        }
        public function tabUILoad():void{
            bulkLoader = BulkLoader.getLoader("main");
            if (!(bulkLoader)){
                bulkLoader = new BulkLoader("main");
            };
            if (!(bulkLoader.hasEventListener(BulkProgressEvent.COMPLETE))){
                bulkLoader.addEventListener(BulkProgressEvent.COMPLETE, resouceLoaded);
            };
            bulkLoader.start();
        }
        public function mapUILoad():void{
            bulkLoader = BulkLoader.getLoader("main");
            if (!(bulkLoader)){
                bulkLoader = new BulkLoader("main");
            };
            bulkLoader.add((cssFolder + "/map/map_0.png"), {id:"cld_map_zoom1"});
            bulkLoader.add((cssFolder + "/map/map_1.png"), {id:"cld_map_zoom2"});
            bulkLoader.add((cssFolder + "/map/map_2.png"), {id:"cld_map_zoom3"});
            bulkLoader.add((cssFolder + "/map/map_3.png"), {id:"cld_map_zoom4"});
            bulkLoader.add((cssFolder + "/map/map_4.png"), {id:"cld_map_zoom5"});
            bulkLoader.add((cssFolder + "/map/map_5.png"), {id:"cld_map_zoom6"});
            bulkLoader.add((cssFolder + "/map/map_0d.png"), {id:"cld_map_zoom1_down"});
            bulkLoader.add((cssFolder + "/map/map_1d.png"), {id:"cld_map_zoom2_down"});
            bulkLoader.add((cssFolder + "/map/map_2d.png"), {id:"cld_map_zoom3_down"});
            bulkLoader.add((cssFolder + "/map/map_3d.png"), {id:"cld_map_zoom4_down"});
            bulkLoader.add((cssFolder + "/map/map_4d.png"), {id:"cld_map_zoom5_down"});
            bulkLoader.add((cssFolder + "/map/map_5d.png"), {id:"cld_map_zoom6_down"});
            if (!(bulkLoader.hasEventListener(BulkProgressEvent.COMPLETE))){
                bulkLoader.addEventListener(BulkProgressEvent.COMPLETE, resouceLoaded);
            };
            bulkLoader.start();
        }
        public function mapConfigLoad():void{
            bulkLoader = BulkLoader.getLoader("main");
            if (!(bulkLoader)){
                bulkLoader = new BulkLoader("main");
            };
            bulkLoader.add("assets/map/map_0.png", {id:"cld_map_zoom1"});
            bulkLoader.add("assets/map/map_1.png", {id:"cld_map_zoom2"});
            bulkLoader.add("assets/map/map_2.png", {id:"cld_map_zoom3"});
            bulkLoader.add("assets/map/map_3.png", {id:"cld_map_zoom4"});
            bulkLoader.add("assets/map/map_4.png", {id:"cld_map_zoom5"});
            bulkLoader.add("assets/map/map_5.png", {id:"cld_map_zoom6"});
            bulkLoader.add("assets/map/map_0d.png", {id:"cld_map_zoom1_down"});
            bulkLoader.add("assets/map/map_1d.png", {id:"cld_map_zoom2_down"});
            bulkLoader.add("assets/map/map_2d.png", {id:"cld_map_zoom3_down"});
            bulkLoader.add("assets/map/map_3d.png", {id:"cld_map_zoom4_down"});
            bulkLoader.add("assets/map/map_4d.png", {id:"cld_map_zoom5_down"});
            bulkLoader.add("assets/map/map_5d.png", {id:"cld_map_zoom6_down"});
            dataGirdUILoad();
            if (!(bulkLoader.hasEventListener(BulkProgressEvent.COMPLETE))){
                bulkLoader.addEventListener(BulkProgressEvent.COMPLETE, resouceLoaded);
            };
            bulkLoader.start();
        }
        private function resouceLoaded(e:Event):void{
			if(this.mapConfigLoaded)
			{
				var mapxml:XML=bulkLoader.getXML("mapconfig", true);
				com.careland.util.CLDConfig.instance().configXML=mapxml;
			}
            var re:ResouceEvent = new ResouceEvent(ResouceEvent.RESOURCELOADED);
            this.dispatchEvent(re);
            bulkLoader.clear();
			
			
        }
        private function progress(e:BulkProgressEvent):void{
			
            var re:ResouceEvent = new ResouceEvent(ResouceEvent.PROGRESS);
            re.byteLoad = e.bytesLoaded;
            re.byteTotal = e.bytesTotal;
			re.itemLoaded=e.itemsLoaded;
			re.totalItems=e.itemsTotal;
            this.dispatchEvent(re);
        }
        public function getItem(key):Object{
            return (this.bulkLoader.get(key).content);
        }
        public function getBinary(key):ByteArray{
            return (this.bulkLoader.getBinary("FlexPaper"));
        }
        public function getBitmap(key):Bitmap{ 
            return (this.bulkLoader.getBitmap(key, false));
        }
        private function complete(e:BulkProgressEvent):void{
            bulkLoader.removeEventListener(BulkProgressEvent.COMPLETE, complete);
            this.config = bulkLoader.getXML("config", true);
			
			this.contenturl = String(config.contenturl[0]);
			this.produceurl = String(config.produceurl[0]);
			this.produceweburl = String(config.produceweburl[0]);
			this.baseurl = String(config.baseurl[0]);
			
            var re:ResouceEvent = new ResouceEvent(ResouceEvent.COMPLETE);
            this.dispatchEvent(re);
			
            this.initFoler();
        }

        //((ExternalInterface.available) && (ExternalInterface.call("eval", new jsCode().toString())));
    }
}//package com.careland 