package com.careland.main.events
{
	import com.careland.main.ui.item.CLDMenuModel;
	
	import flash.events.Event;
	
	public class CLDMenuEvent extends Event
	{
		public static var MENUCLICK:String="menu_click";
		public static var Menu3Show:String="Menu3Show";
		public static var Menu3Hide:String="Menu3Hide";
		public var data:*;
		public var menuModel:CLDMenuModel;
		public function CLDMenuEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
	}
}