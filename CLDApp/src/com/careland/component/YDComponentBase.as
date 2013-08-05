package com.careland.component
{
	import com.careland.YDBase;

	public class YDComponentBase extends YDBase
	{
		
		public function YDComponentBase()
		{
			super(); 
			createUI();
		}
		
		public function initConfig(data:Object):void
		{
			var icon:String=data.icon;
			var selectIcon:String=data.selectedIcon;
			
		}
		
		
		
	}
}