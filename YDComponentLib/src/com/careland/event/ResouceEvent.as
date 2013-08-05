package com.careland.event
{
	import flash.events.Event;

	public class ResouceEvent extends Event
	{
		public static var PROGRESS:String="cld_progress";
		public static var COMPLETE:String="cld_complete";
		public static var RESOURCELOADED:String="resourceLoaded";
		public var content:*;
		public var byteLoad:Number;
		public var byteTotal:Number;
		public function ResouceEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
		
	}
}