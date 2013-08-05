package com.careland.component.layout
{
	import flash.display.DisplayObjectContainer;
	
	//特殊布局
	public class CLDLayout13 extends CLDLayout12
	{
		public function CLDLayout13(parent:DisplayObjectContainer=null, xpos:Number=0, ypos:Number=0, autoLoad:Boolean=false, timeInteval:int=0, isSwitchWin:Boolean=false)
		{
			super(parent, xpos, ypos, autoLoad, timeInteval, false);
		}
		
		override protected function pauseXML(data:*):void
		{
			
		}
		
		
	}
}