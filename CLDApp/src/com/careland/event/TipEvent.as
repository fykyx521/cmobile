package com.careland.event
{
	import flash.events.Event;

	public class TipEvent extends Event
	{
		public static var SHOW_BORDER:String="cld_show_Border";
		public static var HIDE_BORDER:String="cld_hide_Border";
		public static var SHOW_TIP:String="cld_show_tip";
		public static var HIDE_TIP:String="cld_hide_tip";
		public function TipEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
		
	}
}