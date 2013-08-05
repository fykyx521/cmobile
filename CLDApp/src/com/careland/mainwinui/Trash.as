package com.careland.mainwinui
{
	import com.careland.*;
	
	import flash.display.Bitmap;
	import flash.events.Event;

	public class Trash extends YDTouchComponent
	{
		
		private var isLoad:Boolean=false;
		public function Trash()
		{
			super();
			this.addChild(this.cldConfig.getBitmap("trash"));
		}
		
	
		override protected function layoutUI():void{
			//this.y=1200-145;
		}
	}
}