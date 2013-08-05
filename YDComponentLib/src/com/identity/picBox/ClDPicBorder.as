package com.identity.picBox
{
	import br.com.stimuli.loading.BulkLoader;
	
	import com.careland.component.CLDBaseComponent;
	import com.careland.event.ImgEvent;
	
	import flash.display.*;
	import flash.events.*;
	import flash.geom.Point;
	import flash.net.URLRequest;
	import flash.ui.*;
	import flash.utils.getTimer;
	/**
	 * QQ相册单张图片
	 */
	public class ClDPicBorder extends CLDBaseComponent
	{
		private var path:String;
		private var bulkLoader:BulkLoader;
		private var picBorder:Bitmap=new Bitmap();		 
		private var loader:Loader=new Loader();
		public var images:Bitmap=new Bitmap();
		public var _withs:int;
		public var _heights:int;
		
		public var img:Bitmap;
		
		
		private var step:int;
		public function ClDPicBorder(url:String)
		{
		 
			this.path=url;
			//this.path="images/709/10.jpg";
			loadIMG(); //加载图片
		}
		override public function dispose():void
		{
			super.dispose();
			
			
			this.path=null;
			if(this.bulkLoader!=null){
				this.bulkLoader=null;
			}
			if(this.picBorder!=null){
				if(picBorder.bitmapData){
					picBorder.bitmapData.dispose();
				}
					
				this.picBorder=null;
			}
			 
			if(this.loader!=null){
				this.loader.unload();
				this.loader=null;
			}
			if(this.images!=null){
				this.images=null;
			}
			
			this._withs=null;
			this._heights=null;
		}

		/**
		 *
		 * 覆盖父类添加子例方法
		 */
		override protected function addChildren():void
		{
		     buildBorder(); //绘制边框
		}
		
 
	
		/**
		 *
		 * 覆盖父类画布方法
		 */
		override public function draw():void
		{
			if(this.picBorder){
				picBorder.width=this.width ;			 
				picBorder.height=this.height;
			}
			
			 
		}
        public function getBitmap(key:*):Bitmap
		{

			return this.config.getBitmap(key);
		}
		/**
		* 绘制边框
		*/
	 
		private function buildBorder():void
		{		

			picBorder.bitmapData=config.getBitmap("picBorder").bitmapData.clone();
			picBorder.x=0;
			picBorder.y=0;
			picBorder.width=this.width;
			picBorder.height=this.height;
			this.addChild(picBorder);
			 
		}

		/**
		* 绘制图片
		*/
		private function loadIMG():void
		{

			var request:URLRequest=new URLRequest(this.path);
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, loadImgComplete);
			loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR,imgLoadError);
			loader.load(request);
		}
		
		private function imgLoadError(e:Event):void
		{
			e.target.removeEventListener(Event.COMPLETE, loadImgComplete);
			e.target.removeEventListener(IOErrorEvent.IO_ERROR,imgLoadError);
		}
		
		

		/**
		* 加载图片完成(大图)
		*/
		private function loadImgComplete(e:Event):void
		{
			e.target.removeEventListener(Event.COMPLETE, loadImgComplete);
			e.target.removeEventListener(IOErrorEvent.IO_ERROR,imgLoadError);
			loader=Loader(e.target.loader);
			
			
			var image:Bitmap=new Bitmap(Object(loader.content).bitmapData.clone());
			
			this._withs = loader.content.width;
			this._heights = loader.content.height;
			image.width=this.width -10;			 
			image.height=this.height - 12;			 
			image.x=5 ;
			image.y=5;
			this.addEventListener(MouseEvent.MOUSE_DOWN, downHandler);
		
 			this.addChild(image);
 			this.img=image;
 			
 			try{
				loader.unload();
				Object(loader.content).bitmapData.dispose();
			}catch(e:Error){
				
			}
//			images.bitmapData=image.bitmapData.clone();
//			images.height=_heights;
//			images.width=_withs;
		}
		private var prePoint:Point;
		private var preTime:int;
		
		private function downHandler(e:MouseEvent):void
		{
			prePoint=new Point(e.stageX,e.stageY);
			preTime=flash.utils.getTimer();
			this.addEventListener(MouseEvent.MOUSE_UP,upHandler);
		}
		private function upHandler(e:MouseEvent):void
		{
			var newPoint:Point=new Point(e.stageX,e.stageY);
			var newTime:int=flash.utils.getTimer();
			this.removeEventListener(MouseEvent.MOUSE_UP,upHandler);
			
			var disPoint:Point=newPoint.subtract(prePoint);
			var dis:int=Math.sqrt(Math.abs(disPoint.x*disPoint.x+disPoint.y*disPoint.y));
			if(dis<40&&newTime-preTime<1000)
			{
				preTime=newTime;
				var imgevent:ImgEvent=new ImgEvent(ImgEvent.photoClick);
				imgevent.img=this.img;
				imgevent._width=this._withs;
				imgevent._height=this._heights;
				this.dispatchEvent(imgevent);
			}
			
		}
		/**
		* 图片点击
		*/
		private function imageClick(e:MouseEvent):void
		{ 
			
		}
		 
		private function mouseWheel(e:MouseEvent):void
		{ 
//			var imgevent:ImgEvent=new ImgEvent(ImgEvent.mouseWheel);
//			imgevent.img=this.images;
//			imgevent._width=this._withs;
//			imgevent._height=this._heights;
//			this.dispatchEvent(imgevent);
		}
		 
	}
}