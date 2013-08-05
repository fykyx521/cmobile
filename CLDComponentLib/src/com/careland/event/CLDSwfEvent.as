package com.careland.event
{
	import flash.events.Event;

	public class CLDSwfEvent extends Event
	{
		public var id:String="";
		public static var flashClick:String="flashClick";
		public static var pointClick:String="pointClick";
		public var btnType:String;
		public var obj:Object;
		public var eventType:String;  
		public function CLDSwfEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
		override public function clone():Event
		{
			var e:CLDSwfEvent=new CLDSwfEvent(this.type);
			e.obj=this.obj;
			e.eventType=this.eventType;
			e.id=this.id;
			return e;
		}
	}
}