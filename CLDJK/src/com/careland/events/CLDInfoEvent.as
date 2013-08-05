package com.careland.events
{
	import flash.display.Sprite;
	import flash.events.Event;
	
	public class CLDInfoEvent extends Event
	{
		public static var INFO:String="info";
		public var width:Number;
		public var data:String;
		public var x:Number;
		public var y:Number;
		public var isShow:Boolean=true;
		
		public var targetObj:Object;
		public function CLDInfoEvent(type:String,bubbles:Boolean,cancel:Boolean)
		{
			super(type,bubbles,cancel);
			
		}
		
	}
}