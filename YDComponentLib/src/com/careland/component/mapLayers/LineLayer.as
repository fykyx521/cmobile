package com.careland.component.mapLayers
{
	import __AS3__.vec.Vector;
	
	import com.careland.event.LineEvent;
	import com.careland.events.MapEvent;
	import com.careland.layer.CLDPolyLine;
	import com.identity.timer.CLDTimerModel;
	
	import flash.geom.Point;
	
	public class LineLayer extends CLDContentLayer
	{
		
		private var lines:Array=[];
		public function LineLayer()
		{
			super();
		}
		
		override protected function loadComponentData(contentID:String,data:*):void
		{
			
			
			if(XML(data)){
				if(String(XML(data).table)==""){
					return;
				}
			}
				var datas:XMLList=XML(data).table[2].data;
				var length:int=datas.length();
				var points:Vector.<CLDTimerModel>=new Vector.<CLDTimerModel>;
				for(var i:int=0;i<length;i++){
					var daxml:XML=datas[i];
					
					var dataType:String=daxml.@类型;
					var id:int=daxml.@ID;
					var lineName:String=daxml.@名称;
					switch(dataType){
					
						case "routeLine":
						var obj:CLDTimerModel=new CLDTimerModel;
					
						var point:Array=addPolyLine(daxml,id);
//						obj.points=point;
//						obj.id=id;
//						obj.lineName=lineName;
//						points.push(obj);break;
						
					}
				}
//			if(points.length>1){
//				var le:LineEvent=new LineEvent(LineEvent.LINEINIT);
//				le.points=points;
//				this.dispatchEvent(le);
//			}
			
			this.dispatchEvent(new MapEvent(MapEvent.MapAddLayer));
			
		}
		
		
		 public function addPolyLine(dt:XML,id:int):Array
		{
			var linePoint:Array=[];
			var polyline:CLDPolyLine=new CLDPolyLine();
			var pointstr:String=dt.@坐标;
			
			var pointArr:Array=pointstr.split(";");
			for each(var str:String in pointArr){
				var sArr:Array=str.split(",");
				var p:Point=new Point(Number(sArr[0]),Number(sArr[1]));
				polyline.addPoint(p);
				linePoint.push(p);
			}
			polyline.mouseOverData=dt.@鼠标经过数据;
			var color:String=dt.@线颜色;
			
			polyline.lineColor=parseInt("0x" + color.replace("#", ""));
			polyline.lineWidth=Number(dt.@线宽度);
			polyline.lineAlpha=Number(dt.@透明度)/100;
			polyline.invalidate();
			this.addLine(polyline);
			
			
			return linePoint;
			//polyline.change(center,this.width,this.height);
			
			
		}
		override public function dispose():void
		{
			super.dispose();
		}
		
	}
}