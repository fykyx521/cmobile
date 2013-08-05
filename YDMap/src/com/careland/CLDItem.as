package com.careland
{
	import flash.display.Bitmap;
	import flash.display.Sprite;
	
	public class CLDItem extends Sprite
	{
		public var title:String;
		public var content:Bitmap;
		public var info:Object;
		public function CLDItem(title:String,content:Bitmap,info:Object)
		{
			this.title=title;
			this.content=new Bitmap(content.bitmapData.clone());	
			this.info=info;
			this.addChild(content);
		}

	}
}