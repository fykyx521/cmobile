package com.careland.util
{
	import caurina.transitions.Tweener;
	
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.events.Event;

	public class CLDZoom extends Sprite
	{
		private var sprite:Sprite;
		
		private var zoomSprite:Sprite;
		public function CLDZoom(bit:Bitmap)
		{
			super();
			sprite=new Sprite;
			sprite.addChild(bit);
			
			
			zoomSprite=new Sprite;
			zoomSprite.addChild(sprite);
			this.addChild(zoomSprite);
			 
		}
		
		public function play(x:Number,y:Number,num:int):void
		{
			zoomSprite.x=x;
			zoomSprite.y=y;
			sprite.x=-x;
			sprite.y=-y;
			if(num>0){
				Tweener.addTween(this.zoomSprite,{scaleX:2,scaleY:2,time:1,alpha:0.1,onComplete:complete});
			}else{
				Tweener.addTween(this.zoomSprite,{scaleX:.5,scaleY:.5,time:1,alpha:0.1,onComplete:complete});
			}
			
		}		
		private function complete():void
		{
			this.dispatchEvent(new Event("zoomEnd"));
		}
	}
}