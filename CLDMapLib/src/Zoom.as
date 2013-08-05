package
{
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.geom.Matrix;
	import flash.events.Event;
	import flash.geom.Point;
	//import fl.motion.*; /** * ... * @author Lancelot */

	public class Zoom extends Sprite
	{
		private var imgSprite:Sprite;
		private var num:Number=4;
		private var scale:Number=1;
		private var scaleDest:Number=1;
		private var small:Boolean=false;
		private var speed:Number=0;

		public function Zoom(image:Bitmap)
		{
			this.addChild(image);
//			if (image != null)
//			{
//				returnImageSprite(image);
//			}
//			else
//			{
//				trace("没有图片");
//			}
			image.smoothing=true;
		}
		public function play():void
		{
			
		}

		private function returnImageSprite(image:Bitmap):Sprite
		{
			imgSprite=new Sprite();
			image.x=image.width / 2;
			image.y=image.height / 2;
			imgSprite.addChild(image);
			addChild(imgSprite);
			this.addEventListener(Event.ENTER_FRAME, imgTween);
			return (imgSprite);
		}

		private function imgTween(evt:Event):void
		{
			if (!small)
			{
				scaleDest*=1.0008;
			}
			else
			{
				scaleDest-=0.0005;
			}
			scale+=(scaleDest - scale) / num;
			if (scale > 1.3)
				small=true;
			if (scale < 1.1)
				small=false;
			var m:Matrix=imgSprite.transform.matrix;
			m.identity();
			m.scale(scale, scale);
			imgSprite.transform.matrix=m;
		}
	}
}

