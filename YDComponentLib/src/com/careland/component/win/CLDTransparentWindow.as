package com.careland.component.win
{
	import flash.display.DisplayObjectContainer;
	import com.careland.component.CLDWindow;

	public class CLDTransparentWindow extends CLDWindow
	{
		public function CLDTransparentWindow(parent:DisplayObjectContainer=null, xpos:Number=0, ypos:Number=0, autoLoad:Boolean=false, timeInteval:int=0)
		{
			super(parent, xpos, ypos, autoLoad, timeInteval);
		}
		override protected function addChildren():void
		{
			super.addChildren();
			this.border.visible=false;
			this.rect.visible=false;
		}
		
		
	}
}