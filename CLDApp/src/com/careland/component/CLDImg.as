package  com.careland.component
{
	import flash.display.BitmapData;
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.filters.BevelFilter;
	import flash.filters.DropShadowFilter;
	import flash.geom.Matrix;
	import flash.net.URLRequest;
	public dynamic class CLDImg extends CLDWindow
	{
		private var imgWidth:Number;
		private var imgHeight:Number;
		private var imgUrl:String;
		private var imgLoader:Loader;
		private var imgContainer:Sprite;
		public function CLDImg(_imgUrl:String,_imgWidth=240,_imgHeight:Number=320)
		{
			imgUrl = _imgUrl;
			imgWidth = _imgWidth;
			imgHeight = _imgHeight;
			imgContainer = new Sprite;
			addChild(imgContainer);
			imgLoader = new Loader;
			imgLoader.load(new URLRequest(imgUrl));
			imgLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, imgLoaded);
		}
		private function imgLoaded(e:Event)
		{
			var imgShadowFilter:DropShadowFilter = new DropShadowFilter(8);
			imgShadowFilter.inner = true;
			var imgBevelFilter:BevelFilter = new BevelFilter(6);
			imgBevelFilter.highlightColor = 0x999999;
			//
			var imgRef:Sprite = new Sprite();
            var myBitmap:BitmapData = new BitmapData(imgLoader.width, imgLoader.height,true);
            myBitmap.draw(imgLoader, new Matrix(1,0,0,-1,0,imgLoader.height));
            var matrix:Matrix = new Matrix();
            imgRef.graphics.beginBitmapFill(myBitmap, matrix,false);
            imgRef.graphics.drawRect(0, 0, imgLoader.width, imgLoader.height);
            imgRef.graphics.endFill();
			imgRef.width = imgWidth;
			imgRef.height = imgHeight;
			imgRef.x = -imgWidth / 2;
			imgRef.y = imgHeight / 2;
			imgRef.alpha = .3;
			//imgRef.filters = [imgShadowFilter, imgBevelFilter];
            imgContainer.addChild(imgRef);
			
			imgLoader.width = imgWidth;
			imgLoader.height = imgHeight;
			imgLoader.x = -imgWidth / 2;
			imgLoader.y = -imgHeight / 2;
			//imgLoader.filters = [imgShadowFilter, imgBevelFilter];
			imgContainer.addChild(imgLoader);
			this.addChild(imgContainer);
		}
	}
}