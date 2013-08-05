package com.careland.main.ui.item
{
	public class CLDMenuModel
	{
		public var menuType:int=1;//默认是第一级菜单抛出的事件
		private var _menuName:String;
		private var _menuID:int;
		private var _data:*;
		public function CLDMenuModel()
		{
			
		}

		public function get menuName():String
		{
			return _menuName;
		}

		public function set menuName(value:String):void
		{
			_menuName = value;
		}

		public function get menuID():int
		{
			return _menuID;
		}

		public function set menuID(value:int):void
		{
			_menuID = value;
		}

		public function get data():*
		{
			return _data;
		}

		public function set data(value:*):void
		{
			_data = value;
		}


	}
}