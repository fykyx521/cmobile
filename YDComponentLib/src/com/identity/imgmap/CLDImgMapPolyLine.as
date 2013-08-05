package com.identity.imgmap
{
	import com.careland.layer.CLDPolyLine;

	public class CLDImgMapPolyLine extends CLDPolyLine
	{
		
		override public function set data(value:*):void
		{
			super.data=value;
		}
		
		public function CLDImgMapPolyLine()
		{
			super();
		}
		
	}
}