package com.careland.viewer
{
	import flash.display.Loader;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.net.URLRequest;
	[Event(type="swfLoaded",type="flash.event.Event")]
	public class CLDDocLoader extends EventDispatcher
	{
		private var loader:Loader=new Loader;
		
		public var index:int=0;
		public var url:String;
		
		public var loaded:Boolean=false;
		
		public var content:MovieClip;
		
		public var totalPage:int;
		public function CLDDocLoader(target:IEventDispatcher=null)
		{
			super(target);
		}
		
		public function loadswf():void
		{
			loader.contentLoaderInfo.removeEventListener(Event.COMPLETE,complete);
			loader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR,ioError);
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE,complete);
			loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR,ioError);
			loader.load(new URLRequest(url));
		}
		private function complete(e:Event):void
		{
			content=e.target.content as MovieClip;
			content.stop();
			content.cacheAsBitmap=true;
			content.opaqueBackground=0xfffff;
			this.loaded=true;
			totalPage=content.totalFrames;
			this.dispatchEvent(new Event("swfLoaded"));
			
		}
		private function ioError(e:IOErrorEvent):void
		{
			e.target.removeEventListener(Event.COMPLETE,complete);
			e.target.removeEventListener(IOErrorEvent.IO_ERROR,ioError);
		}
		
		public function dispose():void
		{
			if(this.loader)
			{
				loader.unloadAndStop(true);
				
				
			}
			this.content=null;
		}
		
		
		
		
		
		
		
		
	}
}