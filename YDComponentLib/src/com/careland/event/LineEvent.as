package com.careland.event
{
	import __AS3__.vec.Vector;
	
	import com.identity.timer.CLDTimerModel;
	
	import flash.geom.Point;
	
	public class LineEvent extends CLDEvent
	{
		
		public static var LINEINIT:String="lineInit";
		public var points:Vector.<CLDTimerModel>;
		public var timerModel:CLDTimerModel;
		
		public static var MarkerChange:String="Marker_change";
		public var center:Point;
		public var radio:int=-1;
		public var changeCenter:Boolean=false;
		public function LineEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
		
	}
}