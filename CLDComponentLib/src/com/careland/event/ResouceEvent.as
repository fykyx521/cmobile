package com.careland.event
{
	import flash.events.Event;

	public dynamic class ResouceEvent extends Event
	{
		public static var PROGRESS:String="cld_progress";
		public static var COMPLETE:String="cld_complete";
		public static var RESOURCELOADED:String="resourceLoaded";
		public var content:*;
		public var byteLoad:Number;
		public var byteTotal:Number;
		public var itemLoaded:Number;
		public var totalItems:Number; 
		public function ResouceEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);  
		}
		
	}
}