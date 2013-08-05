package com.careland.component
{
	import com.careland.YDBase;
	import com.touchlib.TUIOEvent;
	
	import flash.display.Bitmap;
	


	public class YDBitmapTouchButton extends YDBase
	{
		private var src:Bitmap;
		private var downbit:Bitmap;
		public function YDBitmapTouchButton(_src:Bitmap,_downbit:Bitmap)
		{
			super();
			this.src=new Bitmap(_src.bitmapData.clone());
			this.downbit=new Bitmap(_downbit.bitmapData.clone());
			this.addChild(src);
			this.addChild(downbit);
			
			downbit.visible=false;
			

			this.addEventListener(TUIOEvent.TUIO_DOWN, downHandler, false, 0, true);	
			this.addEventListener(TUIOEvent.TUIO_UP, upHandler, false, 0, true);	
			
		}
		private function click(e:TUIOEvent):void
		{
			this.dispatchEvent(e);
		}
		private function downHandler(e:TUIOEvent):void{
			src.visible=false;
			downbit.visible=true;
			
		}
		private function upHandler(e:TUIOEvent):void{
			src.visible=true;
			downbit.visible=false;
			
		}
	}
}