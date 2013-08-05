package com.careland.event
{
	import flash.events.Event;
	
	import uk.co.teethgrinder.global.Global;

	public class CLDEvent extends Event
	{
		public static var IS_MAP_WIN:String="isMapWindow";
		
		public static var WINUP:String="windowUp";
		
		public static var WINIPADUP:String="win_ipad_up";//ipad上窗体停止拖放事件
		
		public static var WINCLOSEWIN:String="win_close_win";
		
		public static var SWFCLICK:String="swfClick";
		
		public static var SWFINIT:String="swfInit";
		
		public static var ITEMCLICK:String="itemClick";
		
		public static var ALERTWIN:String="alertWin";//弹出窗口
		
		public static var ALERTGLOBALWIN:String="alert_Global_Win";//弹出窗口
		
		public static var MARKERCLICK:String="markerCLICK";
		
		public static var rightClick:String="rightClick";//右键点击
		
		public  static var WIN_ZOOM_START:String="local_win_zoom_start"; //窗体 zoom开始事件 
		public  static var WIN_ZOOM_ING:String="local_win_zoom";  //zoom中 
		public  static var WIN_ZOOM_END:String="local_win_zoom_end"; //zoom结束事件 
		
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