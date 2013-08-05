package com.careland.events
{
	import flash.events.Event;
	import flash.geom.Point;

	public class MapEvent extends Event
	{
		public static var MapChange:String="map_change_type";
		
		public static var MapTouchMarker:String="map_touch_marker";
		
		public static var MapClearLayer:String="map_clear_layer";
		
		public static var MapAddLayer:String="map_update_Layer";
		
		public static var MapMouseOver:String="map_mouse_over";
		
		public static var MapMouseRightClick:String="map_mouse_right_click";
		
		public static var ConfigMapChange:String="config_map_change_type"; //地图切换
		
		public static var MapTypeChange:String="map_type_change";//
		
		public static var MapLocationChange:String="map_location_change";//地图center zoom 地图类型改变的事件
		
		public var stageX:Number;
		public var stageY:Number;
		public var mapType:int=0;
		public var zoom:int=0;
		public var center:Point;
		
		public var isFirst:Boolean=false;//
		public var mapTileNum:int=0;//3个   判断是否是初始的第一个  1nav导航图 2 影像图 3 2.5D图
		public var mapTypeData:Object;
		
		
		
		
		public function MapEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
		override public function clone():Event
		{
			var me:MapEvent=new MapEvent(this.type);
			me.stageX=this.stageX;
			me.stageY=this.stageY;
			me.zoom=this.zoom;
			me.isFirst=this.isFirst;
			me.mapTileNum=this.mapTileNum;
			me.mapTypeData=this.mapTypeData;
			me.mapType=this.mapType;
			me.center=this.center;
			return me;
		}
		
	}
}