package com.cglib.views
{
	import com.touchlib.TUIOEvent;
	
	import flash.display.MovieClip;
	import flash.events.MouseEvent;

	public class basicButton extends MovieClip
	{
		public function basicButton()
		{
			super();
			
			this.addEventListener(MouseEvent.MOUSE_DOWN,onMouseDown);
			this.addEventListener(MouseEvent.MOUSE_OVER,onMouseDown);
			this.addEventListener(TUIOEvent.TUIO_DOWN,onTuioDown);
			this.addEventListener(TUIOEvent.TUIO_OVER,onTuioDown);
			
			this.addEventListener(MouseEvent.MOUSE_UP,onMouseOut);
			this.addEventListener(MouseEvent.MOUSE_OUT,onMouseOut);
			this.addEventListener(TUIOEvent.TUIO_UP,onTuioOut);
			this.addEventListener(TUIOEvent.TUIO_OUT,onTuioOut);
			
			this.gotoAndStop(1);
		}
		protected function onMouseDown(evt:MouseEvent):void{
			this.gotoAndStop(2);
			
		}
		protected function onMouseOut(evt:MouseEvent):void{
			this.gotoAndStop(1);
		}
		
		protected function onTuioDown(evt:TUIOEvent):void{
			this.gotoAndStop(2);
			
		}
		protected function onTuioOut(evt:TUIOEvent):void{
			this.gotoAndStop(1);
		}
	}
}