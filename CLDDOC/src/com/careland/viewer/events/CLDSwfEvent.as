package com.careland.viewer.events
{
	import flash.events.Event;
	
 
	public class CLDSwfEvent extends Event
	{
		public function CLDSwfEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
        public static var getPageIndex:String="getPageIndex";
        public var currentPage:int;
	}
}