package com.careland
{
	import __AS3__.vec.Vector;
	
	import com.careland.events.MapEvent;
	import com.careland.layer.CLDLayer;
	import com.careland.util.CLDConfig;
	import com.careland.util.CLDZoom;
	import com.careland.util.MapConfig;
	import com.touchlib.TUIOEvent;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Graphics;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.net.FileReference;
	
	import sinaappp.wwyx.PNGEncoder;
	
	
	
	
	public class CLDMapContainer extends Base
	{
		protected var content:Sprite;
		private var contentmask:Sprite;
		protected var config:CLDConfig;
//		private var DZloadImg:Array=[];
//		private var YXloadImg:Array=[];//应该加载哪些图片
		
		
		//用两个数组来存放已经加载的图片
//		private var ydLoadedImg:Array=[];//已经加载图片
//		private var preYdLoadedImg:Array=[];//已经加载图片数组
		
		
		
		private var mapLayer:Sprite;//保存mapdata xml中layer的数据
		private var mapLayerArr:Array=[];
		
		
		//protected var center:Point=new Point(0,0);//中心点
		
		protected var newCenter:Point=new Point(0,0);
		
		private var resize:Boolean=false;
		
		protected var prePoint:Point=new Point(0,0);//点击时的按钮

		private var YZmap:MapContent;
		
		private var zoomEffect:CLDZoom;
		
	
		protected var layer:CLDLayer;
		
		private var layers:Vector.<CLDLayer>=new Vector.<CLDLayer>();
		
		protected var mapConfig:MapConfig;
		
		private var uniqueID:String;
		
		
		private var isScale:Boolean=false;//是否两只手指放大过
		
		protected var firstPoint:Point=new Point(0,0);
		
		private var isZoomChange:Boolean=false;//zoom是否改变过
		private var isCenterChange:Boolean=false;//中心点是否改变过 
		private var isTileChange:Boolean=false;//地图类型是否改变过 
		
		public function CLDMapContainer(config:CLDConfig,center:Point,zoom:int)
		{
			super();
			this.config=config;
			this.center=center;
			//this.newCenter=center;
			
			mapConfig=new MapConfig(config.configXML);
			this.zoom=zoom;
			mapConfig.init();
			mapConfig.center=newCenter;
			uniqueID=Math.random()+"";
			
			initMapLayer();//初始华地图上的图层
			
			this.addEventListener(MapEvent.MapChange,mapChange);
			
			
		}
		
		public function set zoom(v:int):void
		{
			if(this.zoom!=v)
			{
				this.mapConfig.vzoom=v;
				this.isZoomChange=true;
				this.invalidate();
			}
			
		}
		public function get zoom():int
		{
			return this.mapConfig.vzoom;
		}
		public function get center():Point
		{
			return this.newCenter;
		}
		public function set center(value:Point):void
		{
			 if(value&&value.x!=center.x||value.y!=center.y)
			 {
				 this.newCenter=value;
				 this.isCenterChange=true;
				 this.invalidate();
			 }
		}
		public function get tilemapindex():int
		{
			return mapType();
		}
		public function set tilemapindex(value:int):void
		{
			if(value!=this.tilemapindex)
			{
				this.mapConfig.tilemapindex=value;
				this.isTileChange=true;
				this.invalidate();
			}
		}
		
		
		
		public function mapType():int
		{
			return this.mapConfig.tilemapindex;
		}
		public function startRender():void
		{
			
		}
		public function setLocation(center:Point,zoom:int,tileMap:int):void
		{
			this.center=center;
			this.zoom=zoom;
			this.tilemapindex=tileMap;
			
//			mapConfig.tilemapindex=tileMap;
//			mapConfig.vzoom=zoom;  
//
//			if(center){
//				this.newCenter=center;
//			}
//			this.loadMapPic(this.newCenter);
//			this.updateLayer();
		}
		public function setCenterAndZoom(center:Point,zoom:int)
		{
			this.center=center;  
			this.zoom=zoom;
//			mapConfig.vzoom=zoom;
//			if(center){
//				this.newCenter=center;
//			}
//			this.loadMapPic(this.newCenter);
//			this.updateLayer();
		}
		
//		public function setCenter(center:Point):void
//		{
//			if(center){
//				this.newCenter=center;
//			}
//			this.invalidate();
//		}
//		
//		public function getCenter():Point
//		{
//			return this.newCenter;
//		}
		
	
		//属性更改后的事件
		override protected function commitPropties():void
		{
			if(this.isCenterChange||this.isZoomChange||this.isTileChange)
			{
				var se:MapEvent=new MapEvent(MapEvent.MapLocationChange);
				se.zoom=this.zoom;
				se.center=this.center;
				se.mapType=this.tilemapindex;
				this.dispatchEvent(se); 
				this.LoadMap(this.isZoomChange||this.isTileChange);
				this.isCenterChange=this.isZoomChange=this.isTileChange=false;
			}
			
		}
		
		
		protected function mapChange(e:MapEvent):void
		{
			this.mapConfig.tilemapindex=e.mapType;
			while(this.mapLayer.numChildren>0)this.mapLayer.removeChildAt(0);
			mapLayerArr.splice(0,mapLayerArr.length);
			initMapLayer();
		}
		
		private function initMapLayer():void
		{
//			var layerTemp:Array=[];
//				for(var i:int=0;i<this.mapConfig.layers.length;i++){
//					
//					var layerSp:MapContent=new MapContent();
//					layerSp.data=this.mapConfig.layers[i];
//					this.mapLayer.addChild(layerSp);
//					layerTemp.push(layerSp);
//				}
//				//设置到数据 制定的index
//				for(var j:int=0;j<layerTemp.length;j++){
//					mapLayer.setChildIndex(layerTemp[j],layerTemp[j].data.show);
//				}
//				mapLayerArr=layerTemp;
		}
		
		
		private var file:FileReference;
	    override protected function addChildren():void
		{
			if(!content){
				content=new Sprite;
				
				//DZmap=new MapContent;
				YZmap=new MapContent;  
				
//				YZmap.visible=false;
				
				//content.addChild(DZmap);
				
				content.addChild(YZmap);
				
				mapLayer=new Sprite;
				
				content.addChild(mapLayer);
				
				this.addChild(content);
			}
			if(!contentmask){
				contentmask=new Sprite;
				this.addChild(contentmask);
			}
			//content.doubleClickEnabled=true;
			this.mask=this.contentmask;
//			this.addEventListener(MouseEvent.MOUSE_DOWN,downHandler);
			
//     		this.addEventListener(MouseEvent.MOUSE_DOWN,testCenter0);
		//	this.addEventListener(TUIOEvent.TUIO_DOWN,touchDown);//触控需要
			if(stage)
			{
				//this.addEventListener(MouseEvent,testCenter0);
			}
			
		
		}
		   
		private function testCenter(e:MouseEvent):void
		{
			trace(this.newCenter.x+":"+this.newCenter.y);
		}
		private function testCenter0(e:MouseEvent):void
		{
			 file=new FileReference();    
			// file.addEventListener(Event.SELECT,select);
			 var bit:BitmapData=new BitmapData(this.width,this.height,true,0x00);
			 bit.draw(this);
			 file.save(PNGEncoder.encode(bit),"img.png");
		}
		private function select(e:Event):void
		{
			      
		}
		
		public function set tuioEnabled(value:Boolean):void
		{
			
			
		}
			
		
		private function touchDown(e:TUIOEvent):void
		{
		//	this.prePoint=new Point(e.stageX,e.stageY);
			trace("touchDown");
		}
		
		//获取新的中心点位置指定级别
		protected function getCenterByPoint(mousePoint:Point,toZoom:int):Point
		{
			
			var mapPoint:Point=toMapPoint(mousePoint);
			var curpoint:Object = config.getMapPoint(mapPoint.x,mapPoint.y,new Point(mousePoint.x, mousePoint.y),width,height, toZoom,this.mapConfig);
			var np:Point = new Point(curpoint.x, curpoint.y);
			return mapPoint;
//			return np;
		}
		
		public function toMapPoint(screenPoint:Point):Point
		{
			return this.config.toMapPoint(screenPoint.x,screenPoint.y,this.width,this.height,this.newCenter,this.mapConfig);
		}
		
		
		public function set contentEnabled(value:Boolean):void
		{
			if(value){
				this.addEventListener(MouseEvent.MOUSE_DOWN,downHandler);
				content.addEventListener(MouseEvent.MOUSE_WHEEL,zoomHanler);
				
			}else {
				this.removeEventListener(MouseEvent.MOUSE_DOWN,downHandler);
				this.removeEventListener(MouseEvent.MOUSE_MOVE,moveHandler);
				this.removeEventListener(MouseEvent.MOUSE_UP,upHandler);
				content.removeEventListener(MouseEvent.MOUSE_WHEEL,zoomHanler);
			}
		}
		
		public function addLayer(vname:String):CLDLayer
		{
			layer=new CLDLayer();
			layer.name=vname;
			
			layer.addEventListener(MapEvent.MapAddLayer,maponAddLayer);
			content.addChild(layer);
			this.layers.push(layer);
			return layer;
		}
		public function addLayer0(vl:CLDLayer):CLDLayer
		{
			content.addChild(vl);
			vl.addEventListener(MapEvent.MapAddLayer,maponAddLayer);
			this.layers.push(vl);
			return vl;
		}
		protected function maponAddLayer(e:MapEvent):void
		{
			var ly:CLDLayer=e.target as CLDLayer;
			if(ly){
				var gl:Point=this.localToGlobal(new Point(this.x,this.y));
				ly.update(this.newCenter,this.mapConfig.scale,this.width,this.height,gl,this.mapConfig);
			}
		}
		
		
		protected function downHandler(e:MouseEvent):void
		{

			this.prePoint=new Point(e.stageX,e.stageY);
			firstPoint=new Point(content.x,content.y);

			this.addEventListener(MouseEvent.MOUSE_MOVE,moveHandler);
			this.addEventListener(MouseEvent.MOUSE_UP,upHandler);
			
		}
		protected function moveHandler(e:MouseEvent):void
		{
			
			var newPoint:Point=new Point(e.stageX,e.stageY);
			var disPoint:Point=newPoint.subtract(prePoint);
			this.content.x+=disPoint.x;
			this.content.y+=disPoint.y;
			this.prePoint=newPoint;
			
			
		}
	
		
		protected function canMoveLeft(newCenter:Point):Boolean
		{
			//判断右边 (是否可向左拖动)
				if(newCenter.x>=Number(this.mapConfig.x+this.mapConfig.width-this.width/2*this.mapConfig.scale)){
					return false;
				}
				return true;
		}
		protected function canMoveRight(newCenter:Point):Boolean
		{
			//判断左边 是否 可拖动 过去 （是否可向右拖动 ）
				if(newCenter.x<=Number(this.mapConfig.x+this.width/2*this.mapConfig.scale)){
					return false;
				}	
				return true;
		}
		
		private function canMoveTop(newCenter:Point):Boolean
		{
				
				//判断是否可向上拖动
				if(newCenter.y<=Number(this.mapConfig.y-this.mapConfig.height+this.height/2*this.mapConfig.scale)){
					return false;
				}
				return true;	
		}
		protected function canMoveBottom(newCenter:Point):Boolean
		{
			//判断是否可向下拖动
				if(newCenter.y>=Number(this.mapConfig.y-this.height/2*this.mapConfig.scale)){
					return false;
				}
				return true;
				
		}
		
		public function clearLayer():void
		{
			for each(var layer:CLDLayer in this.layers){
				layer.dispose();
				content.removeChild(layer);
			}
			layers.splice(0,layers.length);
		}
			
				
		
		
		protected function upHandler_old(e:MouseEvent):void
		{
			this.removeEventListener(MouseEvent.MOUSE_MOVE,moveHandler);
			this.removeEventListener(MouseEvent.MOUSE_UP,upHandler);
			
			
			var newPoint:Point=new Point(content.x,content.y);
			
			var disPoint:Point=newPoint.subtract(this.firstPoint);
			
			
			var disXStr:String=(disPoint.x*this.mapConfig.scale).toFixed(20);
			var disX:Number=Number(disXStr);
			
			var disYStr:String=(disPoint.y*this.mapConfig.scale).toFixed(20);
			var disY:Number=Number(disYStr);
			
			newCenter=center;
			var nextx:Number=newCenter.x-disX;
			var nexty:Number=newCenter.y+disY;
			
			newCenter.x=nextx;
			newCenter.y=nexty;
			loadMapPic(newCenter);
			
			if(this.layer){
				updateLayer();
			}
		}
		protected function upHandler(e:MouseEvent=null):void
		{
			
			
			this.removeEventListener(MouseEvent.MOUSE_MOVE,moveHandler);
			this.removeEventListener(MouseEvent.MOUSE_UP,upHandler);
			
			
			var newPoint:Point=new Point(content.x,content.y);
			
			var disPoint:Point=newPoint.subtract(this.firstPoint);

			var screenPoint:Point=this.config.toScreenPoint(this.newCenter.x,this.newCenter.y,width,height,this.mapConfig.scale,newCenter.x,newCenter.y,this.mapConfig.tilemapindex,this.mapConfig.wscale,this.mapConfig.hscale);
			var newPoint:Point=new Point;
			newPoint.x=screenPoint.x-disPoint.x;
			newPoint.y=screenPoint.y-disPoint.y;
			var np:Point=config.toMapPoint(newPoint.x,newPoint.y,this.width,this.height,this.newCenter,this.mapConfig);
			
			this.center=np;
//			
//			loadMapPic(np);
//			updateLayer();
		
		}
		
		
		private function zoomHanler(e:MouseEvent):void
		{
			
			var temp:int=this.zoom;
			if(e.delta>0){
				temp++;
			}else{
				temp--;
			}
			if(this.mapConfig.canZoom(temp)){
				var bit:Bitmap=this.drawCurrent();
				this.addChild(bit);
				var change:Boolean=true;
				
				zoomEffect=new CLDZoom(bit);
				this.addChild(zoomEffect);
				zoomEffect.addEventListener("zoomEnd",effectend);
				zoomEffect.play(this.mouseX,this.mouseY,e.delta);
				this.addChild(zoomEffect);
				this.mapConfig.vzoom=temp;
				this.loadMapPic(this.newCenter,true);
				//加载
				
				updateLayer();
				
			}
		}
		
		public function updateLayer():void
		{
			var gl:Point=this.localToGlobal(new Point(this.x,this.y));
			for each(var sl:CLDLayer in layers){
				sl.update(this.newCenter,this.mapConfig.scale,this.width,this.height,gl,this.mapConfig);
			}
		}
		public function updateSingleLayer(ly:CLDLayer):void
		{
			var gl:Point=this.localToGlobal(new Point(this.x,this.y));
			ly.update(this.newCenter,this.mapConfig.scale,this.width,this.height,gl,this.mapConfig);
			
		}
		
		private function effectend(e:Event):void
		{
			this.removeChild(zoomEffect);
		}
		
	    override public function draw():void
		{
			if(this.contentmask){
				var g:Graphics=this.contentmask.graphics;
				g.clear();
				g.beginFill(0x000000,1);
				g.drawRect(0,0,this.width,this.height);
				g.endFill();
				//loadMapPic();
			}
			
			   var g1:Graphics=this.graphics;
				g1.clear();
				g1.beginFill(0x000000,0);
				g1.drawRect(0,0,this.width,this.height);
				g1.endFill();
			
			
			
		}
		public function get mapconfig():MapConfig
		{
			return this.mapConfig;
		}
		
		public function mapCenterFix(newCenter:Point):Point
		{
		    newCenter=this.config.setMapCenterPoint(newCenter,this.mapConfig,this.width,this.height);
			return newCenter;
		}
		
		public function LoadMap(remAll:Boolean=false):void
		{
			this.loadMapPic(this.center,remAll);
			this.updateLayer();
		}
		
		
		public function loadMapPic(nc:Point=null,remAll:Boolean=false):void
		{
			var cp:Point=this.newCenter;
			if(nc){
				cp=nc;
			}
			this.mapConfig.center=cp;
//			trace(cp.x+"vvvvvv"+cp.y);
			cp=mapCenterFix(cp);
			
			
			
			this.loadYXmap(cp,true);
			
			for(var i:int=0;i<this.mapLayerArr.length;i++){
				
				var layerContent:MapContent=this.mapLayerArr[i];
				this.loadLayer(cp,layerContent,true);
			}

		}
		
		
		
		private function loadYXmap(cp:Point,remAll:Boolean):void
		{
			//YXloadImg=this.config.createCLDMaping(this.mapConfig,cp,this.width,this.height);
			var YXloadImg:Array=this.config.getMapImages(this.mapConfig,cp,this.width,this.height,this.mapConfig.tilemapindex);
			loadPic(YXloadImg,this.mapConfig.dataPath,null,YZmap,content.x,content.y,remAll);
		}
		
		
		private function loadLayer(cp:Point,layerContent:MapContent,remAll:Boolean=true):void
		{
			var loadImg:Array=this.config.getMapImages(this.mapConfig,cp,this.width,this.height,this.mapConfig.tilemapindex);
			//var loadImg:Array=this.config.createCLDMaping(this.mapConfig,cp,this.width,this.height);
			this.loadPic(loadImg,layerContent.data.url,null,layerContent,content.x,content.y,remAll);
		}
		
		
	 	public function drawCurrent():Bitmap
		{
			var bit:Bitmap=new Bitmap();
			
			try{
				var bitdata:BitmapData=new BitmapData(this.width, this.height, true, 0xffffff);
				bitdata.draw(this, null, null, null, new Rectangle(0, 0, this.width, this.height), true);
				bit.bitmapData=bitdata;
			}catch(e:Error){
				   
			}
			
			return bit;
		}
		public function pause():void
		{
			
		}
		
		override public function dispose():void
		{
			this.pause();
			
			if(this.YZmap)YZmap.dispose();
			this.clearLayer();
			this.graphics.clear();
//			this.center=null;
			this.newCenter=null;
			this.prePoint=null;
			this.mapConfig=null;
			this.layers=null;
			if(this.contentmask){
				contentmask.graphics.clear();
			}
			if(content){
				while(content.numChildren>0) content.removeChildAt(0);
			}
			
			
			super.dispose();
		}
		 
		
		//加载图片
		public function loadPic(pics:Array,path:String,loaded:Array=null,parent:MapContent=null,
			disx:Number=0,disy:Number=0,remAll:Boolean=true):void
		{
			//this.dispose();
			
			var newLoaded:Array=[];
			for each(var obj:Object in pics){
					var item:imgItem=this.getImg(obj.id,loaded);
						var img:imgItem=new imgItem(obj,path+obj.src);
						img.load();
						if(parent){
							parent.addContent(img);
						}
						img.x=obj.x-disx;
						img.y=obj.y-disy;
						newLoaded.push(img);
					
			}
			parent.isLayer1=!parent.isLayer1;
			// touch
			if(remAll){
						parent.update();
					}
			for each(var img0:imgItem in newLoaded){
				if(img0&&!img0.isLoad){
					//img0.addEventListener(Event.COMPLETE,imgComplete);
					img0.load();
				}
			}
//			function imgComplete(e:Event):void
//			{
//				e.target.removeEventListener(Event.COMPLETE,imgComplete);
//				var index:int=0;
//				for each(var img:imgItem in newLoaded){
//					if(img.isLoad){
//						index++;
//					}
//				}
//				if(index==newLoaded.length){
//					//鼠标
////					if(remAll){
////						parent.update();
////					}
//					
//					//dispatchEvent(new Event("imgLoaded"));
//					
//			
//					
//				}
//			}
//			
			
			
			//this.dispose(saveLoaded,parent);
			


		}
		
		
		public function getImg(id:String,loaded:Array):imgItem
		{
			for each(var item:imgItem in loaded){
				try{
					if(item.info.id==id){
						return item.clone();
					}
				}catch(e:Error){
					
				}
				
			}
			return null;
		}
		
		
	}
}
import flash.events.EventDispatcher;
	import flash.net.URLRequest;
	import flash.net.URLLoader;
	import flash.events.Event;
	import flash.display.Loader;
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.events.IOErrorEvent;
	import flash.display.BitmapData;
	
	import __AS3__.vec.Vector;
	
[Event(name="complete",type="flash.events.Event")]
class imgItem extends Sprite{
	public var info:Object;
	public var urlLoader:Loader=new Loader();
	public var urlstr:String;
	public var content:Bitmap; 
	public var isLoad:Boolean=false;
	public function imgItem(i:Object,u:String){
		this.info=i;
		this.urlstr=u;
		
		
	}
	public function load():void
	{
		urlLoader.contentLoaderInfo.addEventListener(Event.COMPLETE,complete);
		urlLoader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR,ioError);
		urlLoader.load(new URLRequest(urlstr));
	}
	public function complete(e:Event):void
	{
		urlLoader.contentLoaderInfo.removeEventListener(Event.COMPLETE,complete);
		urlLoader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR,ioError);
		this.content=e.target.content as Bitmap;
		this.content=new Bitmap(content.bitmapData);
		this.addChild(content);
		isLoad=true;
		this.dispatchEvent(e);
	}
	private function ioError(e:Event):void
	{
		urlLoader.contentLoaderInfo.removeEventListener(Event.COMPLETE,complete);
		urlLoader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR,ioError);
		var bit:BitmapData=new BitmapData(256,256,false,0xffffff);
		content=new Bitmap(bit);
		this.addChild(content);
	}
	
	public function clone():imgItem
	{
		var img:imgItem=new imgItem(this.info,this.urlstr);
		img.content=new Bitmap(this.content.bitmapData);
		img.isLoad=this.isLoad;
		return img;
	}
	
	public function dispose():void
	{
		
		if(content){
			content.bitmapData.dispose();
			this.removeChild(content);
		}
		
		this.urlLoader.unload();
		this.content=null;
		this.info=null;
		this.urlstr=null;
	}
	
}