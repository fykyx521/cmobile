package com.careland.layer
{
	import com.careland.util.CLDConfig;
	import com.careland.util.MapConfig;
	
	import flash.display.Graphics;
	import flash.geom.Point;
	
	public class CLDCircle extends CLDBaseMarker
	{
		private var _radius:Number;
		
		private var _screenPoint:Point;
		
		private var _radiusp:Point;//记录中心点坐标左移radius坐标,为了放大缩小地图时计算它的半径
		
		private var _distance:Number;//半径的实际距离
		public function CLDCircle()
		{
			super();
		}
		
		public function get distance():Number
		{
			return this._distance;
		}
		public function set radius(value:Number):void
		{
			this._radius=value;
		}
		
		public function set radiusp(value:Point):void
		{
			this._radiusp=value;
		}
		
		
		public function set screenPoint(value:Point):void
		{
			this._screenPoint=value;
		}
		public function get screenPoint():Point
		{
			return this._screenPoint;
		}
		
		
		
		
		public function change(center:Point,vscale:Number,vw:Number,vh:Number,gl:Point,mapconfig:MapConfig):void
		{
			this.screenPoint=this.getScreenPoint(this.cldPoint,center,vscale,vw,vh,gl,mapconfig);
			var screenP1:Point=this.getScreenPoint(this._radiusp,center,vscale,vw,vh,gl,mapconfig);
			this._radius=Math.abs(screenP1.x-this.screenPoint.x);//计算半径
			this.invalidate();
		}
		
		
		override public function draw():void
		{
			var g:Graphics=this.graphics;
			g.clear();
			g.lineStyle(1,0xCCCCCC);
			g.beginFill(0xff3322,.3);
		
			g.drawCircle(this.screenPoint.x,this.screenPoint.y,this._radius);
			g.endFill();
			
		}
		
	}
}