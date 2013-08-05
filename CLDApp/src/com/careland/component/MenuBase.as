package com.careland.component
{
	import com.careland.YDBase;
	
	import flash.geom.Point;

	public class MenuBase extends YDBase implements IMenu
	{
		public var level:int=0;
		public var menuID:int;
		public var menuName:String;
		
		public var disX:Number;//
		public var disY:Number;
		
		public function MenuBase()
		{
			super();
		}
		
		public function cloneImg():MenuBase
		{
			return null;
		} 
		
		public function getTargetPoint():Point
		{
			return null;
		}
		
		public function getLevel():int
		{
			return level;
		}
		public function dispose():void
		{
			
		}
		
	}
}