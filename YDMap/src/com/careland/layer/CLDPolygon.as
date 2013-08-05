package com.careland.layer
{
	import __AS3__.vec.Vector;
	
	import com.careland.util.MapConfig;
	
	import flash.display.Graphics;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.utils.clearTimeout;
	import flash.utils.setTimeout;

	public class CLDPolygon extends CLDBaseMarker
	{
		private var points:Vector.<Point>=new Vector.<Point>();
		
		protected var screenPoints:Vector.<Point>=new Vector.<Point>();
	
		public var _border:Number=2;
		public var _alpha:Number=0.5;
		public var borderColor:int=0xCCCCCC;
		public var bgColor:int=0xff3322;
		
		public var filteralpha:Number=0.65;
		public function CLDPolygon()
		{
			super();
		}
		public function addPoint(p:Point):void
		{
			points.push(p);
		}
		
		public function addScreenPoint(p:Point):void
		{
			this.screenPoints.push(p);
		}
		override protected function overHandler(e:MouseEvent):void
		{
			super.overHandler(e);
			this.filteralpha=0.8;
			this.invalidate();
			
			var t:uint=flash.utils.setTimeout(function():void{
				flash.utils.clearTimeout(t);
				filteralpha=_alpha;
				invalidate();
				},3000);
			
			
		}
		
		public function change(center:Point,vscale:Number,vw:Number,vh:Number,gl:Point,mapConfig:MapConfig):void
		{
			screenPoints.splice(0,this.screenPoints.length);
			for each(var point:Point in points){
				
				var np:Point=this.getScreenPoint(point,center,vscale,vw,vh,gl,mapConfig);
				screenPoints.push(np);
			}
			//filteralpha=this._alpha;
			this.invalidate();
		}
		
		override public function draw():void
		{
			var g:Graphics=this.graphics;
			g.clear();
			if(_border>0)
			{
				g.lineStyle(_border,borderColor,filteralpha);
			}  
//			g.lineStyle(_border,borderColor,filteralpha);
			g.beginFill(bgColor,filteralpha);
			
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
		override public function dispose():void
		{
			super.dispose();
			var g:Graphics=this.graphics;
			g.clear();
		}
		
	}
}