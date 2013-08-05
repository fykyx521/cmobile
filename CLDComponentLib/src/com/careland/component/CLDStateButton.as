package com.careland.component
{
	import com.touchlib.TUIOEvent;
	
	import flash.display.Bitmap;
	import flash.display.DisplayObjectContainer;
	import flash.events.MouseEvent;
	import flash.filters.BitmapFilter;
	import flash.filters.GlowFilter;

	public class CLDStateButton extends CLDBaseComponent
	{
		private var src:Bitmap;
		private var downbit:Bitmap;
		private var _press:Boolean=false;
		public function CLDStateButton(parent:DisplayObjectContainer=null, xpos:Number=0, ypos:Number=0, autoLoad:Boolean=false, timeInteval:int=0)
		{
			super(parent, xpos, ypos, autoLoad, timeInteval);
			
//			this.addEventListener(TUIOEvent.TUIO_DOWN, downHandler, false, 0, true);	
//			this.addEventListener(TUIOEvent.TUIO_UP, upHandler, false, 0, true);	
			
			  
		}
		
		
		override protected function addChildren():void
		{
			
			if(src){
				this.addChild(src);
			}
			if(this.downbit){
				this.addChild(downbit);
				downbit.visible=false;
			}
		}
		 
		public function set press(value:Boolean):void
		{
			   this._press=value;
			   if(value)
			   {
				   downHandler();
			   }else
			   {
				   upHandler();
			   }
		}
		public function get press():Boolean
		{
			return this._press;
		}
		
		public function setBit(src:Bitmap,down:Bitmap):void{
			this.src=new Bitmap(src.bitmapData.clone());
			this.downbit=new Bitmap(down.bitmapData.clone());
			this.addChildren();
		}
		private function  getFilters():BitmapFilter
		{
			var g:GlowFilter=new GlowFilter();
			return g;
		}
		private function downHandler(e:TUIOEvent=null):void{
			src.visible=false;
			downbit.visible=true;
			//this.filters=[getFilters()];
			
		}
		private function upHandler(e:TUIOEvent=null):void{
			src.visible=true;
			downbit.visible=false;
			//this.filters=null;
		}
		override public function dispose():void
		{
			super.dispose();
			if(src){
				src.bitmapData.dispose();
				src=null;
			}
			if(downbit){
				downbit.bitmapData.dispose();
				downbit=null;
			}
			this.removeEventListener(TUIOEvent.TUIO_DOWN, downHandler);	
			this.removeEventListener(TUIOEvent.TUIO_UP, upHandler);	
		}
		
	}
}