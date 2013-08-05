package com.careland.events
{
	import __AS3__.vec.Vector;
	
	import flash.events.Event;
	import flash.geom.Point;

	public class MapDataEvent extends Event
	{
		
		public static var Map_Circle_Data:String="cld_map_circle_data";
		public var distance:Number;//两点 之间的距离
		public var sourcepoint:Point;//源坐标
		
		public static var MAP_RECT_DATA:String="cld_map_rect_data";
		
		public static var MAP_MUTI_RECT_DATA:String="cld_map_muti_rect_data";
		
		public static var MAP_DATA_TIP:String="map_addmarker_tip";//添加tip,和changeLayer
		
		public static var MAP_DATA_TIP_ERROR:String="map_addmarker_tip_error";//加载提示出错
		
		public var mouseOverData:String="";
		
		public var toPoint:Point;
		
		public var isShow:Boolean=false;
		
		public var points:Vector.<Point>;
		

		public function MapDataEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
		
	}
}