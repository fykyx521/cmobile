package com.careland.viewer
{
	import com.touchlib.TUIOEvent;
	
	import flash.display.DisplayObjectContainer;
	import flash.events.Event;

	public class CLDTouchDocView extends CLDDocView
	{
		private var blobs:Array=[];
		private var state:String="none";
		public function CLDTouchDocView(parent:DisplayObjectContainer=null, xpos:Number=0, ypos:Number=0, autoLoad:Boolean=false, timeInteval:int=0)
		{
			super(parent, xpos, ypos, autoLoad, timeInteval);
		}
		override protected function addChildren():void
		{
			
			super.addChildren();
			this.addEventListener(TUIOEvent.TUIO_DOWN,tuioDownHandler);
			this.addEventListener(TUIOEvent.TUIO_DOWN,tuioUpHandler);
		}
		private function tuioDownHandler(e:TUIOEvent):void
		{
			for(var i:int=0;i<this.blobs.length;i++){
				
				if(e.ID==this.blobs[i].ID)
				{
					return;
				}
				
			}
			this.blobs.push({ID:e.ID});
			if(this.blobs.length==0){
				this.state="none";
			}
			if(this.blobs.length==2){
				this.state="zoom";
			}
		}
		private function tuioUpHandler(e:TUIOEvent):void
		{
			for(var i:int=0;i<this.blobs.length;i++){
				
				if(e.ID==this.blobs[i].ID)
				{
					blobs.splice(i,1);
				}
				
			}
			if(this.blobs.length==2){
				this.state="zoom";
			}
		}
		public function update(e:Event):void
		{
			
		}
		
	}
}