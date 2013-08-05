package com.careland.layer.draw
{
	import __AS3__.vec.Vector;
	
	import com.careland.layer.CLDPolygon;
	import com.careland.util.CLDConfig;
	import com.careland.util.MapConfig;
	
	import flash.events.MouseEvent;
	import flash.geom.Point;
	
	public class CLDMutiRectLayer extends CLDRectLayer
	{
		public var points:Vector.<Point>=new Vector.<Point>();
		public function CLDMutiRectLayer()
		{
			super();
		}
		
		public function addPoint(p:Point):void
		{
			
		}
		
		
		override public function initData(center:Point, width:Number, height:Number, mapConfig:MapConfig):void
		{
			
			var rect:CLDPolygon=new CLDPolygon();
			
			var pointValue:String="";
			var vectshape:Vector.<Point>=new Vector.<Point>();
			for each(var point:Point in this.points)
			{
				
				var newPoint:Point=this.getCLDPoint(point,center,width,height,mapConfig);
				
				rect.addPoint(newPoint);
				vectshape.push(newPoint);
				pointValue+=newPoint.x+","+newPoint.y+";";
			}
			pointValue=pointValue.substr(0,pointValue.length-1);
			rect.filteralpha=.3;
			rect.addEventListener(MouseEvent.MOUSE_DOWN,downHandler);
			this.addgon(rect);
			var shapeAcr:Number=CLDConfig.instance().shapeAcreage(vectshape);
			rect.invalidate();
			
			var type:String="多边形选";
			//var type:String=encodeURI("多边形选");
			var param:String="stype="+ type +"&PValue="+ pointValue+"&area="+shapeAcr/(1000*1000);
			
			this.loadData(param);
			
		}
		
	}
}