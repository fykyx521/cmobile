package com.careland.layer.draw
{

	import com.careland.YDConfig;
	import com.careland.events.MapDataEvent;
	import com.careland.layer.CLDLayer;
	import com.careland.layer.CLDMarker;
	import com.careland.util.MapConfig;
	
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.geom.Point;
	import flash.net.URLLoader;
	import flash.net.URLRequest;

	public class CLDLoadLayer extends CLDLayer
	{
		private var dataLoader:URLLoader
		public function CLDLoadLayer()
		{
			super();
		}
		protected function loadTxt(url:String,data:Object,func:Function=null):void
		{
			
			if(!dataLoader){
				dataLoader=new URLLoader();
			}
			
			dataLoader.addEventListener(Event.COMPLETE,func,false,0,true);
			dataLoader.addEventListener(IOErrorEvent.IO_ERROR,ioError,false,0,true);
		
			var urlRequest:URLRequest=new URLRequest(url);
			urlRequest.method="post";
			//urlRequest.contentType="";
			urlRequest.contentType = 'application/octet-stream';
			if(data){				
				urlRequest.data=data;
			}
			dataLoader.load(urlRequest); 
			
		}
		
		protected function loadData(param:String):void
		{
			var url:String=YDConfig.instance().baseurl+YDConfig.instance().getProperties("serachURL");
//			url="http://10.245.122.153/DataServer/AjaxForSearch.aspx";
			var produce:String=YDConfig.instance().getProcedure("drawRectCircle");
			var produceParam:String="<params><param name='"+produce+"' args=''></param></params>";
			
			this.loadTxt(encodeURI(url+"?"+param),encodeURI(produceParam),loadResult);
		}
		
		protected function loadResult(e:Event):void
		{
			if(dataLoader){
				dataLoader.removeEventListener(Event.COMPLETE,loadResult);
				dataLoader.removeEventListener(IOErrorEvent.IO_ERROR,ioError);
				
				dataHandler(XML(dataLoader.data));
				
			}
		}
		
		protected function dataHandler(data:XML):void
		{
			var dataList:XMLList=data.data;
//			for(var i:int=0;i<dataList.length();i++){
//				
//				var dt:XML=dataList[i];
//				var cldMarker:CLDMarker=new CLDMarker();
//				cldMarker.cldPoint=new Point(dt.@经度,dt.@纬度);
//				cldMarker.src="assets/images/serach/searchPoint.png";
//				cldMarker.pointType="image";
//				
//				cldMarker.invalidate();
//				this.addMarker(cldMarker);
//			}
			var mapevent:MapDataEvent=new MapDataEvent(MapDataEvent.MAP_DATA_TIP);
			mapevent.mouseOverData=String(data.area[0].@flash);
			this.dispatchEvent(mapevent);
			
		}
		
		public function initData(center:Point,vw:Number,vh:Number,mapConfig:MapConfig):void
		{
			
		}
		
		
		protected function ioError(e:IOErrorEvent):void
		{
			if(this.dataLoader)
			{
				dataLoader.removeEventListener(Event.COMPLETE,loadResult);
				dataLoader.removeEventListener(IOErrorEvent.IO_ERROR,ioError);
			}
			trace(e.text);
			
		}
		
	}
}