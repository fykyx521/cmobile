package com.careland.component.mapLayers
{
	import com.careland.YDConfig;
	import com.careland.event.ColorEvent;
	import com.careland.events.MapEvent;
	import com.careland.layer.CLDBaseMarker;
	import com.careland.layer.CLDLayer;
	import com.careland.layer.CLDMarker;
	import com.careland.layer.CLDPolyLine;
	import com.careland.layer.CLDPolygon;
	import com.identity.CLDMap;
	import com.identity.map.CLDColorManage;
	import com.identity.map.CLDColorSprite;
	
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.geom.Point;
	import flash.net.LocalConnection;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.utils.getTimer;
	
	import uk.co.teethgrinder.string.StringUtils;
	
	public class CLDContentLayer extends CLDLayer
	{
		protected var dataLoader:URLLoader;
		public var contentID:String;
		
		
		
		private var contenturl:String=YDConfig.instance().contenturl;
		protected var weburl:String=YDConfig.instance().produceweburl;
		public var map:CLDMap;
		
		private var start:Boolean=false;
		private var preTime:int;//初始时间
		private var timeSt:int;
		
		public var contentParam:String="";
		
		public var color:CLDColorSprite;
		public function CLDContentLayer()
		{
			super();
			
		}
		
		protected function loadTxt(url:String,data:Object,func:Function):void
		{
			
			if(!dataLoader){
				dataLoader=new URLLoader();
			}
			
			dataLoader.addEventListener(Event.COMPLETE,func,false,0,true);
			dataLoader.addEventListener(IOErrorEvent.IO_ERROR,ioError,false,0,true);
			
			dataLoader.addEventListener(IOErrorEvent.IO_ERROR,ioError,false,0,true);
			var urlRequest:URLRequest=new URLRequest(url);
//			urlRequest.method="post";
//			if(data){				
//				urlRequest.data=data;
//			}
			dataLoader.load(urlRequest); 
			
		}
		protected function ioError(e:Event):void
		{
			if(this.dataLoader)
			{
				dataLoader.removeEventListener(Event.COMPLETE,result);
				dataLoader.removeEventListener(IOErrorEvent.IO_ERROR,ioError);
			}
			
		}
		
		public function set autoLoad(value:Boolean):void
		{
			if(value){
				this.loadDataByID(this.contentID);
			}	
		}
		
		protected function loadDataByID(tid:String):void
		{
			if(this.contentParam!="")
			{
				var par:String="";
				
				if(contentParam.indexOf(":",0)!=-1){
					par="category=1";
				}
				this.loadTxt(contenturl+"?id="+tid+"&P="+encodeURI(contentParam)+"&"+Math.random()+"&"+par,null,result);
			}else{
				this.loadTxt(contenturl+"?id="+tid+"&"+Math.random(),null,result);
			}
			
			
			
		}
		protected function result(e:Event):void
		{
			if(dataLoader){
				dataLoader.removeEventListener(Event.COMPLETE,result);
				dataLoader.removeEventListener(IOErrorEvent.IO_ERROR,ioError);
				
				loadComponentData(contentID,dataLoader.data);
				dataLoader=null;
			}
			
			
			
		}
		override public function dispose():void
		{
			super.dispose();
			if(dataLoader){
				dataLoader.close();
				dataLoader.removeEventListener(Event.COMPLETE,result);
				dataLoader.removeEventListener(IOErrorEvent.IO_ERROR,ioError);
			}
			this.removeEventListener(Event.ENTER_FRAME,this.updateTime);
			this.dataLoader=null;
		}
		
		public function clearChild():void
		{
			
			while(this.numChildren>0)
			{
				var dis:DisplayObject=this.getChildAt(0);
				CLDBaseMarker(dis).dispose();
				this.removeChild(dis);
			}
			this.markers.splice(0,markers.length);
			this.polylines.splice(0,polylines.length);
			this.polygons.splice(0,polygons.length);
			this.circles.splice(0,circles.length);
			
		}
		
		private function updateTime(e:Event):void
		{
			if(start){
				
				var newTime:Number=flash.utils.getTimer();
				var dis:Number=newTime-this.preTime;
				
				if(dis>this.timeSt*1000){
					this.preTime=newTime;
				
					this.reload();
				}
			}
		}
		protected function reload():void{
			
			
			doClearance();
			this.loadDataByID(this.contentID);
		}
	    private function doClearance( ) : void {
                       
              try{
                        		
                     new LocalConnection().connect("foo");
                     new LocalConnection().connect("foo");
                 }catch(error : Error){
                                
                 }                        
          }
		
		
		 private function drawColor(_name:String,index,colorManage:CLDColorManage):void{
             for(var i:int=0;i<configData.table[2].data.length();i++){
             	 var range:Number=configData.table[2].data[i].@[_name];              	        	   
             	 var color:int=colorManage.checkColor(range);
             	 var  polygon:CLDPolygon=this.polygons[i] as CLDPolygon;
             	
             	    polygon.bgColor=color;  
             	   	 
             } 
            mapAddLayer();
        }
 
         
        //网格色带数据加载
      
        public function colorClick(e:ColorEvent):void{
           var colorManage=e.colorManage;
           drawColor(e.color,e.index,e.colorManage);
        }
		
		
		public var configData:XML;
		protected function loadComponentData(contentID:String,data:*):void
		{
			var num:int=this.numChildren;
			this.clearChild();
			
			var num1:int=this.numChildren;
			if(XML(data)){
				if(String(XML(data).table)==""){
					return;
				}
			}
			var dataXML:XML=XML(data);
			configData=dataXML;
			
			var config:XML=XML(data).config[0];
			if(!config)
			{
				return;
				
			}else{
				
			}
			var timeInterval:Number=Number(config.@["刷新频率"]);
			
			if(!start&&timeInterval!=0){
				start=true;
				preTime=flash.utils.getTimer();
				timeSt=timeInterval;
				this.addEventListener(Event.ENTER_FRAME,this.updateTime);

			}
			
			var tables:XMLList=dataXML.table;
			var isColor:Boolean=false;
			if(tables[0].data!=null&&tables.length()>2){
				isColor=true;
			}
			
			var datas:XMLList=XML(data).table[1].data;
				var length:int=datas.length();
				
				for(var i:int=0;i<length;i++){
					var daxml:XML=datas[i];

					var dataType:String=daxml.@类型;
					
					switch(dataType){
						case "point": addMarkerwd(daxml);break;
						case "polyLine":addPolyLinewd(daxml);break;
						case "polygon":addPolygonwd(daxml);
						if(isColor){
							this.dispatchEvent(new ColorEvent(ColorEvent.colorState));
						}
						isColor=false;break;
							
					}
				}
			
			//map.updateLayer();
			
			mapAddLayer();
			
		}
		
		protected function mapAddLayer():void
		{
			this.dispatchEvent(new MapEvent(MapEvent.MapAddLayer));
		}
		
		
		private function addMarkerwd(dt:XML):void
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
		
			this.addMarker(marker);

		}
		
	 
		
		
		public function addPolyLinewd(dt:XML):void
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
			this.addLine(polyline);
			
			
			//polyline.change(center,this.width,this.height);
			
			
		}
		private function addPolygonwd(dt:XML):void
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
			
			polygon.invalidate();
			this.addgon(polygon);
			
			
		}
		
		
		
		
	}
}