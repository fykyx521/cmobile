package com.careland.component
{
	import com.careland.component.cldwinclasses.CLDBorder;
	import com.careland.component.cldwinclasses.CLDRect;
	import com.careland.component.cldwinclasses.CLDTab;
	import com.careland.component.touch.TouchBase;
	
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	public class CLDTouchWindow extends TouchBase
	{
		
		private var w:Number=0;
		private var h:Number=0;
		
		private var border:CLDBorder;
		private var rect:CLDRect;
		
		private var tab:CLDTab;
		public function CLDTouchWindow(parent:DisplayObjectContainer=null, xpos:Number=0, ypos:Number=0)
		{
			super();
		}
		 
		
		
	}
}