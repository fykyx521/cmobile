package com.cglib.views
{
	import com.touchlib.TUIOEvent;
	
	import flash.display.Sprite;
	import flash.events.MouseEvent;

	public class basicMultiTouchButton extends Sprite
	{
		public function basicMultiTouchButton()
		{
			super();
			
			this.addEventListener(TUIOEvent.TUIO_CLICK,onTuioClick);
			this.addEventListener(TUIOEvent.TUIO_DOWN,onTUIO_DOWN);
			this.addEventListener(TUIOEvent.TUIO_UP,onTUIO_UP);
			this.addEventListener(TUIOEvent.TUIO_OVER,onTUIO_OVER);
			this.addEventListener(TUIOEvent.TUIO_OUT,onTUIO_OUT);
		}
		protected function onTuioClick(evt:TUIOEvent):void{
			this.dispatchEvent(new MouseEvent(MouseEvent.CLICK));
		}
		
		protected function onTUIO_DOWN(evt:TUIOEvent):void{
			this.dispatchEvent(new MouseEvent(MouseEvent.MOUSE_DOWN));
		}
		protected function onTUIO_UP(evt:TUIOEvent):void{
			this.dispatchEvent(new MouseEvent(MouseEvent.MOUSE_UP));
		}
		protected function onTUIO_OVER(evt:TUIOEvent):void{
			this.dispatchEvent(new MouseEvent(MouseEvent.MOUSE_OVER));
		}
		protected function onTUIO_OUT(evt:TUIOEvent):void{
			this.dispatchEvent(new MouseEvent(MouseEvent.MOUSE_OUT));
		}		
	}
}