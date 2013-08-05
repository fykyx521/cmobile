package com.careland
{
	
	
	import flash.events.Event;
	//各个窗体 块的基类
	public class YDTouchComponent extends YDBase
	{
//		public var maskW:Number;
//		public var maskH:Number;
		public function YDTouchComponent()
		{
			super();
			this.addEventListener(Event.ADDED_TO_STAGE,addToStage);
			//this.blobContainerEnabled=true;
			
		}
		protected function addToStage(e:Event):void{
			this.removeEventListener(Event.ADDED_TO_STAGE,addToStage);
			this.createUI();
			stage.addEventListener(Event.RESIZE,resizeHandler);
		}
		
		protected function invalidate():void
		{
			this.addEventListener(Event.ENTER_FRAME,enter);
		}
		private function enter(e:Event):void
		{
			this.removeEventListener(Event.ENTER_FRAME,enter);
			this.updateUI();	
		}
//		public function setSize(w,h):void
//		{
//			this.maskW=w;
//			this.maskH=h;
//			this.invalidate();
//		}
		protected function resizeHandler(e:Event):void
		{
			this.layoutUI();
		}
		
		
		
	}
}