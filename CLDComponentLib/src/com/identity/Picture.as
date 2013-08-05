package com.identity
{
	import com.careland.component.CLDBaseComponent;
	
	import flash.display.Bitmap;
	import flash.display.Loader;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.net.URLRequest;
/**
 * 图片组件
 * code by xiaolb 2011-3-31
 * 
 * */
	public class Picture extends CLDBaseComponent
	{
		private var imgID:int;
		private var imgUrl:String;		
		private var image:Bitmap;
		 
		public function Picture(url:String)
		{ 			
             this.imgUrl=url;
             loadImg();
		} 
		override public function dispose():void{
		  super.dispose();
		  this.imgID=null;
		  this.imgUrl=null;
		  this.image=null;
		  
		}
	   /**
	   * 重些基类addChildren方法。增加子对象
	   * loadImg();子类要实现的方法名称
	   * */
	   
		override protected function addChildren():void{
			
		}
		//重写图片的宽，高
		override public function draw():void
		{
			if(image){
				image.width=this.width;
				image.height=this.height;
			}
		}
		public function loadImg():void
		{
			var request:URLRequest=new URLRequest(this.imgUrl);	
		    var loader:Loader=new Loader();
			    loader.contentLoaderInfo.addEventListener(Event.COMPLETE,complete);		
			    loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR,onError); 
			    loader.load(request);	 
		}
		
		//图片加载完成
		public function complete(e:Event):void
		{
		   var  bit:Bitmap=e.target.content;		 	   
		  
		  
		   		    
            this.addChild(bit);
            this.invalidate();
		
		
		}
		//加载图片时发生意外错误
		public function onError(event:IOErrorEvent):void
		{
		        trace(imgUrl);
		}
		 

	}
}