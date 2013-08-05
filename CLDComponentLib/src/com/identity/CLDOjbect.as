package com.identity
{
	import flash.display.Bitmap;
	import flash.display.Sprite;

	public class CLDOjbect extends Sprite
	{
		public function CLDOjbect()
		{
			super();
		}
		public var data:Object;
		public var bit:Bitmap;
		public var mouseOverData:String;
	    public var mouseClickData:String;
	    public var title:String;
		public function build():void{
		 
 
		   this.addChild(bit);
		
		}
	}
}