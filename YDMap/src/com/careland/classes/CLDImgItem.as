package com.careland.classes
{
	import caurina.transitions.Tweener;
	
	import com.adobe.images.PNGEncoder;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.net.URLRequest;
	import flash.system.ApplicationDomain;
	import flash.system.LoaderContext;
	import flash.system.System;
	import flash.utils.ByteArray;
	


	/**
	 * @private
	 * */
	public class CLDImgItem extends Sprite
	{
		
		public var info:Object;
		public var id:String;
		public var urlLoader:Loader=new Loader();
		public var urlstr:String;
		public var content:Bitmap; 
		public var isLoad:Boolean=false;
		
		public var bytes:ByteArray;
		
		public var isLoadBytes:Boolean=false;
		
		public var isUser:Boolean=false;
		
		public function CLDImgItem(i:Object=null,u:String=""){
			this.info=i;
			this.urlstr=u;		
			this.isLoad=false;
		}
	public function load():void
	{
		this.id=info.id;
		var urlR:URLRequest=new URLRequest(urlstr);
		if(!this.urlLoader)
		{
			this.urlLoader=new Loader();
		}
		urlLoader.contentLoaderInfo.addEventListener(Event.COMPLETE,complete);
		urlLoader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR,ioError);
		
		var context:LoaderContext=new LoaderContext(false,ApplicationDomain.currentDomain,null);
//		context.allowCodeImport=true;
		//context.allowLoadBytesCodeExecution=true;
		if(this.isLoadBytes)
		{
			this.urlLoader.loadBytes(this.bytes,context);
		}else
		{
			urlLoader.load(urlR);
		}
		
		
		
		
	}
	public function complete(e:Event):void
	{
		
		urlLoader.contentLoaderInfo.removeEventListener(Event.COMPLETE,complete);
		urlLoader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR,ioError);
		//this.bytes=e.target.bytes;
		this.content=e.target.content as Bitmap;
	
		this.bytes=PNGEncoder.encode(content.bitmapData);
		
		if(!content)
		{
			trace(e.target);
		}
		
		//this.content=new Bitmap(content.bitmapData);
		this.addChild(content);
		isLoad=true;
		this.dispatchEvent(e);
		
		//this.alpha=0.3;
		//Tweener.addTween(this,{alpha:1,time:.3});
	}
	private function ioError(e:Event):void
	{
		urlLoader.contentLoaderInfo.removeEventListener(Event.COMPLETE,complete);
		urlLoader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR,ioError);
		var bit:BitmapData=new BitmapData(256,256,false,0xffffff);
		content=new Bitmap(bit);
		this.addChild(content);
	}
	
	public function clone():CLDImgItem
	{
		var img:CLDImgItem=new CLDImgItem(this.info,this.urlstr);
		img.content=new Bitmap(this.content.bitmapData);
		img.isLoadBytes=this.isLoadBytes;
		img.bytes=this.bytes;
		img.isLoad=this.isLoad;
		return img;
	}
	
	public function dispose():void
	{
		
		if(content){
			content.bitmapData.dispose();
			this.removeChild(content);
		}
		if(this.urlLoader)
		{
			this.urlLoader.unload();
			try{
				urlLoader.close();
			}catch(e:Error)
			{
				
			}

			urlLoader.contentLoaderInfo.removeEventListener(Event.COMPLETE,complete);
			urlLoader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR,ioError);
			
			
		}
		if(this.bytes)
		{
			this.bytes.clear();
			this.bytes=null;
		}
		this.urlLoader=null;
		this.content=null;
		this.info=null;
		this.urlstr=null;
	}
		
		
	}
}