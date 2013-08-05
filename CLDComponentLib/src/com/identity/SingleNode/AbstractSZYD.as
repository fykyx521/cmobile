package com.identity.SingleNode
{
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;

	public class AbstractSZYD extends Sprite
	{
		protected var xmlLoader:URLLoader;
		protected var Imgloader:Loader;
		public function AbstractSZYD() 
		{
			super();
		}
		
		//加载读取node
		protected function load(xmlurl:String,onLoad:Function):void{
			xmlLoader=new URLLoader();
			xmlLoader.addEventListener(Event.COMPLETE,onLoad);
			xmlLoader.load(new URLRequest(xmlurl));
		}
		
		protected function loadImg(url:String,onLoad:Function):void{
			Imgloader=new Loader();
			Imgloader.contentLoaderInfo.addEventListener(Event.COMPLETE,onLoad);
			Imgloader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR,ioError);
			Imgloader.load(new URLRequest(url));
		}
		protected function ioError(e:IOErrorEvent):void
		{
			
		}
		
		
	}
}