package com.careland.util
{
	import flash.events.EventDispatcher;
	import flash.geom.Point;
	/**
	 * @private
	 * */
	public dynamic class MapConfig 
	{
		
//		
//		李育贵  15:49:45
//viewAY viewAX，这是左上角的x,y
//李育贵  15:49:58
//viewBX viewBY，这是右下角的x,y
		
//		<x>-20037508.342789244</x>
//					<y>20037508.342789244</y>
//					<width>40075016.685578488</width>
//					<height>40075016.685578488</height>
//					<pixelWidth>256</pixelWidth>
//					<pixelHeight>256</pixelHeight>
//					<wScale>156543.03392804096875</wScale>
//					<hScale>156543.03392804096875</hScale>
//					<scale>20000000</scale>
//					<showscale>20000000</showscale>
//					<imageFormat>gif</imageFormat>
//					<imageWidth>256</imageWidth>
//					<imageHeight>256</imageHeight>
//					<maxFilesPerFolder>256</maxFilesPerFolder>
		
		/**地图配置文件start***/
		public var x:Number;
		public var y:Number;
		public var width:Number;
		public var height:Number;
		public var pixelWidth:Number;
		public var pixelHeight:Number;
		public var wscale:Number;
		public var hscale:Number;
		public var scale:Number;
		public var showscale:Number;
		public var ImageFormat:String="png";
		public var ImageWidth:Number=256;
		public var ImageHeight:Number=256;
		public var MaxFilesPerFolder:int;
		
		/**地图配置文件end***/
		public var dataPath:String;//数据路径
		
		
		
	
		
	
		//地图宽高
		public var mapWidth:Number;
		public var mapHeight:Number;
		
		
		
		public var minLevel:int=4; 
		public var maxLevel:int=18;
		//地图各个级别
		public var mapZooms:XMLList;
		//配置文件
		public var configXML:XML;
		
		public var dzConfig:Object;
	
		//地图中心点
		public var _center:Point;
		//地图缩放级别
		private var _zoom:int=4;
		
		public var globalPoint:Point;//当前地图的全局坐标
		
		
		public function setSize(w:Number,h:Number):void
		{
			this.mapWidth=w;
			this.mapHeight=h;	
		}
		
		public function MapConfig(configXML:XML)
		{
			this.configXML=configXML;	
			loadZoomConfig(0);
		}
		public function set center(value:Point):void
		{
			this._center=value;
		}
		public function get center():Point
		{
			return this._center;
		}
		public function get zoom():int
		{
			return this._zoom;
		}
		public function canZoom(v:int):Boolean
		{
			if(v>maxLevel||v<this.minLevel){
				return false;
			}
			return true;
		}
		
		
		public function set zoom(v:int):void
		{
			if(v>=this.maxLevel){
				v=maxLevel;
			}
			if(v<this.minLevel){
				v=minLevel;
			}
			_zoom=v;
			setMapConfig(this,v);//设置DZ配置
			//setMapConfig(this.dzConfig,1,v);//设置YX配置
		}
		public function set zoomOverView(v:int):void
		{
			if(v<=1)
			{
				v=1;
			}
			if(v>=this.maxLevel){
				v=maxLevel;
			}
			_zoom=v;
			setMapConfig(this,v);
		}
		
		//根据级别获取config;
		public function getZoomConfig(zoom:int):Object
		{
			var obj:Object={};
			//obj.mapWidth=this.mapWidth;
			//obj.mapHeight=this.mapHeight;
			this.setMapConfig(obj,zoom);
			return obj;
		}
		
		public function init():void
		{
			
			//this.setMapConfig(this,this.vzoom);
		}
		private function loadZoomConfig(num:int):void
		{
			var mapdata:XML=configXML.mapdatas.children()[num];
			dataPath=mapdata.datapath;
			minLevel=mapdata.minzoom;
			maxLevel=mapdata.maxzoom;
			mapZooms=mapdata.mapZooms.children();
//			
		}
		
//		<x>-20037508.342789244</x>
//					<y>20037508.342789244</y>
//					<width>40075016.685578488</width>
//					<height>40075016.685578488</height>
//					<pixelWidth>256</pixelWidth>
//					<pixelHeight>256</pixelHeight>
//					<wScale>156543.03392804096875</wScale>
//					<hScale>156543.03392804096875</hScale>
//					<scale>20000000</scale>
//					<showscale>20000000</showscale>
//					<imageFormat>gif</imageFormat>
//					<imageWidth>256</imageWidth>
//					<imageHeight>256</imageHeight>
//					<maxFilesPerFolder>256</maxFilesPerFolder>
		private function setMapConfig(cf:Object,v:int):void
		{
			var zoomXML:XML=mapZooms[v];
			cf.x=zoomXML.x;
			cf.y=zoomXML.y;
			cf.width=zoomXML.width;
			cf.height=zoomXML.height;
			cf.pixelwidth=zoomXML.pixelWidth;
			cf.pixelheight=zoomXML.pixelHeight;
			
			var scaleStr:String=Number(zoomXML.scale).toFixed(20);
			cf.scale=Number(scaleStr);
			cf.wscale=Number(Number(zoomXML.wScale).toFixed(20));
			cf.hscale=Number(Number(zoomXML.hScale).toFixed(20));
			cf.showscale=Number(Number(zoomXML.showscale).toFixed(20));

			cf.ImageFormat=zoomXML.imageFormat;
			cf.ImageWidth=zoomXML.imageWidth;
			cf.ImageHeight=zoomXML.imageHeight;
			cf.MaxFilesPerFolder=zoomXML.maxFilesPerFolder;

			//cf.viewBY=cf.y-cf.height;
		}
		
		
		//old
		private function setMapConfig0(cf:Object,num:int,v:int):void
		{
			var mapdata:XML=configXML.mapdatas.children()[num];
			dataPath=mapdata.datapath;
			minLevel=mapdata.minzoom;
			maxLevel=mapdata.maxzoom;
			mapZooms=mapdata.mapZooms.children();
		
			
			var xmllayers:XMLList=mapdata.layers.children();
			
			
			for(var i:int=0;i<xmllayers.length();i++){
				
				var xmlLayer:XML=xmllayers[i];
				var layer:Object=new Object;
				layer.show=xmlLayer.show;
				layer.name=xmlLayer.name;
				layer.url=xmlLayer.url;
				layer.minzoom=xmlLayer.minzoom;
				layer.maxzoom=xmlLayer.maxzoom;
				layer.showineye=xmlLayer.showineye;
				//layers.push(layer);
				
			}
			
			
			
			var zoomXML:XML=mapZooms[v];
			cf.x=zoomXML.x;
			cf.y=zoomXML.y;
			cf.width=zoomXML.width;
			cf.height=zoomXML.height;
			
			
			var str:String=Number(zoomXML.scale).toFixed(20);
			
			cf.wscale=Number(zoomXML.wScale).toFixed(20);
			cf.hscale=Number(zoomXML.hScale).toFixed(20);
			
			cf.scale=Number(str);
			cf.ImageFormat=zoomXML.imageFormat;
			cf.ImageWidth=zoomXML.imageWidth;
			cf.ImageHeight=zoomXML.imageHeight;
			cf.zoom=v;
			//
			var levelList:XMLList=zoomXML.levelParam;
			var levelArr:Array=[];
			if(levelList.children().length()>0){
				for(var j:int=0;j<levelList.length();j++){
					
					levelArr.push(int(levelList[j].level));
				}
			}
			cf.LevelParam=[];
			cf.LevelParam=levelArr;
			cf.MaxFilesPerFolder=zoomXML.maxFilesPerFolder;
			cf.MapFolder=zoomXML.mapFolder;
			cf.viewBY=cf.y-cf.height; //右下角y
			cf.viewBX=cf.x+cf.width; //右下角x
			cf.viewAX=cf.x;//坐上角x
			cf.viewAY=cf.y;//左上角y;
			
		}
		
		
		
		

	}
}