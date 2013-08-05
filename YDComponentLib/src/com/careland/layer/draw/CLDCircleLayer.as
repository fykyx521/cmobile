package com.careland.layer.draw
{
	import com.careland.layer.CLDCircle;
	import com.careland.util.CLDConfig;
	import com.careland.util.MapConfig;
	
	import flash.events.MouseEvent;
	import flash.geom.Point;
	
	public class CLDCircleLayer extends CLDLoadLayer
	{
		public var cldPoint:Point;
		public var _radius:Number;
		public var screenPoint:Point;
		public function CLDCircleLayer()
		{
			super();
		}
		
		
		
		override public function initData(center:Point,vw:Number,vh:Number,mapConfig:MapConfig):void
		{
			if(!this.cldPoint){
				this.cldPoint=this.getCLDPoint(this.screenPoint,center,vw,vh,mapConfig);
				var rap:Point=new Point(0,0);
				rap.x=this.screenPoint.x-this._radius;//屏幕坐标-半径
				rap.y=this.screenPoint.y;
				var _radiusp:Point=this.getCLDPoint(rap,center,vw,vh,mapConfig);
				var _distance:Number=CLDConfig.getMapDistance(cldPoint,_radiusp);
				
				var circle:CLDCircle=new CLDCircle();
				circle.cldPoint=cldPoint;
				circle.radiusp=_radiusp;
				circle.addEventListener(MouseEvent.MOUSE_DOWN,downHandler);
				this.addCircle(circle);
				
				var instance:Point=this.cldPoint.subtract(_radiusp);
				
				var dis:Number=Math.abs(Math.sqrt(instance.x*instance.x+instance.y*instance.y));
				//circle.invalidate();
				var type:String="圈选";
				//var type:String=encodeURI("多边形选");
				//var type:String=encodeURI("圈选");
				var param:String="stype="+type+"&point1=" + cldPoint.x + "," + cldPoint.y +
				"&R=" + dis;
					// "&R=" + _distance/1000;
				
				this.loadData(param);
				//this.loadTxt(
				
				
				
			}
		}
		protected function downHandler(e:MouseEvent):void
		{
			e.target.removeEventListener(MouseEvent.MOUSE_DOWN,downHandler);
			this.removeCircle(e.target as CLDCircle);
		}
		
		
	}
}