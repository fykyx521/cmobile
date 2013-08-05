package com.careland.events
{
	import flash.display.Bitmap;
	import flash.events.Event;

	public class ItemEvent extends Event
	{
		public static var ITEM_LOAD:String="item_load";
		public var x:Number;
		public var y:Number;
		public var content:Bitmap;
		public var index:Number;
		public function ItemEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
		
	}
}