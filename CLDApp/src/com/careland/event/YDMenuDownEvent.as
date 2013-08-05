package com.careland.event
{
	import flash.events.Event;

	public class YDMenuDownEvent extends Event
	{
		public var stageX:Number;
		public var stageY:Number;
		public var touchID:int;
		public var localX:Number;
		public var localY:Number;
		
		public var disX:Number;//
		public var disY:Number;
	
		public static var YDMENU_DOWN:String="yd_menu_down";
		public static var YDMENU_UP:String="yd_menu_up";
		public function YDMenuDownEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
		
	}
}