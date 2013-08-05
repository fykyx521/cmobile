package com.identity
{
	import caurina.transitions.Tweener;
	
	import com.careland.CLDMapContainer;
	import com.careland.CLDTouch2MapContainer;
	import com.careland.CLDTouch3MapContainer;
	import com.careland.CLDTouchMapContainer;
	import com.careland.YDConfig;
	import com.careland.command.CMD;
	import com.careland.command.Message;
	import com.careland.component.CLDBaseComponent;
	import com.careland.component.util.CLDLoding;
	import com.careland.component.win.CLDMapOverWin;
	import com.careland.event.CLDEvent;
	import com.careland.event.RowEvent;
	import com.careland.events.DynamicEvent;
	import com.careland.events.MapDataEvent;
	import com.careland.events.MapEvent;
	import com.careland.layer.CLDBaseMarker;
	import com.careland.layer.CLDCircleSprite;
	import com.careland.layer.CLDLayer;
	import com.careland.layer.CLDMarker;
	import com.careland.layer.CLDMutiRectSprite;
	import com.careland.layer.CLDPolyLine;
	import com.careland.layer.CLDPolygon;
	import com.careland.layer.CLDRectSprite;
	import com.careland.layer.draw.CLDCircleLayer;
	import com.careland.layer.draw.CLDMutiRectLayer;
	import com.careland.layer.draw.CLDRectLayer;
	import com.careland.util.CLDConfig;
	import com.careland.util.MapConfig;
	
	import flash.display.DisplayObjectContainer;
	import flash.events.Event;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import sinaappp.wwyx.Log;
	
	import uk.co.teethgrinder.string.StringUtils;

	public class CLDMap extends CLDBaseComponent
	{
		
		private var content:CLDBaseComponent;
		private var blobs:Array=[];				
		

    	//protected var center:Point=new Point(114.2032409, 22.70870111);
		protected var center:Point=new Point(114.34810420415893,22.678182450183083);
		
//		protected var center:Point=new Point(410847000,81360600);
		
		protected var cm:CLDMapContainer;		
		protected var layer:CLDLayer;
 
		private var vzoom:int=1;	
 
		protected var mapControl:CLDMapControl;
		
		private var mapOver:CLDMapOverWin;
		
		
		private var _isDrawState:Boolean=false;
		
		private var circleSprite:CLDCircleSprite;
		
		private var rectSprite:CLDRectSprite;
		
		private var mutirectSprite:CLDRectSprite;
		
		private var cldLoding:CLDLoding;
		
		private var first:Boolean=true;// 为了地图切换 设计一个临时变量
		
		private var maptypeData:Object={};
		public function CLDMap(parent:DisplayObjectContainer=null, xpos:Number=0, ypos:Number=0, autoLoad:Boolean=false, timeInteval:int=0)
		{
			super(parent, xpos, ypos, autoLoad, timeInteval);
			
		}
		override protected function addChildren():void
		{
			layer=new CLDLayer();
			//mapControl=new CLDMapControl();
			mapOver=new CLDMapOverWin();
			loadConfig();
		}	
		private function loadConfig():void
		{
			//设置地图路径
			//CLDConfig.instance().configXML=XML(config.getItem("mapconfig"));
			//CLDConfig.instance().configXML=XML(this.config.getItem("mapConfig"));
			configLoaded();
		}
		
		override public function dispose():void
		{
			
			if(cm){
				
				cm.dispose();
			}
			if(this.mapControl){
				mapControl.removeEventListener(MapEvent.MapClearLayer,mapClearLayer);
			}
			if(config) 
			{
				config.removeEventListener("drawCircle",this.drawCircle);
				config.removeEventListener("drawMutiRect",this.drawMutiRect);
				config.removeEventListener("drawRect",this.drawRect);
				//			mapControl.addEventListener("startLine",startLine);
				config.removeEventListener(MapEvent.ConfigMapChange,cldMapChange);
				config.removeEventListener(MapEvent.MapClearLayer,mapClearLayer);
				
			} 
			
			
			super.dispose();
		
			cm=null;
			mapControl=null;
			mapOver=null;
			this.layer=null;
			
		}
		
		
		override public function get width():Number
		{
			return Math.max(super.width,256);
		}
		override public function get height():Number
		{
			return Math.max(super.height,256);			
		}
		public function set _center(value:Point):void
		{
			cm.center=value;

		}
		public function getCenter():Point
		{
			return this.cm.center;
		}
		public function set zoom(value:int):void
		{
			this.cm.zoom=value;
		}
		public function get zoom():int
		{
			return this.cm.zoom;
		}
		
		
		public function get Layer():CLDLayer
		{
			return this.layer;
		}
		
		public function get mapType():int
		{
			return this.cm.mapType(); 
		}
		
		public function get mapconfig():MapConfig
		{
			if(cm)return cm.mapconfig;
			
			return null;
		}
		CONFIG::TUIO
		protected function initContainer():void
		{
			cm=new CLDTouchMapContainer(CLDConfig.instance(),center,vzoom);
			cm.setSize(this.width,this.height);
			cm.addEventListener(MapEvent.MapLocationChange,mapLocationChange);
			if(center){
				cm.loadMapPic();
			}
			this.addChild(cm);		
			cm.contentEnabled=false;
		}
		
		CONFIG::MOUSE
		protected function initContainer():void
		{
			cm=new CLDMapContainer(CLDConfig.instance(),center,vzoom);
			cm.setSize(this.width,this.height);
			cm.addEventListener(MapEvent.MapLocationChange,mapLocationChange);
			if(center){
				cm.loadMapPic();
			}
			this.addChild(cm);		
			cm.contentEnabled=true;
		}
		CONFIG::IPAD
		protected function initContainer():void
		{
			cm=new CLDTouch3MapContainer(CLDConfig.instance(),center,vzoom);
			cm.setSize(this.width,this.height);
    		cm.addEventListener(MapEvent.MapLocationChange,mapLocationChange);
			if(center){
				cm.loadMapPic();
			}
			this.addChild(cm);		
			cm.contentEnabled=true;
		}
		
		override public function register():void
		{  
			super.register();
			this.registerCommand(CMD.MAPLOCATIONCHANGE,CMD.MAP_DRAW_CIRCLE,CMD.MAP_DRAW_RECT,CMD.MAP_DRAW_MUTIRECT,CMD.MAP_MARKER_CLICK);
		}
		override public function unregister():void
		{
			super.unregister();
			this.unregisterCommand(CMD.MAPLOCATIONCHANGE,CMD.MAP_DRAW_CIRCLE,CMD.MAP_DRAW_RECT,CMD.MAP_DRAW_MUTIRECT,CMD.MAP_MARKER_CLICK);
		}
		override protected function handlerRemote(e:Message):void
		{
			if(e.type==CMD.MAPLOCATIONCHANGE) //位置改变事件 
			{
					 var option:Object=e.data;
					 setLocation(new Point(option.x,option.y),option.zoom,option.tilemapindex);
			}else if(e.type==CMD.MAP_DRAW_CIRCLE) //画圆
			{
				this.addCircleLayer(new Point(e.data.x,e.data.y),e.data.rectwidth);
			}else if(e.type==CMD.MAP_DRAW_RECT)//画框
			{
				this.addRectLayer(new Point(e.data.x,e.data.y),new Point(e.data.tx,e.data.ty));
			}else if(e.type==CMD.MAP_DRAW_MUTIRECT)//多边形
			{
				var vec:Vector.<Point>=new Vector.<Point>();
				for(var i=0;i<e.data.length;i++)
				{
					var item:Object=e.data[i];
					vec.push(new Point(item.x,item.y));
				}
				this.addMutiLayer(vec);
			}else if(e.type==CMD.MAP_MARKER_CLICK)
			{
				 this.showOverData(e.data.mouseOverData);
			}
		}
		
		//远程控制用到
		private function mapLocationChange(e:MapEvent):void
		{
			var mes:Message=Message.buildMsg(CMD.MAPLOCATIONCHANGE);
			var option:Object=new Object;
			option.x=e.center.x;
			option.y=e.center.y;
			option.zoom=e.zoom;
			option.tilemapindex=e.mapType;
			option.contentID=this.contentID;
			mes.data=option;
			this.sendCommand(mes);
			this.dispatchEvent(e.clone());
		}
		
		private function configLoaded(e:Event=null):void
		{			
			
			this.initContainer();
			layer=cm.addLayer("mainLayer");
			
			//this.addChild(this.mapControl);
			this.addChild(this.mapOver);
			mapOver.visible=false;
			config.addEventListener("drawCircle",this.drawCircle);
			config.addEventListener("drawMutiRect",this.drawMutiRect);
			config.addEventListener("drawRect",this.drawRect);
//			mapControl.addEventListener("startLine",startLine);
			config.addEventListener(MapEvent.MapClearLayer,mapClearLayer);
			config.addEventListener(MapEvent.ConfigMapChange,cldMapChange);
			
			
			
			config.addEventListener(RowEvent.locationResult,findLocation);		
		}
		//定位
		private function findLocation(e:RowEvent):void
		{
			if(e.GPS==2){
				var locationLayer:CLDLayer=new CLDLayer();
				var data:Array=e.data;
				for each(var obj:Object in data)
				{
					var xml:XML=XML(obj);
					var marker:CLDMarker=new CLDMarker();
					marker.src=decodeURI(xml.data[0].@icon);
					marker.pointType="image";
					marker.cldPoint=new Point(xml.data[0].@X,xml.data[0].@Y);	
			
					locationLayer.addMarker(marker);
					marker.invalidate();
					
					//this.mapAddLayer();		
				}
				this.addLayer(locationLayer);
				this.updateSingleLayer(locationLayer);
				
				
			}
		}
		
		
		public function setLocation(center:Point,zoom:int,tileMap:int):void
		{
			if(cm)
			{
				cm.setLocation(center,zoom,tileMap);
				if(first)
				{
					this.maptypeData={center:center,zoom:zoom,tileMap:tileMap};
					this.config.maptypeData={center:center,zoom:zoom,tileMap:tileMap};
					first=false;
					var me:MapEvent=new MapEvent(MapEvent.MapTypeChange);
					me.mapTileNum=tileMap;
					this.config.dispatchEvent(me);
				}
			}
			
		}
		public function setCenter(center:Point):void
		{
			if(cm)cm.center=center;
		}
		public function set isDrawState(value:Boolean):void
		{
			this._isDrawState=value;
			if(!value)
			{
				this.drawEnd();
			}  
		}
		public function get isDrawState():Boolean
		{
			return this._isDrawState;
		}
		private function drawMutiRect(e:Event):void
		{
			if(!isDrawState)
			{
				isDrawState=true;
				this.mutirectSprite=new CLDMutiRectSprite;
				this.addChild(mutirectSprite);
				mutirectSprite.IsIpad=!YDConfig.instance().webConfig;
				this.setChildIndex(mutirectSprite,this.numChildren-1);
				mutirectSprite.setSize(this.width,this.height);
				
				mutirectSprite.addEventListener(MapDataEvent.MAP_MUTI_RECT_DATA,mutiRectData);
				
			}
		}
		private function mutiRectData(e:MapDataEvent):void
		{
			if(this.mutirectSprite)
			{
				mutirectSprite.removeEventListener(MapDataEvent.MAP_MUTI_RECT_DATA,mutiRectData);
				
			}
			if(!e.isShow){
				this.removeChild(mutirectSprite);
				mutirectSprite.dispose();
				mutirectSprite=null;
				isDrawState=false;
				return;
			}else{
				
				addMutiLayer(e.points);
				this.sendMutiRectData(e.points);
				this.removeChild(mutirectSprite);
				mutirectSprite.dispose(); 
				mutirectSprite=null;
				isDrawState=false;
				
			}
			
		}
		private function addMutiLayer(points:Vector.<Point>):void
		{
			var mutiLayer:CLDMutiRectLayer=new CLDMutiRectLayer();
			mutiLayer.points=points;
			this.showLoding();
			mutiLayer.initData(this.mapconfig.center,width,height,this.mapconfig);
			//				mutiLayer.initData(this.mapconfig.center,this.mapconfig);
			this.addLayer(mutiLayer);
			this.updateSingleLayer(mutiLayer);
			mutiLayer.addEventListener(MapDataEvent.MAP_DATA_TIP,layerShowTip);
		}
		protected function sendMutiRectData(points:Vector.<Point>):void
		{
				var mes:Message=new Message(CMD.MAP_DRAW_MUTIRECT);
				mes.data=points;
				this.sendCommand(mes);
		}
			
		//
		private var isRectState:Boolean=false;
		private function drawRect(e:Event):void
		{
			if(!isDrawState)
			{
				isDrawState=true;
				this.rectSprite=new CLDRectSprite;
				rectSprite.IsIpad=!YDConfig.instance().webConfig;
				rectSprite.mapconfig=this.mapconfig;
				this.addChild(rectSprite);
				this.setChildIndex(rectSprite,this.numChildren-1);
				rectSprite.setSize(this.width,this.height);
				
				rectSprite.addEventListener(MapDataEvent.MAP_RECT_DATA,rectData);
				
			}
		}
//		public function cldPointToScreen(cld:Point):Object
//		{
//			return CLDConfig.instance().toScreenPoint(cld.x,cld.y,this.mapconfig);
//		}
//		public function screenPointToCLD(sreen:Point):Object
//		{
//			return CLDConfig.instance().toMapPoint(sreen.x,sreen.y,this.mapconfig);
//		}
		
		public function cldPointToScreen(cld:Point):Object
		{
			return CLDConfig.instance().toScreenPoint(cld.x,cld.y,this.width,this.height,this.mapconfig.scale,
				this.mapconfig.center.x,this.mapconfig.center.y,this.mapconfig.tilemapindex,this.mapconfig.wscale,
				this.mapconfig.hscale);
		}
		public function screenPointToCLD(sreen:Point):Object
		{
			return CLDConfig.instance().toMapPoint(sreen.x,sreen.y,this.width,this.height,this.mapconfig.center,this.mapconfig);
		}
		
		
		private function rectData(e:MapDataEvent):void
		{
			if(rectSprite){
				rectSprite.removeEventListener(MapDataEvent.MAP_RECT_DATA,rectData);
				
				if(!e.isShow)
				{
					this.removeChild(rectSprite);
					rectSprite.dispose();
					rectSprite=null;
					isDrawState=false;
					return;
				}else
				{
					this.addRectLayer(e.sourcepoint,e.toPoint);
					this.sendRectData(e.sourcepoint,e.toPoint);
					this.removeChild(rectSprite);
					rectSprite.dispose();
					rectSprite=null;
					isDrawState=false;
				}
				this.isDrawState=false;
			}
			
		}
		protected function sendRectData(sourcepoint:Point,toPoint:Point):void
		{
			var mes:Message=Message.buildMsg(CMD.MAP_DRAW_RECT);
			mes.data={x:sourcepoint.x,y:sourcepoint.y,tx:toPoint.x,ty:toPoint.y};
			this.sendCommand(mes);
		}
		private function addRectLayer(sourcepoint:Point,toPoint:Point):void
		{
			var layer:CLDRectLayer=new CLDRectLayer();
			layer.sourcePoint=sourcepoint;
			layer.toPoint=toPoint;
			this.showLoding();
			//					layer.initData(this.mapconfig.center,this.mapconfig);
			layer.initData(this.mapconfig.center,this.width,this.height,this.mapconfig);
			layer.addEventListener(MapDataEvent.MAP_DATA_TIP,layerShowTip);
			this.addLayer(layer);
			this.updateSingleLayer(layer);
		}
		
		private function drawCircle(e:Event):void
		{
			if(!isDrawState){
				
				isDrawState=true;
				circleSprite=new CLDCircleSprite;
				circleSprite.IsIpad=!YDConfig.instance().webConfig;
				this.addChild(circleSprite);
				this.setChildIndex(circleSprite,this.numChildren-1);
				circleSprite.setSize(this.width,this.height);
				circleSprite.addEventListener("circleDrawend",circleDrawend);
				
			}
			
		}
		//在地图上绘制园
		private function circleDrawend(e:DynamicEvent):void
		{	
			circleSprite.removeEventListener("circleDrawend",circleDrawend);
			if(!e.match){
				this.removeChild(circleSprite);
				circleSprite.dispose();
				circleSprite=null;
				isDrawState=false;
				return;
			}
			
			var infos:Object=e.infos;
			var rect:Rectangle=infos.rect;
			var centerPoint:Point=new Point(rect.x+rect.width/2,rect.y+rect.height/2);
			
			//初始化数据
			this.addCircleLayer(centerPoint,rect.width/2);
			this.sendCircleData(centerPoint,rect.width/2);
			this.removeChild(circleSprite);
			circleSprite.dispose();
			circleSprite=null;
			isDrawState=false;
		}
		
		private function addCircleLayer(centerPoint:Point,rectwidth:Number)
		{
			var circleLayer:CLDCircleLayer=new CLDCircleLayer();
			circleLayer.screenPoint=centerPoint;
			circleLayer._radius=rectwidth;
			//this.showLoding();
			circleLayer.initData(this.mapconfig.center,this.width,this.height,mapconfig);
			//			circleLayer.initData(this.mapconfig.center,mapconfig);
			this.addLayer(circleLayer);
			this.updateSingleLayer(circleLayer);
			circleLayer.addEventListener(MapDataEvent.MAP_DATA_TIP,layerShowTip);
		}
		protected function sendCircleData(centerPoint:Point,rectwidth:Number):void
		{
			var mes:Message=Message.buildMsg(CMD.MAP_DRAW_CIRCLE);
			mes.data={x:centerPoint.x,y:centerPoint.y,rectwidth:rectwidth};
			this.sendCommand(mes);
			
		}
		
		
		
		private function layerShowTip(e:MapDataEvent):void
		{
			this.hideLoding();
			e.target.removeEventListener(MapDataEvent.MAP_DATA_TIP,layerShowTip);
			var layer:CLDLayer=e.target as CLDLayer;
			if(layer){
				this.updateSingleLayer(layer);
				
			}
			if(e.mouseOverData!=""){
				this.showOverData(e.mouseOverData);
			}else
			{
				this.hideLoding();//mouseOverData 说明画图 加载数据失败  
			}
		}
		
		public function showLoding():void
		{
			if(!this.cldLoding){
				this.cldLoding=new CLDLoding();
				this.addChild(cldLoding);
//				cldLoding.x=this.width/2;
//				cldLoding.y=this.height/2;
			}
			cldLoding.setSize(this.width,this.height);
			this.setChildIndex(this.cldLoding,this.numChildren-1);
			this.cldLoding.visible=true;
		}
		public function hideLoding():void
		{
			if(this.cldLoding){
				this.cldLoding.visible=false;
			}
			
		}
		
		private function startLine(e:Event):void
		{
			this.dispatchEvent(e);
		}
		private function mapChange(e:MapEvent):void
		{
			var me:MapEvent=e.clone() as MapEvent;
			me.mapType=this.mapType+1;
			if(cm){
				cm.dispatchEvent(me);
			}
		}
		public function getTiteNum():Number
		{
			return cm.mapType();
		}
		//切换到第0个地图
		private function zeroHd(num:int):void
		{
			 var next:Object={};
			 var ocenter:Point=this.getCenter(); 
			 var ozoom=this.zoom;
			 if(this.mapType>1)//当前是否是2.5d地图
			 {
				 this.mapconfig.loadZoomConfig(next,num);//获取要切换的目标地图的配置信息
				 var nextmaxLevel=next.maxLevel;//获取要切换的目标地图的最大地图级别
				 var disZoom=this.mapconfig.maxLevel-ozoom;//当前2.5图最大级别减去当前级别 
				 ozoom=nextmaxLevel-disZoom;
				 
				
			 }
			 cm.setLocation(ocenter,ozoom,num);
				 
		}
		//切换到第1个地图
		private function firstHd(num:int):void
		{
			var next:Object={};
			var ocenter:Point=this.getCenter(); 
			var ozoom=this.zoom;
			if(this.mapType>1)//当前是否是2.5d地图
			{
				this.mapconfig.loadZoomConfig(next,num);//获取要切换的目标地图的配置信息
			   //Log.d(next);
				var nextmaxLevel=next.maxLevel;//获取要切换的目标地图的最大地图级别
				//Log.d("nextmaxLevel"+nextmaxLevel);
				var disZoom=this.mapconfig.maxLevel-ozoom;//当前2.5图最大级别减去当前级别 
				//Log.d("zoom"+ozoom);
				//Log.d("diszoom"+disZoom);
				//Log.d(this.mapconfig);
				ozoom=nextmaxLevel-disZoom;
				
				//Log.d("zoom"+ozoom);
			}
			cm.setLocation(ocenter,ozoom,num);
		}
		//切换到3维地图
		private function defaultHd(num:int):void
		{
			var next:Object={};
			var mtdata:Object=this.config.maptypeData;
			var ocenter:Point=mtdata.center;
			var ozoom:int=this.zoom;
			if(this.mapType<=1)//当前是否是平面图
			{  
				this.mapconfig.loadZoomConfig(next,num);//获取要切换的目标地图的配置信息
				Log.d(next);
				var nextmaxLevel=next.maxLevel;//获取要切换的目标地图的最大地图级别
				var disZoom=this.mapconfig.maxLevel-this.zoom;//当前平面图减去最大级别减去当前级别 
				Log.d(this.mapconfig);
				ozoom=nextmaxLevel-disZoom;//获取计算后的Zoom级别
				Log.d("ozoom"+ozoom);
				//throw new Error("error"+ozoom+":"+disZoom);
			}
			cm.setLocation(ocenter,ozoom,num);
		}
		//新增的地图切换
		private function cldMapChange(e:MapEvent):void
		{
			var num:Number=e.mapTileNum;
			switch(num)
			{
				case 0:zeroHd(num);break;
				case 1:firstHd(num);break;
				default:defaultHd(num);break;
			}
			
//			var item:Object=this.config.maptypeData;
//			if(e.isFirst)
//			{
//				try
//				{
//					//var item:Object=this.config.maptypeData;
//					if(cm)
//					{
//						cm.setLocation(item.center,item.zoom,item.tileMap);
//					}
//						
//					
//					//this.config.maptypeData={center:center,zoom:zoom,tileMap:tileMap};
//				}catch(e:Error)
//				{
//					
//				}
//			}else
//			{
//				this.setLocation(item.center,item.zoom,e.mapTileNum);
//			}
		}
		
		
		public function mapClearLayer(e:MapEvent):void
		{
			
			if(cm){
				cm.clearLayer();
				this.dispatchEvent(e);
				this.drawEnd();
				this.hideLoding();
			}
		}
		public function drawEnd():void
		{
			 this.config.dispatchEvent(new Event("drawEnd"));
		}
		
		private function showOverData(overData:String):void
		{
				mapOver.alpha=.1;
				Tweener.removeTweens(mapOver);
				mapOver.visible=true;
				this.setChildIndex(mapOver,this.numChildren-1);
				
				this.mapOver.data=overData;//用内容ID来承载内容
				
				var mapOverWidth:Number=mapOver.width;
				var mapOverHeight:Number=mapOver.height;
				
				Tweener.addTween(this.mapOver,{x:(this.width-mapOverWidth)/2,y:(this.height-mapOverHeight)/2,alpha:1,time:.5});
		}
		
		public function showOver(target:CLDBaseMarker,sx:Number,sy:Number):void
		{
			if(target.mouseOverData&&this.mapOver){
				//var lp:Point=this.globalToLocal(new Point(sx,sy));
				this.showOverData(target.mouseOverData);
				this.sendOverData(target.mouseOverData);
				
			}
			if(target.mouseClickData){
//				this.openMarkerWin(target.mouseClickData);
			}
			
		}
		/**
		 * 发送远程命令
		 * */
		private function sendOverData(mouseOverData:String):void
		{
			var mes:Message=Message.buildMsg(CMD.MAP_MARKER_CLICK);
			mes.data={mouseOverData:mouseOverData};
			this.sendCommand(mes);
		}
		
		public function clearLayer():void
		{
			if(cm){
				cm.clearLayer();
				
			}
			
			
		}
		public function set mouseEnb(value:Boolean):void
		{
			
			cm.contentEnabled=value;
		}
		override public function draw():void
		{
			super.draw();
			if(cm){
				cm.setSize(this.width,this.height);
				//mapControl.x=this.width-450;
				
			}
			if(this.cldLoding){
				this.cldLoding.setSize(this.width,this.height);
			}
			
			
			if(data&&this.dataChange){
				
				var datas:XMLList=XML(data).table[1].data;
				var length:int=datas.length();
				
				var dataLayer:CLDLayer=new CLDLayer();
				this.addLayer(dataLayer);
				for(var i:int=0;i<length;i++){
					var daxml:XML=datas[i];

					var dataType:String=daxml.@类型;
					
					switch(dataType){
						case "point": addMarkerwd(daxml,dataLayer);break;
						case "polyLine":addPolyLinewd(daxml,dataLayer);break;
						case "polygon":addPolygonwd(daxml,dataLayer);break;
					}
				}
				dataLayer.addEventListener(MapEvent.MapMouseOver,markerOver,true);
				dataLayer.addEventListener(MapEvent.MapMouseRightClick,markerRightClick,true);
				this.dataChange=false;
			}

			this.updateLayer();
		}
		public function updateLayer():void
		{
			if(cm){
				this.cm.updateLayer();
			}
			
		}
		
		public function updateSingleLayer(slayer:CLDLayer):void
		{
			if(cm){
				cm.updateSingleLayer(slayer);
			}
			
		}
		
		public function addLayer(cldLayer:CLDLayer):void
		{
			if(cm){
				this.cm.addLayer0(cldLayer);
			}
			
		}
		
		private function addMarkerwd(dt:XML,dataLayer:CLDLayer):void
		{
			var marker:CLDMarker=new CLDMarker();
			
			var pointstr:String=dt.@坐标;
//			
			var pointArr:Array=pointstr.split(",");
			
			marker.cldPoint=new Point(Number(pointArr[0]),Number(pointArr[1]));
			marker.pointType="image";
			
			marker.src=dt.@标注图片;
			marker.mouseOverData=dt.@鼠标经过数据;
			marker.mouseClickData=String(dt.@弹出窗信息);
			
			//marker.data=dt;
			//marker.cldPoint=new Point(dt.@经度,dt.@纬度);
			marker.winID=dt.@点击时窗体ID;
			marker.invalidate();
		
			dataLayer.addMarker(marker);

		}
		
	 
		
		
		public function addPolyLinewd(dt:XML,dataLayer:CLDLayer):void
		{
			var polyline:CLDPolyLine=new CLDPolyLine();
			var pointstr:String=dt.@坐标;
			
			var pointArr:Array=pointstr.split(";");
			for each(var str:String in pointArr){
				var sArr:Array=str.split(",");
			
				polyline.addPoint(new Point(Number(sArr[0]),Number(sArr[1])));
			}
			polyline.mouseOverData=dt.@鼠标经过数据;
			polyline.mouseClickData=dt.@弹出框信息;
			var color:String=dt.@线颜色;
			
			polyline.lineColor=parseInt("0x" + color.replace("#", ""));
			polyline.lineWidth=Number(dt.@线宽度);
			polyline.lineAlpha=Number(dt.@透明度)/100;
			polyline.invalidate();
			dataLayer.addLine(polyline);
			
			
			//polyline.change(center,this.width,this.height);
			
			
		}
		private function addPolygonwd(dt:XML,dataLayer:CLDLayer):void
		{
			var polygon:CLDPolygon=new CLDPolygon();
			var pointstr:String=dt.@坐标;
			
			var pointArr:Array=pointstr.split(";");
			for each(var str:String in pointArr){
				var sArr:Array=str.split(",");
			
				polygon.addPoint(new Point(Number(sArr[0]),Number(sArr[1])));
			}
			polygon.mouseOverData=dt.@鼠标经过数据;
			polygon.mouseClickData=dt.@弹出窗信息;
			var fillColor=StringUtils.get_colour(dt.@面填充颜色);
			polygon.bgColor=fillColor;
			//polygon.bgColor=String(dt.@面填充颜色).join
			
			dataLayer.addgon(polygon);
			polygon.invalidate();
			
			
		}
		protected function markerOver(e:MapEvent):void
		{
			var target:CLDBaseMarker=e.target as CLDBaseMarker;
			if(target){
				this.showOver(target,e.stageX,e.stageY);
			}
			
		}
		protected function markerRightClick(e:MapEvent):void
		{
			var target:CLDBaseMarker=e.target as CLDBaseMarker;
			if(target&&target.mouseClickData!=""){
				openMarkerWin(target.mouseClickData);
			}
			
		}
		private function openMarkerWin(mouseClickData:String):void
		{
			
			var cld:CLDEvent=new CLDEvent(CLDEvent.ALERTWIN);
			cld.mouseClickData=mouseClickData;
			this.config.dispatchEvent(cld);
			
		} 
		
		override public function pause():void
		{
			if(cm){
				this.cm.pause();
			}
			
		}
		override public function startRender():void
		{
			if(cm)
				this.cm.startRender();	
		}
	 
		
		
		
		
		
		
		
	}
}