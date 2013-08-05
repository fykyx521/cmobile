package com.identity
{
	import com.careland.component.mapLayers.CLDLinePlay;
	import com.careland.component.mapLayers.LineLayer;
	import com.careland.events.MapEvent;
	import com.careland.layer.CLDLayer;
	import com.careland.layer.CLDMarker;
	import com.identity.imgmap.CLDImgMapMarker;
	import com.identity.imgmap.CLDImgMapPolyLine;
	import com.identity.imgmap.CLDImgMapPolygon;
	import com.identity.timer.CLDTimerWrapper;
	
	import flash.display.DisplayObjectContainer;
	import flash.geom.Point;

	public class CLDTransfer extends CLDMap
	{
		//点的样式
		private var lineStyle:Array=[];
		
		private var pointArray:Array=[];
		
		//存放marker和线路的数组
		private var markerArray:Array=[];
		private var lineArray:Array=[];
		
		private var prePoint:Array;
		
		private var lineTrans:CLDLayer;//主layer;
		
		private var aroudLayer:CLDLayer;//周围基站
		
		private var lineLayer:LineLayer;//两条线路
		
		private var timerWrapper:CLDTimerWrapper;
		
		public function CLDTransfer(parent:DisplayObjectContainer=null, xpos:Number=0, ypos:Number=0, autoLoad:Boolean=false, timeInteval:int=0)
		{
			super(parent, xpos, ypos, autoLoad, timeInteval);
		}
		
		override protected function addChildren():void
		{
			super.addChildren();
			
			lineLayer=new LineLayer();
			this.addLayer(lineLayer);
			//lineLayer.contentID=config.getLineID("people");
			lineLayer.autoLoad=true;
			
			timerWrapper=new CLDTimerWrapper();
			this.addChild(timerWrapper);
		}
		
		override public function draw():void
		{
			super.draw();
			trace("pause"+this.dataChange);
			if(this.data){
				pauseData();
				
				this.dataChange=false;	
			}
			if(this.timerWrapper){
				timerWrapper.x=0;
				timerWrapper.y=this.height-100;
				timerWrapper.width=this.width;
				timerWrapper.height=100;
			}
			
		}
		override public function set contentID(value:String):void
		{
			super.contentID=value;
		}
		override public function set autoLoad(value:Boolean):void
		{
			super.autoLoad=true;
			if(value){
				var ids:Array=contentID.split(",");
				for(var i:int=0;i<ids.length;i++){
					
					var cline:CLDLinePlay=new CLDLinePlay();
					cline.contentID=ids[i];
					cline.autoLoad=true;
					this.addLayer(cline);
					
					cline.addEventListener(MapEvent.MapAddLayer,layerChange);
				}
				
			}
		}
		private function layerChange(e:MapEvent):void
		{
			var line:CLDLayer=e.target as CLDLayer;
			if(line){
				this.updateSingleLayer(line);
			}
			
		}
		private function pauseData():void
		{
			var dataXML:XML=XML(this.data);
			
			var table:XML=dataXML.table[1];
			
			var p:Point=new Point(table.data[0].@centerX,table[0].@centerY);
			this.setLocation(p,table.data[0].@地图级别,0);
			
			
		}
		
		
	
		
		
		
		
		
		
		private function playBack(xml1:XML,xml2List:XML):void
		{
		
			
			var left1:Number=Number(xml1.@左顶点经度);
			var left2:Number=Number(xml1.@左顶点纬度);
			
			var marker:CLDImgMapMarker=new CLDImgMapMarker();
			marker.src="img/torch.gif";
			marker.pointType="image";
			//var pointstr:String=single.@坐标;
			//
			
			marker.cldPoint=new Point(Number(xml2List.data[0].@经度),Number(xml2List.data[0].@纬度));
			this.addChild(marker);
			marker.invalidate();
			
		}
		
		
		
		private function routePresetLine(xml1:XML,xml2List:XML):void
		{

			
			var left1:Number=Number(xml1.@左顶点经度);
			var left2:Number=Number(xml1.@左顶点纬度);
			
			var polyline:CLDImgMapPolyLine=new CLDImgMapPolyLine();
			var color:String=xml2List.data[0].@线颜色;//
			
			//="#ffffff" 线宽度="10"  
			polyline.lineWidth=Number(xml2List.data[0].@线宽度);
			polyline.lineColor=parseInt("0x" + color.replace("#", ""));
			var pointstr:String=xml2List.data[0].@坐标;
			var pointArr:Array=pointstr.split(";");
			for each(var str:String in pointArr){
				var sArr:Array=str.split(",");
				var point:Point=new Point(Number(sArr[0]),Number(sArr[1]));
				polyline.addScreenPoint(point);
			}
			this.addChild(polyline);
			polyline.invalidate();
			
			
			
			
			
		}
		
		
		private function drawLinePolygon(xml1:XML,xml2List:XMLList):void
		{
			
			
			var left1:Number=Number(xml1.@左顶点经度);
			var left2:Number=Number(xml1.@左顶点纬度);
			
			for(var i:int=0;i<xml2List.length();i++){
				
				
				var single:XML=xml2List[i];
				
				 
				switch(String(single.@类型)){
					case "point":drawPoint(left1,left2,xml1,single);	break;	
					case "polygon":drawRect(left1,left2,xml1,single);   break;
				}

			}
		}
		
		//  <data ID="13" 名称="SZ01B" 类型="point" 坐标类型="1" 坐标="113.9307721,22.537666" 
		//点样式="image" 标注图片="img/basic/Site.gif" 显示名称="" 宽度="32" 高度="32" 点击时窗口ID="198" 
		//线样式="" 线颜色="" 线宽度="" 面边框宽度="" 面边框颜色="" 面填充颜色="" 透明度="" 面是否隆起="" 
		//鼠标经过数据="名称:SZ01B<br>时间:2011-06-01 00:00:00<br>容量:2000.00<br>网元类型MSS<br>寻呼成功率:50.99%<br>位置更新成功率:20.33%<br>基本切入成功率:70.11%<br>基本切出成功率:50.22%<br>后续切出成功率:50.44%<br>后续切入成功率:50.55%" 
		//弹出窗信息="IFun.WinBoxData(198,13,300,500)" /> 
			
			
		private function drawPoint(left1:Number,left2:Number,xml1:XML,single:XML):void
		{
			var marker:CLDMarker=new CLDMarker();
			marker.src=single.@标注图片;
			marker.pointType="image";
			var pointstr:String=single.@坐标;
			var pointArr:Array=pointstr.split(",");		
			marker.cldPoint=new Point(Number(pointArr[0]),Number(pointArr[1]));
			this(marker);
			marker.invalidate();
			marker.data=single;
			marker.alterJS=String(single.@弹出窗信息);
			
			trace(marker.x);
		}
		// <data ID="16" 名称="SZ01A" 类型="polygon" 坐标类型="1" 坐标="113.927721,22.537666;113.929721,22.537666;113.9307721,22.537666;113.9287972,22.53606111" 点样式="" 标注图片="" 显示名称="" 宽度="" 高度="" 点击时窗口ID="198" 线样式="" 线颜色="" 线宽度="" 面边框宽度="2" 面边框颜色="black" 面填充颜色="red" 透明度="70" 面是否隆起="False" 鼠标经过数据="名称:SZ01A<br>时间:2011-06-01 00:00:00<br>容量:1000.00<br>网元类型MSS<br>寻呼成功率:99.99%<br>位置更新成功率:99.33%<br>基本切入成功率:99.11%<br>基本切出成功率:99.22%<br>后续切出成功率:99.44%<br>后续切入成功率:99.55%" 弹出窗信息="IFun.WinBoxData(198,16,300,500)" /> 
        // <data ID="17" 名称="SZ01B" 类型="polygon" 坐标类型="1" 坐标="113.927721,22.538666;113.927721,22.539666;113.9327721,22.539666;113.9247972,22.53996111" 点样式="" 标注图片="" 显示名称="" 宽度="" 高度="" 点击时窗口ID="198" 线样式="" 线颜色="" 线宽度="" 面边框宽度="2" 面边框颜色="black" 面填充颜色="blue" 透明度="70" 面是否隆起="True" 鼠标经过数据="名称:SZ01B<br>时间:2011-06-01 00:00:00<br>容量:2000.00<br>网元类型MSS<br>寻呼成功率:50.99%<br>位置更新成功率:20.33%<br>基本切入成功率:70.11%<br>基本切出成功率:50.22%<br>后续切出成功率:50.44%<br>后续切入成功率:50.55%" 弹出窗信息="IFun.WinBoxData(198,17,300,500)" /> 
		
//		private function touchMarker(e:MapEvent):void
//		{
//			var target:CLDBaseMarker=e.target as CLDBaseMarker;
//			if(target&&target.alterJS){
//				var js:String=target.alterJS;
//				ExternalInterface.call("eval",js)
//			}
//			
//		}
		
		private function drawRect(left1:Number,left2:Number,xml1:XML,single:XML):void
		{
			var polygon:CLDImgMapPolygon=new CLDImgMapPolygon();
			
			
			var pointstr:String=single.@坐标;
			var pointArr:Array=pointstr.split(";");
			polygon.data=single;
			polygon.alterJS=String(single.@弹出窗信息);
			
			for each(var str:String in pointArr){
				var sArr:Array=str.split(",");
				var point:Point=new Point(Number(sArr[0]),Number(sArr[1]));
				
				
				polygon.addPoint(point);
			}
			polygon.invalidate();
			this.addChild(polygon);
		
		}
		
	
		
		
		
	}
}