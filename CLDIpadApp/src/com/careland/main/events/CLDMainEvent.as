package com.careland.main.events
{
	import flash.events.Event;
	
	public class CLDMainEvent extends Event
	{
		public static var SHOWDESK:String="main_showDesk";
		public function CLDMainEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
	}
}