package com.careland.util
{
	import com.careland.YDTouchComponent;
	
	import flash.display.Graphics;

	public class ActiveRectMask extends YDTouchComponent
	{
		private var _width:Number;
		private var _heigth:Number;
		public function ActiveRectMask()
		{
			super();
		}
		override protected function updateUI():void
		{
			
			var g:Graphics=this.graphics;
			g.clear();
			g.beginFill(0x000000,0);
			g.drawRect(0,0,this._width,this._heigth);
			g.endFill();
		}
		override public function set height(value:Number):void
		{
			this._heigth=value;
			this.invalidate();
		}
		
		override public function set width(value:Number):void
		{
			this._width=value;
			this.invalidate();
		}
		
		
	}
}