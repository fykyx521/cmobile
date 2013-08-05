package com.careland.component.scrollbar.classes
{
	import flash.events.Event;
	
	public class CLDScrollEvent extends Event
	{
		public static var SCROLL:String="SCROLL";
		public var value:Number;
		public function CLDScrollEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
	}
}