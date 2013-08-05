package com.careland.layer
{
	import __AS3__.vec.Vector;
	
	import com.careland.util.MapConfig;
	
	import flash.display.Graphics;
	import flash.geom.Point;

	public class CLDPolyLine extends CLDBaseMarker
	{
		protected var _border:Number;
		protected var _lineColor:uint;
		public   var lineWidth:Number=1;
		
		public var lineAlpha:Number=1;
		private var points:Vector.<Point>=new Vector.<Point>();
		
		public var id:int;
		
		protected var screenPoints:Vector.<Point>=new Vector.<Point>();
		
		public function CLDPolyLine()
		{
			super();
		}
		
		public function set lineColor(value:uint):void
		{
			this._lineColor=value;		
		}
		
		public function addPoint(p:Point):void  
		{
			points.push(p);
		}
		
		public function setPoints(value:Vector.<Point>):void
		{
			this.points=value;	
		}
		
		public function addScreenPoint(p:Point):void
		{
			screenPoints.push(p);
		}
		
		public function clearPoint():void
		{
			this.points.splice(0,points.length);
			
		}
		
		
		public function change(center:Point,vscale:Number,vw:Number,vh:Number,gl:Point,mapConfig:MapConfig):void
		{
			screenPoints.splice(0,this.screenPoints.length);
			for each(var point:Point in points){
				
				var np:Point=this.getScreenPoint(point,center,vscale,vw,vh,gl,mapConfig);
				screenPoints.push(np);
			}
			this.invalidate();
		}
		
		override public function draw():void
		{
			var g:Graphics=this.graphics;
			g.clear();
			g.lineStyle(lineWidth,this._lineColor,lineAlpha);
			if(screenPoints.length<2)
			{
				g.endFill();
				
				return;
			}
			if(screenPoints.length>1){
				g.moveTo(screenPoints[0].x,screenPoints[0].y);
			}
			
			var num:int=0;
			while(num<screenPoints.length){
				var p:Point=screenPoints[num];
				g.lineTo(p.x,p.y);
				num++;
			}
			g.endFill();
			
		}
		public function clear():void
		{
			this.graphics.clear();
		}
		
		override public function dispose():void
		{
			super.dispose();
			var g:Graphics=this.graphics;
			g.clear();
		}
		
	}
}