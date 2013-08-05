package com.careland.event
{
	import flash.display.InteractiveObject;
	import flash.events.Event;
	

	public class CLDTouchEvent extends Event
	{
		
		public static var WINUP:String="windowUp";
		
		public var touchID:int;
		
		public function CLDTouchEvent(arg0:String, arg1:Boolean=false, arg2:Boolean=false, arg3:Number=null, arg4:Number=null, arg5:Number=null, arg6:Number=null, arg7:InteractiveObject=null, arg8:Array=null)
		{
			super(arg0, arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8);
		}
		
	}
}