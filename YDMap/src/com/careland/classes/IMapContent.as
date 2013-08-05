package com.careland.classes
{
	import flash.geom.Point;
	/**
	 * @private
	 * */
	public interface IMapContent
	{
		 function get data():Object;
		
		 function addContents(path:String,lp:Point,isRemove:Boolean=false):void
		 function dispose():void
		 function set loadedImg(value:Array):void
		 function changeURL(path:String,src:String):String;
		 function get url():String;//获取加载图片路径
		 
	}
}