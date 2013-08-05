package com.careland.events
{
	import flash.events.Event;

	public class MapEvent extends Event
	{
		public static var MapChange:String="map_change_type";
		
		public static var MapTouchMarker:String="map_touch_marker";
		
		public static var MapClearLayer:String="map_clear_layer";
		
		public static var MapAddLayer:String="map_update_Layer";
		
		public static var MapMouseOver:String="map_mouse_over";
		
		public static var MapMouseRightClick:String="map_mouse_right_click";
		
		public var stageX:Number;
		public var stageY:Number;
		public var mapType:int=0;
		
		public function MapEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
		override public function clone():Event
		{
			var me:MapEvent=new MapEvent(this.type);
		
			me.mapType=this.mapType;
			return me;
		}
		
	}
}