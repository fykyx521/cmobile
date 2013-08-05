package com.careland.util
{
	import flash.geom.Point;
	public class MapConfig
	{
		
//		
//		李育贵  15:49:45
//viewAY viewAX，这是左上角的x,y
//李育贵  15:49:58
//viewBX viewBY，这是右下角的x,y
		
		public var x:Number;
		public var y:Number;
		public var scale:Number;
		public var wscale:Number;
		public var hscale:Number;
		
		public var viewBX:Number;
		public var viewBY:Number;
		public var viewAX:Number;
		public var viewAY:Number;
		
		public var width:Number;
		public var height:Number;
		
		public var pixelwidth:Number;
		public var pixelheight:Number;
		
		public var zoom:int=-1; //配置文件的级别
		public var ImageFormat:String="png";
		public var MapFolder:String;
		public var ImageWidth:Number=256;
		public var ImageHeight:Number=256;
		public var LevelParam:Array=[];
		public var _cols:int;
		public var MaxFilesPerFolder:int;
		public var dataPath:String;
		public var minLevel:int; 
		public var maxLevel:int;
		public var mapZooms:XMLList;
		
		public var layers:Array=[];
		
		public var configXML:XML;
		
		public var dzConfig:Object;
		
		private var _zoom:int=-1;
		
		public var _tilemapindex:int=0;
		
		public var center:Point;
		
		
		
		public function MapConfig(configXML:XML)
		{
			this.configXML=configXML;	
		}
		public function get cols():int{
		
			var col:Number=this.scale*this.ImageWidth;
			return Math.round(this.width/col);			
		}
		
		public function set tilemapindex(value:int):void
		{
			if(value>8){
				value=0;
			}
			this._tilemapindex=value;
			vzoom=this.vzoom;
			if(value>=2){
				this.center=new Point(this.x,this.y);
			}
		}
		public function get tilemapindex():int
		{
			return this._tilemapindex;
		}
		
		public function get vzoom():int
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
		
		
		public function set vzoom(v:int):void
		{
			var mpdata:XML=loadZoomConfig(this,tilemapindex);
			this.loadLayer(this,mpdata);
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
		public function init():void
		{
			
			//this.setMapConfig(this,this.vzoom);
		}
		public function loadZoomConfig(cf:Object,num:int):XML
		{
			var mapdata:XML=configXML.mapdatas.children()[num];
			cf.dataPath=mapdata.datapath;
			cf.minLevel=mapdata.minzoom;
			cf.maxLevel=mapdata.maxzoom;
			cf.mapZooms=mapdata.mapZooms.children();
			return mapdata;
		}
		public function loadLayer(cf:Object,mapdata:XML):void
		{
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
				cf.layers.push(layer);
				
			}
		}
		
		public function setMapConfig(cf:Object,v:int):void
		{
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
			try
			{  
				cf.pixelwidth=Number(zoomXML.pixelWidth);
				cf.pixelheight=Number(zoomXML.pixelHeight);
			}catch(e:Error)
			{
				trace("pixel error");
			}
			//
			var levelList:XMLList=zoomXML.levelParam;
			var levelArr:Array=[];
			if(levelList.children().length()>0){
				for(var i:int=0;i<levelList.length();i++){
					trace("ll"+levelList[i].level);
					levelArr.push(int(levelList[i].level));
				}
			}
			cf.LevelParam=[];
			cf.LevelParam=levelArr;
			cf.MaxFilesPerFolder=zoomXML.maxFilesPerFolder;
			cf.MapFolder=zoomXML.mapFolder;
			//cf.viewBY=cf.y-cf.height;
			
			cf.viewBY=cf.y-cf.height; //右下角y
			cf.viewBX=cf.x+cf.width; //右下角x
			cf.viewAX=cf.x;//坐上角x
			cf.viewAY=cf.y;//左上角y;
			
			
		}
		
		
		
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
				layers.push(layer);
				
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
				for(var i:int=0;i<levelList.length();i++){
					trace("ll"+levelList[i].level);
					levelArr.push(int(levelList[i].level));
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
			
			try
			{
				cf.pixelwidth=zoomXML.pixelwidth;
				cf.pixelheight=zoomXML.pixelheight;
			}catch(e:Error)
			{
				
			}
			
		}
		
		
		
		

	}
}