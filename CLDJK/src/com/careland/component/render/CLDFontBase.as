package com.careland.component.render
{
	import com.careland.component.CLDBaseComponent;
	
	import flash.display.DisplayObjectContainer;
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.net.URLRequest;
	import flash.text.Font;
	
	public class CLDFontBase extends Sprite
	{
		public function CLDFontBase()
		{
			//super(parent, xpos, ypos, autoLoad, timeInteval);
			
			if(stage)
			{
				initObj();
			}else
			{
				this.addEventListener(Event.ADDED_TO_STAGE,initObj);
			}
		}
		
		public function initObj(e:Event=null):void
		{
			this.removeEventListener(Event.ADDED_TO_STAGE,initObj);
			stage.scaleMode=flash.display.StageScaleMode.NO_SCALE;
			stage.align=flash.display.StageAlign.TOP_LEFT;
			stage.addEventListener(Event.RESIZE,resize);
			
			this.addChildren();
//		    this.scaleX=.5;
//		    this.scaleY=.5;
			
			//loadFont();  去除字体加载
			this.initLoad();
			
			//		 var contentID:String=this.loaderInfo.parameters["contentId"];
			//		 var url:String=this.loaderInfo.parameters["url"];
		}
		protected function addChildren():void
		{
			
		}
		
		
		private var loader:Loader;
		protected function loadFont():void
		{
			loader=new Loader();
			
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE,fontLoad);
			loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR,ioErrorHandler);
			loader.load(new URLRequest("assets/FontMsyh.swf"));
		}
		
		protected function fontLoad(e:Event):void
		{
			loader.contentLoaderInfo.removeEventListener(Event.COMPLETE,fontLoad);
			loader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR,ioErrorHandler);
			var obj:Object=e.target.content;
			Font.registerFont(obj.font);
			
			
			
			
			
		}
		protected function initLoad():void
		{
			trace("initLoad");
		}
		
		
		protected function ioErrorHandler(e:Event):void
		{
			loader.contentLoaderInfo.removeEventListener(Event.COMPLETE,fontLoad);
			loader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR,ioErrorHandler);
		}
		
		public function resize(e:Event):void
		{
			//		 if(jkstate)
			//		 {
			//			 jkstate.setSize(stage.stageWidth,stage.stageHeight);
			//			// flash.net.navigateToURL(new URLRequest("javascript:alert('resize')"));
			//		 }
			
			//this.setSize(1920,1080);
			
			
		}
	}
	
	
}