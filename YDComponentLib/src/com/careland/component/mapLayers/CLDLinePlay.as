package com.careland.component.mapLayers
{
	import __AS3__.vec.Vector;
	
	import com.careland.YDConfig;
	import com.careland.event.LineEvent;
	import com.careland.event.TimerEvent;
	import com.careland.events.MapEvent;
	import com.careland.layer.CLDMarker;
	import com.careland.layer.CLDPolyLine;
	import com.identity.timer.CLDTimerModel;
	
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.geom.Point;
	import flash.system.System;
	import flash.utils.getTimer;
	
	public class CLDLinePlay extends CLDContentLayer
	{
		//点的样式
		private var lineStyle:Array=[];
		
		private var pointArray:Array=[];
		
		//存放marker和线路的数组
		private var markerArray:Array=[];
		private var lineArray:Array=[];
		
		private var prePoint:Array;
		
		private var ti:uint=0;
		
		private var _xmlData:XML;
		private var start:Boolean=false;
		private var preTime:Number=0;
		private var timeSt:Number;
		
		private var preTimeCurrentLocation:int=0;
		
		public var changeCenter:Boolean=false;
	
		public function CLDLinePlay()
		{
			super();
			
			
		
		}
		private function jsCall(data):void
		{
			this.pauseData(data);	
		}

    	override protected function loadComponentData(contentID:String, data:*):void
	    {
	    	trace("result");
	    	try{
				
				
				this.pauseData(data);
				
			}catch(e:Error){
					
			}
			
			
	    }
		
	    private function pauseData(data:*):void
	    {
			
			trace("reload"+data);
			
			
			trace("dispose");
			try{
				System.disposeXML(this._xmlData);
				System.gc();
				throw new Error;
			}catch(e:Error){
					
			}
			var config:XML=XML(data).config[0];
			if(!config)
			{
				return;
				
			}else{
				
			}
			//var type:String=config.@["内容类型"];
			var timeInterval:Number=Number(config.@["刷新频率"]);
			
			var datas:XML=XML(data);
			
			this._xmlData=datas;

			var tables:XMLList=datas.table;
			
			var sign:String=tables[0].data[0].@区分标识;
			
			if(!start&&timeInterval!=0&&sign=="currentLocation"){
				start=true;
				preTimeCurrentLocation=flash.utils.getTimer();
				timeSt=timeInterval;
				this.addEventListener(Event.ENTER_FRAME,this.updateTime);

			}

			switch(sign){
			
				case "currentLocation": currentLocation(tables);break;//火炬传递
				case "playBack": playBack(tables,config);break;//轨迹回放
			}
			//delete datas;
			
		}
		private function playBack(tables:XMLList,config:XML):void
		{
			if(!this.playaBackInitConfig)
				initConfig(tables[1]);
			
			initPlayPoints(tables,config);

			this.line=this.getLinePlayBack(playBackPoint[0],playBackConfig.@线路宽度,playBackConfig.@线路颜色);
			this.addLine(line);
			
			//初始化第一个点
			marker=this.getMarkerPlayBack(-playBackConfig.@图片宽度/2,
			-playBackConfig.@图片高度,playBackConfig.@图片路径,playBackPoint[0]);
			this.addMarker(marker);
			
			var firstData:XML=playBackCellArray[0];
			
			var point:Point=new Point(firstData.@小区经度,firstData.@小区纬度);
			this.playBackJZ=this.getMarkerPlayBack(-10,
			-10,firstData.@图片,point,firstData.@鼠标经过事件);
			
			this.addMarker(playBackJZ);

			this.dispatchEvent(new MapEvent(MapEvent.MapAddLayer));
		}
		
		private function getLinePlayBack(point:Point,lineWidth:Number,lineColor:String,lineAlpha:String="100"):CLDPolyLine
		{
				var polyline:CLDPolyLine=new CLDPolyLine();
				polyline.addPoint(point);
				polyline.lineWidth=lineWidth;
				polyline.lineColor=parseInt("0x" + lineColor.replace("#", ""));
				polyline.lineAlpha=int(lineAlpha)/100;
				polyline.invalidate();
				return polyline;
		}
		
		
		//初始化 坐标点
		private function initPlayPoints(tables:XMLList,config:XML):void
		{
			var play:XML=tables[2];
			var datas:XMLList=play.data;
			playBackCellArray=datas;
			for(var i:int=0;i<datas.length();i++){
				
				var data:XML=datas[i];
				var p:Point=new Point(data.@经度,data.@纬度);
				playBackPoint.push(p);
			}
			var obj:CLDTimerModel=new CLDTimerModel;
			var point:Vector.<Point>=playBackPoint;
			obj.points=point;
			obj.id=tables[1].data[0].@id;
			obj.lineName=config.@内容标题;
			//points.push(obj);
			
			var le:LineEvent=new LineEvent(LineEvent.LINEINIT);
			le.timerModel=obj;
			//le.points=points;
			this.dispatchEvent(le);
			
		}
		//<data id="209" 图片路径="skin\default\images\mapWin\mapIcon\car.gif" 
		//图片宽度="70" 图片高度="33" 线路宽度="6" 线路颜色="#cbf334" 透明度="80" 回放间隔="10" /> 
		private var playBackConfig:XML;
		private var playaBackInitConfig:Boolean=false;
		private var playBackPoint:Vector.<Point>=new  Vector.<Point>();
		private var playBackCellArray:XMLList;//基站列表
		private var playBackJZ:CLDMarker;//周围 基站
		private var currentIndex:int=0;
		private var preTime0:int=0;
		private function initConfig(table:XML):void
		{
			var data:XML=table.data[0];
			playBackConfig=data;
			
			playaBackInitConfig=true;
			
			this.id=data.@id;
			var playStep:Number=data.@回放间隔;
			this.timeSt=playStep;
			this.preTime=flash.utils.getTimer();
			preTime0=preTime;
			this.addEventListener(Event.ENTER_FRAME,playBackUpdate);
			
		}
		
		
		
		private function playBackUpdate(e:Event):void
		{
			var newTime:Number=flash.utils.getTimer();
			if(newTime-this.preTime>timeSt*1000)
			{
				preTime=newTime;
				currentIndex++;
				if(currentIndex>=this.playBackPoint.length){
					this.removeEventListener(Event.ENTER_FRAME,playBackUpdate);
					return;
				}
				this.marker.cldPoint=this.playBackPoint[this.currentIndex];
				
				var firstData:XML=playBackCellArray[currentIndex];
			
				var point:Point=new Point(firstData.@小区经度,firstData.@小区纬度);
				playBackJZ.cldPoint=point;
				
				line.addPoint(this.marker.cldPoint);
				
				//更新经纬度信息
				updatePoint(firstData);
				var isChange:Boolean=false;
				//每5分钟更新一次 中心点坐标
				var playBackStep:int=int(YDConfig.instance().getProperties("playBack"));
				if(this.changeCenter&&newTime-preTime0>playBackStep*1000){
					isChange=true;
					this.preTime0=newTime;
				}
				var lineEvent:LineEvent=new LineEvent(LineEvent.MarkerChange);
				lineEvent.center=this.marker.cldPoint;
				lineEvent.radio=this.currentIndex/this.playBackPoint.length*100;
				lineEvent.changeCenter=isChange;
				this.dispatchEvent(lineEvent);
				
				//updatePoint();
				//this.dispatchEvent(new MapEvent(MapEvent.MapAddLayer));
			}
		}
		private function updatePoint(data:XML):void
		{
			//"userid:"+this.cldConfig.userID+"$@pid:"+menuid
			var param:String="id:"+data.@id+"$@号码:"+data.@号码+"$@用户名:null$@经度:"+ data.@小区经度+"$@纬度:"+data.@小区纬度
			var purl:String=weburl+"?SpName="+YDConfig.instance().getProcedure("lineBack")+"&paramsString="+param;
			
			this.loadTxt(encodeURI(purl),null,preduceResult);
//			this.loadTxt(this.weburl+""
		}
		private function preduceResult(e:Event):void
		{
			if(this.dataLoader){
				dataLoader.removeEventListener(Event.COMPLETE,preduceResult);
				dataLoader.removeEventListener(IOErrorEvent.IO_ERROR,this.ioError);
			}
		}
		
		public function updateLayerByRadio(e:TimerEvent):void
		{
			if(marker){
				this.line.clear();
				
				this.currentIndex=e.ratio;
				var p:Point=this.playBackPoint[currentIndex];
				marker.cldPoint=p;
				
				var newPoint:Vector.<Point>=this.playBackPoint.slice(0,currentIndex);
				this.line.setPoints(newPoint);
				
				if(this.currentIndex!=this.playBackPoint.length){
					if(!this.hasEventListener(Event.ENTER_FRAME)){
						this.addEventListener(Event.ENTER_FRAME,this.playBackUpdate);
					}
				}
				
				var lineEvent:LineEvent=new LineEvent(LineEvent.MarkerChange);
				lineEvent.center=this.marker.cldPoint;
				//lineEvent.radio=this.currentIndex/this.playBackPoint.length*100;
				this.dispatchEvent(lineEvent);
				
				
				//var arr:Array=this.playBackPoint[];
				
			}
		}
		
		
		
		

		//火炬传递
		private function initLineStyle(linedata:XMLList):void
		{
			for(var i:int=0;i<linedata.length();i++){
				var dt:XML=linedata[i];
				
				lineStyle.push(dt);
				this.id=dt.@id;
				trace(id+"id");
			}
		}
		
		private function getMarkerPlayBack(w:Number,h:Number,src:String,point:Point,mouseOverData:String=""):CLDMarker
		{
			  var marker:CLDMarker=new CLDMarker();
			
				//var pointstr:String=point;
				//var pointArr:Array=pointstr.split(",");
				
				//var p:Point=new Point(Number(pointArr[0]),Number(pointArr[1]));
				marker.cldPoint=point;
				marker.mouseOverData=mouseOverData;
				marker.pointType="image";
				marker.offx=w;
				marker.offy=h;
				marker.src=src;
				marker.invalidate();
				return marker;
		}
		
		private function getMarker(w:Number,h:Number,src:String,point:String):CLDMarker
		{
				var pointstr:String=point;
				var pointArr:Array=pointstr.split(",");
				var p:Point=new Point(Number(pointArr[0]),Number(pointArr[1]));
				var marker:CLDMarker=this.getMarkerPlayBack(w,h,src,p);
				return marker;
		}
		private function getLine(point:String,lineWidth:Number,lineColor:String,lineAlpha:String="100"):CLDPolyLine
		{
			    
				var pointstr:String=point;
				var pointArr:Array=pointstr.split(",");
			
				var p:Point=new Point(Number(pointArr[0]),Number(pointArr[1]));	
			
				var polyline:CLDPolyLine=this.getLinePlayBack(p,lineWidth,lineColor,lineAlpha);
				return polyline;
		}
		
		private function initLine(dt):void
		{
			
		}
//		/  <data id="206" 图片路径="img/torch.gif" 图片宽度="46" 图片高度="140" 线路宽度="5" 线路颜色="#cbf334" 地图级别="9" /> 
//  <data id="209" 图片路径="img/torch.gif" 图片宽度="46" 图片高度="140" 线路宽度="5" 线路颜色="#cbf897" 地图级别="9" /> 
		//初始化marker;
		
		var marker:CLDMarker;
		var line:CLDPolyLine
		var xqMarker:CLDMarker;
		private function initMarkerLine(markerdata:XMLList):void
		{
				
			 	var str:String=this.lineStyle[0].@图片路径;
			   	  marker=this.getMarker(-this.lineStyle[0].@图片宽度/2,
					-this.lineStyle[0].@图片高度,str,markerdata[0].@坐标);
				 
				 line=this.getLine(markerdata[0].@坐标,this.lineStyle[0].@线路宽度,lineStyle[0].@线路颜色,lineStyle[0].@线路透明度);
				 this.addLine(line);
				 this.addMarker(marker);
			     
			     line.clearPoint();
		        	    var pointstr:String=markerdata[0].@线坐标;
		        		
		        	
		        		var pointArr:Array=pointstr.split(";");
						for each(var str:String in pointArr){
							var sArr:Array=str.split(",");
			
							line.addPoint(new Point(Number(sArr[0]),Number(sArr[1])));
						}
			     
			  
			
//				this.map.updateSingleLayer(this);
				
			
		}
		private function changeMakerPoint(markerdata:XMLList):void
		{
			
//			if(markerdata[0].是否已完成==1){
//				flash.utils.clearInterval(this.ti);
//			}else{
				var pointstr:String=String(markerdata[0].@坐标);
		        var pointArr:Array=pointstr.split(",");
					
		        var p:Point=new Point(Number(pointArr[0]),Number(pointArr[1]));
		        if(p.x!=0&&p.y!=0){
		        	marker.cldPoint=p;
		        	trace(p+":"+p.x+"--"+p.y);
		        		
		        		line.clearPoint();
		        	    var pointstr:String=markerdata[0].@线坐标;
		        		
		        	
		        		var pointArr:Array=pointstr.split(";");
						for each(var str:String in pointArr){
							var sArr:Array=str.split(",");
			
							line.addPoint(new Point(Number(sArr[0]),Number(sArr[1])));
						}
		        }
				
			
//			}
			
		}
		//显示周围的基站
		private function showAroundMarker(markerdata:XMLList):void
		{
			for(var i:int=0;i<markerdata.length();i++){
				var dt:XML=markerdata[i];

				this.xqMarker=this.getMarker(Number(dt.@图片宽度)/2,
					-Number(dt.@图片高度),dt.@图片,dt.@经度+","+dt.@纬度);
				xqMarker.mouseOverData=dt.@鼠标经过事件;
				//this.markerArray.push(marker);
				this.addMarker(xqMarker);
			}
		}
		
		
		
		private function currentLocation(tables):void
		{
			
			//var tables:XMLList=datas.table
			
			
			
			
			//设置地图线路样式
			var table1:XML=tables[1];
			if(lineStyle.length==0){
				initLineStyle(table1.data);
			}
			//设置地图当前点
			
			var table2:XML=tables[2];
				
				if(table2.data[0].是否已完成=="1"){
					start=true;
					preTimeCurrentLocation=undefined;
					timeSt=undefined;
					this.removeEventListener(Event.ENTER_FRAME,this.updateTime);
					return;
				}
			
				if(!this.marker){
					initMarkerLine(table2.data);
				}else{
					this.changeMakerPoint(table2.data);
					trace("carelandpoint:"+table2.data[0].@坐标);
				}
			
			
			
			//设置周围基站
			
			var table3:XML=tables[3];
			if(table3&&table3.data){
				if(!this.xqMarker){
					this.showAroundMarker(table3.data);
				}else
				{
		        var p:Point=new Point(Number(table3.data[0].@经度),Number(table3.data[0].@纬度));
		       	 this.xqMarker.cldPoint=p;
		       	 this.xqMarker.mouseOverData=table3.data[0].@鼠标经过事件;
				}
			}
			
			//this.showAroundMarker(table3.data);
			
			//this.map.updateSingleLayer(this);
			
			if(this.changeCenter){
				
				var newTime:int=flash.utils.getTimer();
				
				var dis:int=newTime-this.preTimeCurrentLocation;
				
				var curStep:int=int(YDConfig.instance().getProperties("currentLocation"));
				if(dis>curStep*1000){
					this.preTimeCurrentLocation=newTime;
					var lineEvent:LineEvent=new LineEvent(LineEvent.MarkerChange);
					lineEvent.center=this.marker.cldPoint;
					lineEvent.changeCenter=this.changeCenter;
					this.dispatchEvent(lineEvent);
				}
				
				
				
			}
			
			
			this.dispatchEvent(new MapEvent(MapEvent.MapAddLayer));
			//this.dispatchEvent(new MapEvent(MapEvent.MapAddLayer));
			
			
		
		}
		
		
		
		
		private function updateTime(e:Event):void
		{
			if(start){
				
				var newTime:Number=flash.utils.getTimer();
				var dis:Number=newTime-this.preTime;
				
				if(dis>this.timeSt*1000){
					this.preTime=newTime;
					trace("reload-----------------------------------------------------------")
					this.reload();
				}
			}
		}
		override public function dispose():void
		{
			super.dispose();
			
			this.removeEventListener(Event.ENTER_FRAME,this.updateTime);
			this.removeEventListener(Event.ENTER_FRAME,playBackUpdate);
			this.start=false;
			this._xmlData=null;
			this.dataLoader=null;
			playBackJZ=null;
			marker=null;
			line=null;
			playBackConfig=null;
		  	playaBackInitConfig=null;
		  	playBackPoint=null;
		 	playBackCellArray=null;//基站列表
		    playBackJZ=null;//周围 基站
			
			
		}
		
	}
}