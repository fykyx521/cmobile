package com.careland.event
{
	import flash.events.Event;
	
	public class LogoEvent extends Event
	{
		public static var HIDE:String="hideLogo";
		public static var SHOW:String="showLogo";
		public function LogoEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
		
	}
}