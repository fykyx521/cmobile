package com.identity
{
	import caurina.transitions.Tweener;
	
	import com.careland.component.CLDBaseComponent;
	import com.careland.component.util.ImgMapPoint;
	import com.careland.component.win.CLDMapOverWin;
	import com.careland.event.CLDEvent;
	import com.careland.events.MapEvent;
	import com.careland.layer.CLDBaseMarker;
	import com.identity.imgmap.CLDImgMapMarker;
	import com.identity.imgmap.CLDImgMapPolyLine;
	import com.identity.imgmap.CLDImgMapPolygon;
	import com.identity.imgmap.CLDimgMapLayer;
	
	import flash.display.DisplayObjectContainer;
	import flash.external.ExternalInterface;
	import flash.geom.Point;

	public class CLDImgMap extends CLDBaseComponent
	{
		private var pic:CldPicture;
		private var layer:CLDimgMapLayer;
		private var mapOver:CLDMapOverWin;
		public function CLDImgMap(parent:DisplayObjectContainer=null, xpos:Number=0, ypos:Number=0, autoLoad:Boolean=false, timeInteval:int=0)
		{
			super(parent, xpos, ypos, autoLoad, timeInteval);
		}
		
		override protected function addChildren():void
		{
			pic=new CldPicture();
			this.addChild(pic);
			layer=new CLDimgMapLayer;
			this.addChild(layer);
			mapOver=new CLDMapOverWin;
			this.addChild(mapOver);
			//this.addEventListener(MapEvent.MapTouchMarker,touchMarker,true);
		}
		override public function draw():void
		{
			if(data&&this.dataChange){
				pauseData();
				this.dataChange=false;
			}
			pic.setSize(this.width,this.height);
		}
		override public function dispose():void
		{
			super.dispose();
			layer.dispose();
			mapOver.dispose();
			mapOver=null;
			pic=null;
			layer=null;
		}
		
		//解析数据
		
		private function pauseData():void
		{
			
			var datas:XML=XML(data);
			
			var tables:XMLList=datas.table;
			
			var table0:XML=tables[0];
			
			var sign:String=tables[0].data[0].@区分标识;
			
			var table1:XML=tables[1];
			
			
			// <data 地图级别="2.048" 背景图片路径="img\main.jpg" 背景图片宽度="1024" 背景图片高度="768" 左顶点经度="113.918797" 左顶点纬度="22.53606111" /> 

			if(!pic) return;
			switch(sign){
				case "routePresetLine": routePresetLine(tables[1].data[0],tables[2]);break;
				case "currentLocation": currentLocation(tables[1].data[0],tables[2]);break;
				case "pointLinePolygon":drawLinePolygon(tables[1].data[0],tables[2].data);break;
				case "playBack": playBack(tables[1].data[0],tables[2]);break;
				
			}
			
		}
		
		private function playBack(xml1:XML,xml2List:XML):void
		{
			
			pic.imgUrl=xml1.@背景图片路径;
			pic.setSize(xml1.@背景图片宽度,xml1.@背景图片高度);
			pic.loadImg(pic.imgUrl);
			
			var left1:Number=Number(xml1.@左顶点经度);
			var left2:Number=Number(xml1.@左顶点纬度);
			
			var marker:CLDImgMapMarker=new CLDImgMapMarker();
			marker.src="img/torch.gif";
			marker.pointType="image";
			//var pointstr:String=single.@坐标;
			//
			
			marker.cldPoint=new Point(Number(xml2List.data[0].@经度),Number(xml2List.data[0].@纬度));
			this.addChild(marker);
//			marker.addEventListener(CLDEvent.rightClick,rightClick);
			marker.invalidate();
			
			var cld:ImgMapPoint=new ImgMapPoint(left1,left2,marker.cldPoint.x,marker.cldPoint.y,pic.width,pic.height);
			var newPoint:Object=cld.toScreenPoint(xml1.@地图级别);
			
			marker.x=newPoint.x;
			marker.y=newPoint.y;
		}
		private function rightClick(e:MapEvent):void
		{
			var target:CLDBaseMarker=e.target as CLDBaseMarker;
			if(target&&target.mouseClickData)
			{
				var cle:CLDEvent=new CLDEvent(CLDEvent.ALERTWIN);
				cle.mouseClickData=target.mouseClickData;
				config.dispatchEvent(cle);
			}
			
		}
		
		
		
		private function routePresetLine(xml1:XML,xml2List:XML):void
		{
			pic.imgUrl=xml1.@背景图片路径;
			pic.setSize(xml1.@背景图片宽度,xml1.@背景图片高度);
			pic.loadImg(pic.imgUrl);
			
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
		
		private function currentLocation(xml1:XML,xml2List:XML):void
		{
			pic.imgUrl=xml1.@背景图片路径;
			pic.setSize(xml1.@背景图片宽度,xml1.@背景图片高度);
			pic.loadImg(pic.imgUrl);
			
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
			
			var cld:ImgMapPoint=new ImgMapPoint(left1,left2,marker.cldPoint.x,marker.cldPoint.y,pic.width,pic.height);
			var newPoint:Object=cld.toScreenPoint(xml1.@地图级别);
			
			marker.x=newPoint.x;
			marker.y=newPoint.y;
			
			
			
		}
				
		private function drawLinePolygon(xml1:XML,xml2List:XMLList):void
		{
			pic.imgUrl=xml1.@背景图片路径;
			pic.setSize(xml1.@背景图片宽度,xml1.@背景图片高度);
			pic.autoSize=false;
			pic.loadImg(pic.imgUrl);
			
		
			
			var left1:Number=Number(xml1.@左顶点经度);
			var left2:Number=Number(xml1.@左顶点纬度);
			
			for(var i:int=0;i<xml2List.length();i++){
				
				var single:XML=xml2List[i];
				
				 
				switch(String(single.@类型)){
					case "point":drawPoint(left1,left2,xml1,single);	break;	
					case "polygon":drawRect(left1,left2,xml1,single);   break;
					//case "pointLinePolygon":drawpointLinePolygon();break
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
			var marker:CLDImgMapMarker=new CLDImgMapMarker();
			marker.src=single.@标注图片;
			marker.pointType="image";
			var pointstr:String=single.@坐标;
			var pointArr:Array=pointstr.split(",");		
			marker.cldPoint=new Point(Number(pointArr[0]),Number(pointArr[1]));
			marker.showName=single.@显示名称;
			this.addChild(marker);
			marker.invalidate();
			marker.data=single;
			marker.mouseOverData=single.@鼠标经过数据;
			
			marker.addEventListener(MapEvent.MapMouseOver,overHandler);
			marker.addEventListener(MapEvent.MapMouseRightClick,this.rightClick);
			marker.mouseClickData=String(single.@弹出窗信息);
			var newPoint:Object={};
			if(single.@坐标类型=="1"){
				var cld:ImgMapPoint=new ImgMapPoint(left1,left2,marker.cldPoint.x,marker.cldPoint.y,pic.width,pic.height);
				newPoint=cld.toScreenPoint(xml1.@地图级别);
			}else{
				newPoint=marker.cldPoint;
			}
			
			var picScaleX:Number=this.stageWidth/1024;
			var picScaleY:Number=this.stageHeight/768;
			
			marker.x=newPoint.x*picScaleX;
			marker.y=newPoint.y*picScaleY;
			trace(marker.x+":::markerY"+marker.y);
		}
		private function overHandler(e:MapEvent):void
		{
			var target:CLDBaseMarker=e.target as CLDBaseMarker;
			if(target&&target.mouseOverData){
				var lp:Point=this.globalToLocal(new Point(e.stageX,e.stageY));
				//mapOver.x=lp.x;
				//mapOver.y=lp.y;
				mapOver.alpha=.1;
				mapOver.visible=true;
				this.setChildIndex(mapOver,this.numChildren-1);
				this.mapOver.data=target.mouseOverData;
				Tweener.removeTweens(mapOver);
				Tweener.addTween(this.mapOver,{x:lp.x,y:lp.y,alpha:1,time:.5});
				
				//Tweener.addTween(this.mapOver,{x:-100,y:-100,alpha:0,time:.5,delay:15});
				
			}
			if(target&&target.mouseClickData!=""&&config){
				
			}
		}
		// <data ID="16" 名称="SZ01A" 类型="polygon" 坐标类型="1" 坐标="113.927721,22.537666;113.929721,22.537666;113.9307721,22.537666;113.9287972,22.53606111" 点样式="" 标注图片="" 显示名称="" 宽度="" 高度="" 点击时窗口ID="198" 线样式="" 线颜色="" 线宽度="" 面边框宽度="2" 面边框颜色="black" 面填充颜色="red" 透明度="70" 面是否隆起="False" 鼠标经过数据="名称:SZ01A<br>时间:2011-06-01 00:00:00<br>容量:1000.00<br>网元类型MSS<br>寻呼成功率:99.99%<br>位置更新成功率:99.33%<br>基本切入成功率:99.11%<br>基本切出成功率:99.22%<br>后续切出成功率:99.44%<br>后续切入成功率:99.55%" 弹出窗信息="IFun.WinBoxData(198,16,300,500)" /> 
        // <data ID="17" 名称="SZ01B" 类型="polygon" 坐标类型="1" 坐标="113.927721,22.538666;113.927721,22.539666;113.9327721,22.539666;113.9247972,22.53996111" 点样式="" 标注图片="" 显示名称="" 宽度="" 高度="" 点击时窗口ID="198" 线样式="" 线颜色="" 线宽度="" 面边框宽度="2" 面边框颜色="black" 面填充颜色="blue" 透明度="70" 面是否隆起="True" 鼠标经过数据="名称:SZ01B<br>时间:2011-06-01 00:00:00<br>容量:2000.00<br>网元类型MSS<br>寻呼成功率:50.99%<br>位置更新成功率:20.33%<br>基本切入成功率:70.11%<br>基本切出成功率:50.22%<br>后续切出成功率:50.44%<br>后续切入成功率:50.55%" 弹出窗信息="IFun.WinBoxData(198,17,300,500)" /> 
		
		private function touchMarker(e:MapEvent):void
		{
			var target:CLDBaseMarker=e.target as CLDBaseMarker;
			if(target&&target.alterJS){
				var js:String=target.alterJS;
				ExternalInterface.call("eval",js)
			}
			
		}
		
		private function drawRect(left1:Number,left2:Number,xml1:XML,single:XML):void
		{
			var polygon:CLDImgMapPolygon=new CLDImgMapPolygon();
			
			
			var pointstr:String=single.@坐标;
			var pointArr:Array=pointstr.split(";");
			polygon.data=single;
			polygon.alterJS=String(single.@弹出窗信息);
			
			var pointType:String=single.@坐标类型;
			
			for each(var str:String in pointArr){
				var sArr:Array=str.split(",");
				var point:Point=new Point(Number(sArr[0]),Number(sArr[1]));
				var cld:ImgMapPoint=new ImgMapPoint(left1,left2,point.x,point.y,pic.width,pic.height);
				var newPoint:Point=new Point(0,0);
				if(pointType=="1"){
					var newPobj:Object=cld.toScreenPoint(xml1.@地图级别);
					newPoint=new Point(Number(newPobj.x),Number(newPobj.y));
				}else{
					newPoint=point;
				}
				
				polygon.addScreenPoint(newPoint);
			}
			polygon.invalidate();
			this.addChild(polygon);
		
		}
		
		
			
		
	}
}