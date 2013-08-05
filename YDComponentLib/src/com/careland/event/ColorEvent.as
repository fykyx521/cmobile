package com.careland.event
{
	import com.identity.map.CLDColorManage;
	
	import flash.events.Event;

	public class ColorEvent extends Event
	{
		public function ColorEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
		public static var colorClick:String="colorClick";
		public static var colorState:String="colorState";//如果返回数据是 色带格式，则抛出事件
		public var index:int;
		public var color:String;
		public var colorManage:CLDColorManage;
	}
}