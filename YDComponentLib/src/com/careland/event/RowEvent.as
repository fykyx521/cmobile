package com.careland.event
{
	import flash.events.Event;

	public class RowEvent extends Event
	{
		public function RowEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
		public static var rowClick:String="rowClick";
		public static var initHeight:String="initHeight";
		public static var loadDataFinish:String="loadDataFinish";
		public static var loadBtnDataFinish:String="loadBtnDataFinish";		
		public static var btnClick:String="btnClick";
		
		public static var locationResult:String="findlocationResult";
		
		public var colID:int=0;
		public var max:Number=0;
		public var mouseClickColor:int=0;
		public var mouseOutColor:int=0;
		public var ifLoad:Boolean;
		public var value:String;
		public var xml:XML;
		public var data:Array;
		public var cols:Array;
		public var GPS:int;  //gps 0  单个定位 gps 1 多个定位  gps 2 查询已定位的数据

	}
}