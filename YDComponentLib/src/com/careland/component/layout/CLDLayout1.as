package com.careland.component.layout
{
	import com.careland.component.CLDLayoutUI;
	import com.careland.component.CLDWindow;
	
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.events.Event;

	public class CLDLayout1 extends CLDLayoutUI
	{
		
		public function CLDLayout1(parent:DisplayObjectContainer=null, xpos:Number=0, ypos:Number=0, autoLoad:Boolean=false, timeInteval:int=0)
		{
			super(parent, xpos, ypos, autoLoad, timeInteval);
		}
		
		
		
		override protected function layout():void
		{
		
			var realW:Number=this.width-this._spacing;//间隔
			var realH:Number=this.height;
			
			var xpos:Number = 0;
			for(var i:int = 0; i < numChildren; i++)
			{
				var child:DisplayObject = getChildAt(i);
				child.x = xpos;
				child.width=realW/2;
				child.height=this.height;
				//child.height=this._spacing;
				xpos +=child.width;
				xpos += _spacing;
				
			}
		
		}
	}
}