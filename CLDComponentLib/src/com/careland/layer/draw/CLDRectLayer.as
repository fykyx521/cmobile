package com.careland.layer.draw
{
	import com.careland.layer.CLDPolygon;
	import com.careland.util.MapConfig;
	
	import flash.events.MouseEvent;
	import flash.geom.Point;

	public class CLDRectLayer extends CLDLoadLayer
	{
		
		public var sourcePoint:Point;
		public var toPoint:Point;
		public function CLDRectLayer()
		{
			super(); 
		}
		
		
		/**
		 *   p1 p2
		 *   p4 p3
		 * 
		 * */
		override public function initData(center:Point,width:Number,height:Number,mapConfig:MapConfig):void
		{
			
			var p1:Point=sourcePoint;
//			var p2:Point=new Point(sourcePoint.x+toPoint.x,p1.y);
//			var p3:Point=new Point(sourcePoint.x+toPoint.x,sourcePoint.y+toPoint.y);
//			var p4:Point=new Point(sourcePoint.x,sourcePoint.y+toPoint.y);


			//var p2:Point=new Point(sourcePoint.x+toPoint.x,p1.y);
			var p3:Point=new Point(sourcePoint.x+toPoint.x,sourcePoint.y+toPoint.y);
			//var p4:Point=new Point(sourcePoint.x,sourcePoint.y+toPoint.y);
			
			
			
			var cldP1:Point=this.getCLDPoint(p1,center,width,height,mapConfig);
			//var cldP2:Point=this.getCLDPoint(p2,center,width,height,mapConfig);
			var cldP3:Point=this.getCLDPoint(p3,center,width,height,mapConfig);
			//var cldP4:Point=this.getCLDPoint(p4,center,width,height,mapConfig);
			
			var cldP2:Point=new Point(cldP3.x,cldP1.y);
			
			var cldP4:Point=new Point(cldP1.x,cldP3.y);
			
			var gon:CLDPolygon=new CLDPolygon();
			gon.filteralpha=.3;
			gon.addPoint(cldP1);
			gon.addPoint(cldP2);
			gon.addPoint(cldP3);
			gon.addPoint(cldP4);
			gon.addEventListener(MouseEvent.MOUSE_DOWN,downHandler);
			this.addgon(gon);
			gon.invalidate();
			
			
			//test
			  
//				var cldMarker:CLDMarker=new CLDMarker();
//				cldMarker.cldPoint=new Point(cldP1.x,cldP1.y);
//				cldMarker.src="assets/images/serach/searchPoint.png";
//				cldMarker.pointType="image";
//				cldMarker.invalidate();
//				this.addMarker(cldMarker);
//				
//				var cldMarker1:CLDMarker=new CLDMarker();
//				cldMarker1.cldPoint=new Point(cldP2.x,cldP2.y);
//				cldMarker1.src="assets/images/serach/searchPoint.png";
//				cldMarker1.pointType="image";
//				cldMarker1.invalidate();
//				this.addMarker(cldMarker1);
//				
//				var cldMarker2:CLDMarker=new CLDMarker();
//				cldMarker2.cldPoint=new Point(cldP3.x,cldP3.y);
//				cldMarker2.src="assets/images/serach/searchPoint.png";
//				cldMarker2.pointType="image";
//				cldMarker.invalidate();
//				this.addMarker(cldMarker2);
//				
//				var cldMarker3:CLDMarker=new CLDMarker();
//				cldMarker3.cldPoint=new Point(cldP4.x,cldP4.y);
//				cldMarker3.src="assets/images/serach/searchPoint.png";
//				cldMarker3.pointType="image";
//				cldMarker3.invalidate();
//				this.addMarker(cldMarker3);
			
			
			
			
			
			var type:String="框选";
			//var type:String=encodeURI("框选");
			var param:String="stype="+type+"&point1=" + cldP1.x + "," + cldP1.y +
					 "&point2=" + cldP3.x+","+cldP3.y;
			this.loadData(param);
		}
		protected function downHandler(e:MouseEvent):void
		{
			e.target.removeEventListener(MouseEvent.MOUSE_DOWN,downHandler);
			this.removeRect(e.target as CLDPolygon);
		}
		
		
	}
}