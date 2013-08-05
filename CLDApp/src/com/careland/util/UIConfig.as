package com.careland.util
{
	import flash.events.EventDispatcher;

	public class UIConfig extends EventDispatcher
	{
		
		private static var _instance:UIConfig;
		public function UIConfig()
		{
			super();
			if(this!=_instance){
				_instance=this;
			}
		}
		public static function instance():UIConfig
		{
			if(!_instance){
				_instance=new UIConfig;
			}
			return _instance;
		}
		
		
		
	}
}