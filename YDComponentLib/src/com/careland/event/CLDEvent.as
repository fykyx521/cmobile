package com.careland.event
{
	import flash.events.Event;

	public class CLDEvent extends Event
	{
		public static var IS_MAP_WIN:String="isMapWindow";
		public static var WINUP:String="windowUp";
		public static var WINCLOSEWIN:String="win_close_win";
		
		public static var SWFCLICK:String="swfClick";
		
		public static var SWFINIT:String="swfInit";
		
		public static var ITEMCLICK:String="itemClick";
		
		public static var ALERTWIN:String="alertWin";//弹出窗口
		
		public static var MARKERCLICK:String="markerCLICK";
		
		public static var rightClick:String="rightClick";//右键点击
		
		public var id:int=-1;
		
		public var touchID:Number;
		public var stageX:Number;
		public var stageY:Number;
		
		public var obj:Object;
		public var mouseClickData:String;
		public var parm:String;
		
		public function CLDEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
		
	}
}