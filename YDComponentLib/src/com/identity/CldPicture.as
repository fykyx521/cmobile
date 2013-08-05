package com.identity
{
	import com.careland.component.CLDBaseComponent;
	
	import flash.display.Bitmap;
	import flash.display.DisplayObjectContainer;
	import flash.display.Loader;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.net.URLRequest;
/**
 * 图片组件
 * code by xiaolb 2011-3-31
 * 
 * */
	public class CldPicture extends CLDBaseComponent
	{
		private var imgID:int;
		public var imgUrl:String;		
		private var image:Bitmap;
		private var loader:Loader=new Loader(); 
		private var isLoad:Boolean=false;
		public var autoSize:Boolean=false;
		public function CldPicture(parent:DisplayObjectContainer = null, xpos:Number = 0, ypos:Number =  0,
			autoLoad:Boolean=false,timeInteval:int=0)
		{
			
		}
		override public function dispose():void{
		   if(loader) 
		   try{
		   		loader.contentLoaderInfo.removeEventListener(Event.COMPLETE, completeHandler);
				loader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR,IoEvent);
		   		loader.close();	
		   }catch(e:Error){
		   	
		   }
		   super.dispose();
		  
		   loader.unload();
		   if(image)image.bitmapData.dispose();
		   this.imgID=null;
		   this.imgUrl=null;
		   this.image=null;
		   this.loader=null;
		   this.isLoad=null;
		}
	   /**
	   * 重写基类addChildren方法。增加子对象
	   * loadImg();子类要实现的方法名称
	   * */
	   
		override protected function addChildren():void{
			 if(imgUrl)
            {
           	   loadImg(imgUrl);
            }
		}
		//重写图片的宽，高
		override public function draw():void
		{
			
			if(data&&!this.isLoad){
				this.imgUrl=XML(data).data.@url;
				this.loadImg(imgUrl);
			}
			if(image&&autoSize){
				image.width=this.width;
				image.height=this.height;
			}
		}
		public function loadImg(url:String):void
		{
			if(loader){
				loader.contentLoaderInfo.addEventListener(Event.COMPLETE, completeHandler);
				loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR,IoEvent);
        		var request:URLRequest = new URLRequest(url);
       	    	//loader.x =width-100;
        		loader.load(request);
			}
			  
		}
		
		//图片加载完成
		public function completeHandler(event:Event):void
		{
			event.target.removeEventListener(Event.COMPLETE, completeHandler);
			event.target.removeEventListener(IOErrorEvent.IO_ERROR,IoEvent);
		    loader = Loader(event.target.loader);	  
		    image = Bitmap(loader.content);   
		    image.smoothing=true; 
		    isLoad=true;		    
            this.addChild(image);
            this.invalidate();	
		}
		//加载图片时发生意外错误
		public function IoEvent(event:IOErrorEvent):void
		{
		   trace(imgUrl);
		}
		 
		

	}
}