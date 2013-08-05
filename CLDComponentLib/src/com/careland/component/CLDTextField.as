package com.careland.component
{
	import com.careland.YDConfig;
	
	import flash.text.TextField;
	
	public class CLDTextField extends TextField
	{
		private var config:YDConfig=YDConfig.instance();
		public function CLDTextField()
		{
			super();
		}
		
		override public function set embedFonts(value:Boolean):void
		{
			//如果是web则加载字体
			if(config.webConfig)
			{
				super.embedFonts=value;
			}else
			{
				super.embedFonts=false;
			}
			
		}
	}
}