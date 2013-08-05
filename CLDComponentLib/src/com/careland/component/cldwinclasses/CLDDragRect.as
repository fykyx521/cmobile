package com.careland.component.cldwinclasses
{
	import com.careland.component.CLDBaseComponent;
	import com.careland.component.CLDWindow;
	
	import flash.display.Graphics;
	import flash.geom.Point;

	public class CLDDragRect extends CLDBaseComponent
	{
		protected var color:uint;
		protected var valpha:Number;
		
		
		public var dis:CLDWindow;
		public var disP:Point;
		public var oldPoint:Point;
		
		public function CLDDragRect(color:uint=0xffffff,alpha:Number=.13)
		{
			super();
			this.color=color;
			this.valpha=alpha;
		}
 
		override public function draw():void
		{
			var g:Graphics=this.graphics;
			g.clear();
			g.beginFill(color,valpha);
			g.drawRoundRect(0,0,width,height,10,10);
			g.endFill();
		} 
		
	}
}