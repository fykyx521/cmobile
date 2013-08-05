package com.identity
{
	import caurina.transitions.Tweener;
	
	import com.careland.CLDTouchMapContainer;
	import com.careland.component.CLDBaseComponent;
	import com.careland.component.util.CLDLoding;
	import com.careland.component.win.CLDMapOverWin;
	import com.careland.event.CLDEvent;
	import com.careland.event.RowEvent;
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
	
	import mx.events.DynamicEvent;
	
	import uk.co.teethgrinder.string.StringUtils; 

	public class CLDMap extends CLDBaseComponent
	{
		
		private var content:CLDBaseComponent;
		private var blobs:Array=[];				
		
//		protected var center:Point=new Point(114.05979, 22.543586);
//		protected var center:Point=new Point(114.2032409, 22.70870111);
		protected var center:Point=new Point(114.28507119626678,22.676707189699183);
		
		protected var cm:CLDTouchMapContainer;		
		protected var layer:CLDLayer;
 
		private var vzoom:int=1;	
 
		protected var mapControl:CLDMapControl;
		
		private var mapOver:CLDMapOverWin;
		
		
		private var isDrawState:Boolean=false;
		
		private var circleSprite:CLDCircleSprite;
		
		private var rectSprite:CLDRectSprite;
		
		private var mutirectSprite:CLDRectSprite;
		
		private var cldLoding:CLDLoding;
		
		public function CLDMap(parent:DisplayObjectContainer=null, xpos:Number=0, ypos:Number=0, autoLoad:Boolean=false, timeInteval:int=0)
		{
			super(parent, xpos, ypos, autoLoad, timeInteval);
			
		}
		override protected function addChildren():void
		{
			layer=new CLDLayer();
			mapControl=new CLDMapControl();
			mapOver=new CLDMapOverWin();
			loadConfig();
		}	
		private function loadConfig():void
		{
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
			cm._center=value;
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
		
		
		private function configLoaded(e:Event=null):void
		{			
			cm=new CLDTouchMapContainer(CLDConfig.instance(),center,vzoom);
			cm.setSize(this.width,this.height);
			
			if(center){
				cm.loadMapPic();
			}
			layer=cm.addLayer("mainLayer");
			this.addChild(cm);			
			this.addChild(this.mapControl);
			this.addChild(this.mapOver);
			mapControl.addEventListener("drawCircle",this.drawCircle);
			mapControl.addEventListener("drawMutiRect",this.drawMutiRect);
			mapControl.addEventListener("drawRect",this.drawRect);
//			mapControl.addEventListener("startLine",startLine);
			mapControl.addEventListener(MapEvent.MapClearLayer,mapClearLayer);
			
			cm.contentEnabled=false;
			
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
//			var cldLocation:CLDLpLayer=new CLDLpLayer();
//			
//			if(e.ifLoad)
//			{
//				
//			}else
//			{
//				
//			}
//			var source:String=e.value;
//			cldLocation.url=source;
//			cldLocation.load();
//			this.addLayer(cldLocation);
		}
		
		
		public function setLocation(center:Point,zoom:int,tileMap:int):void
		{
			if(cm)cm.setLocation(center,zoom,tileMap);
			
		}
		public function setCenter(center:Point):void
		{
			if(cm)cm.setCenter(center);
		}
		private function drawMutiRect(e:Event):void
		{
			if(!isDrawState)
			{
				isDrawState=true;
				this.mutirectSprite=new CLDMutiRectSprite;
				this.addChild(mutirectSprite);
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
				
				var mutiLayer:CLDMutiRectLayer=new CLDMutiRectLayer();
				mutiLayer.points=e.points;
				this.showLoding();
				mutiLayer.initData(this.mapconfig.center,width,height,this.mapconfig);
				this.addLayer(mutiLayer);
				this.updateSingleLayer(mutiLayer);
				mutiLayer.addEventListener(MapDataEvent.MAP_DATA_TIP,layerShowTip);
				this.removeChild(mutirectSprite);
				mutirectSprite.dispose();
				mutirectSprite=null;
				isDrawState=false;
				
			}
			
		}
		//
		private var isRectState:Boolean=false;
		private function drawRect(e:Event):void
		{
			if(!isDrawState)
			{
				isDrawState=true;
				this.rectSprite=new CLDRectSprite;
				rectSprite.mapconfig=this.mapconfig;
				this.addChild(rectSprite);
				this.setChildIndex(rectSprite,this.numChildren-1);
				rectSprite.setSize(this.width,this.height);
				
				rectSprite.addEventListener(MapDataEvent.MAP_RECT_DATA,rectData);
				
			}
		}
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
					var layer:CLDRectLayer=new CLDRectLayer();
					layer.sourcePoint=e.sourcepoint;
					layer.toPoint=e.toPoint;
					this.showLoding();
					layer.initData(this.mapconfig.center,this.width,this.height,this.mapconfig);
					layer.addEventListener(MapDataEvent.MAP_DATA_TIP,layerShowTip);
					this.addLayer(layer);
					this.updateSingleLayer(layer);
					this.removeChild(rectSprite);
					rectSprite.dispose();
					rectSprite=null;
					isDrawState=false;
				}
				this.isDrawState=false;
			}
			
		}
		
		private function drawCircle(e:Event):void
		{
			if(!isDrawState){
				
				isDrawState=true;
				circleSprite=new CLDCircleSprite;
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
			var circleLayer:CLDCircleLayer=new CLDCircleLayer();
			circleLayer.screenPoint=centerPoint;
			circleLayer._radius=rect.width/2;
			this.showLoding();
			circleLayer.initData(this.mapconfig.center,this.width,this.height,mapconfig);
			this.addLayer(circleLayer);
			this.updateSingleLayer(circleLayer);
			
			circleLayer.addEventListener(MapDataEvent.MAP_DATA_TIP,layerShowTip);
			this.removeChild(circleSprite);
			circleSprite.dispose();
			circleSprite=null;
			isDrawState=false;
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
		public function mapClearLayer(e:MapEvent):void
		{
			if(cm){
				cm.clearLayer();
				this.dispatchEvent(e);
			}
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
				
				
			}
			if(target.mouseClickData){
//				this.openMarkerWin(target.mouseClickData);
			}
			
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
				mapControl.x=this.width-450;
				
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