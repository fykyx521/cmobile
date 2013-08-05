package com.identity.SingleNode
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.SimpleButton;

	public class BitmapButton extends SimpleButton
	{
		
		
		public function BitmapButton( bitmapUp:Bitmap, bitmapOver:Bitmap, bitmapDown:Bitmap)
		{
			upState = bitmapUp;
			hitTestState = bitmapUp;
			downState = bitmapDown;
			overState = bitmapOver;
		}
		
		public function setUpState( bitmapUp:Bitmap):void
		{
			upState = bitmapUp;
			hitTestState = bitmapUp;
		}
		
		public function setOverState( bitmapUp:Bitmap):void
		{
			overState = bitmapUp;
		}
		
	}
}