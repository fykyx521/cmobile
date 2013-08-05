package com.identity.picBox
{
	import com.careland.component.TUIOTouchObj;
	
	import flash.display.Bitmap;

	public class CLDPhoto extends TUIOTouchObj
	{
		
		private var _bit:Bitmap;
		public function CLDPhoto()
		{
			super();
		}
		
		public function addBit(bit:Bitmap):void
		{
			_bit=bit;
			this.addChild(bit);	
		}
		
		override public function setSize(w:Number, h:Number):void
		{
			super.setSize(w,h);
			if(_bit){
				_bit.width=w;
				_bit.height=h;
			}
		}
		override public function set width(value:Number):void
		{
			super.width=value;
			if(_bit)
			{
				_bit.width=value;
			}	
		}
		override public function removeBlob(id:Number):void
		{
			super.removeBlob(id);
			
		}
		override public function set height(h:Number):void
		{
			super.height=h;
			if(_bit)
			{
				_bit.height=h;
			}	
		}
		override public function dispose():void
		{
			super.dispose();
			removeBit();
		}
		
		public function removeBit():void
		{
			if(_bit){
				this.removeChild(this._bit);
				_bit.bitmapData.dispose();
				_bit=null;
			}
			
		}
		
	}
}