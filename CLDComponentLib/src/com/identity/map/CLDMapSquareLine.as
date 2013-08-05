package com.identity.map
{
	/**
	 * 地图网格线
	 */
	import com.careland.layer.CLDMarker; 
	public class CLDMapSquareLine extends CLDMarker
	{
		public function CLDMapSquareLine()
		{ 
		}
        override public function draw():void
		{
			 this.graphics.clear();
			 this.graphics.beginFill(0xfff333,.9);
			//this.graphics.drawRect(0,0,this.width,this.height);
			 this.graphics.drawRect(0,0,10,10);
			 this.graphics.endFill();
		}
	}
}