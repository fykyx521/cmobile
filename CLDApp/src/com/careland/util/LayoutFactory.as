package com.careland.util
{
	import com.careland.component.CLDLayoutUI;
	import com.soma.ui.layouts.LayoutUI;
	
	public class LayoutFactory extends LayoutFactory
	{
		
		
		public static function getLayout(num:int):CLDLayoutUI
		{
			var cld:Class=Class(flash.utils.getDefinitionByName("com.careland.layout.CLDLayout"+num-1));
			return (new cld as LayoutUI);
		}
	}
}