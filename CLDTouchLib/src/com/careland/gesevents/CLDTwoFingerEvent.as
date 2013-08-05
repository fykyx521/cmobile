package com.careland.gesevents
{
	import flash.events.Event;

	public class CLDTwoFingerEvent extends Event
	{
		
		public static var CLD_TWO_FINGER_TAB:String="cld_two_finger_tab";
		
		public var localX:Number;
		public var localY:Number;
		public var stageX:Number;
		public var stageY:Number;
		public var releatObj:Object;
		public var data:*;
		
		
		public function CLDTwoFingerEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
		
	}
}