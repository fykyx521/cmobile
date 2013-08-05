package com.cglib.Events
{
	public class MssEvent extends myEvent
	{
		public static var DiskInserted:String="com.cglib.Events.DiskInserted";
		public static var DiskRemoved:String="com.cglib.Events.DiskRemoved";
		public static var childInitialized:String="com.cglib.Events.childInitialized";
		
		public var volume:String;
		public var cmddata:XML;
		public var ID:String;
		public var X:Number;
		public var Y:Number;
		public function MssEvent(type:String, bubbles:Boolean=true, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
		
	}
}