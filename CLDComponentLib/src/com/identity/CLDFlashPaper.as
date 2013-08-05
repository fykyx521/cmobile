package com.identity
{
	import flash.display.DisplayObjectContainer;
	import flash.events.Event;
	import flash.utils.ByteArray;
	
	import com.careland.events.DynamicEvent;

	public class CLDFlashPaper extends CLDFlash
	{
		//private var flash:CLDFlash;
		
		private var systemManager:Object
		public var docURL:String;
		private var application:Object;//主应用
		public function CLDFlashPaper(parent:DisplayObjectContainer=null, xpos:Number=0, ypos:Number=0, autoLoad:Boolean=false, timeInteval:int=0)
		{
			super(parent, xpos, ypos, autoLoad, timeInteval);
		}
		
		override protected function addChildren():void
		{
			//var byte:ByteArray=this.config.getBinary("FlexPaper");
			this.initLoad("CLDFlexTest.swf");
			//this.initLoad("assets/FlexPaperNoUI.swf");
			
			//this.initLoadByte(byte);
			
		}
		
		override public function draw():void
		{
			if(data&&!this.dataChange){
				this.docURL=String(data);
//				this.docURL=XML(data).data.@url;
				this.dataChange=false;
			}
			if(application){
				application.setSize(this.width,this.height);
				if(this.docURL)application.setSwf(this.docURL);
				
			}
		}
		override public function completeHandler(event:Event):void
		{
			super.completeHandler(event);
			var obj:Object=event.target.content;
			this.systemManager=obj;
			if(!obj.document){
				obj.addEventListener("swfInit",flashPaperInit);
			}
		}
		
		
		private function flashPaperInit(e:DynamicEvent):void
		{
			systemManager.removeEventListener("swfInit",flashPaperInit);
			
			application=e.obj;
			application.setSize(this.width,this.height);
			application.setSwf("Paper.swf");
			if(this.docURL){
				
			}
		}
		override public function dispose():void
		{
			super.dispose();
			if(application)application.setSwf("");
			this.application=null;
			this.systemManager=null;
		}
		
		
		
	}
}