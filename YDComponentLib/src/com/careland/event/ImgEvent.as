package com.careland.event
{
	import flash.display.Bitmap;
	import flash.events.Event;

	public class ImgEvent extends Event
	{
		public static var mouseClick:String="mouseClick";
		public static var mouseWheel:String="mouseWheel";
		
		public static var listItemClick:String="listItemClick";
		
		public static var photoClick:String="cld_photo_click";

		public static var MapSetClick:String="MapSetClick";

		public var img:Bitmap;
		public var _width:int;
		public var _height:int;
		public var id:int;
		public var contentID:String;
		public var object:Object;
		public var stageX:Number;
		public var stageY:Number;
		public var data:*;//传递的数据
		public function ImgEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
		override public function clone():Event
		{
			var e:ImgEvent=new ImgEvent(this.type);
			e.stageX=this.stageX;
			e.stageY=this.stageY;
			e.object=this.object;
			e._height=this._height;
			e._width=this._width;
			e.img=this.img;
			return e;
		}
		
	}
}