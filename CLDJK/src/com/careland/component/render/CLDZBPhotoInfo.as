package com.careland.component.render
{
	import com.careland.component.CLDBaseComponent;
	import com.careland.util.BMPDecoder;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObjectContainer;
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	import flash.external.ExternalInterface;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.utils.ByteArray;
	
	public class CLDZBPhotoInfo extends CLDBaseComponent
	{
		
		private var photoLoader:Loader;
		private var bit:Bitmap;
		
		private var txt:TextField;
		
		
		[Embed(source="assets/值班信息/照片框 顶.png")]
		private var up:Class;
		private var upBit:Bitmap;
		
		[Embed(source="assets/值班信息/照片框 中间.png")]
		private var cen:Class;
		private var cenBit:Bitmap;
		
		[Embed(source="assets/值班信息/照片框 底.png")]
		private var bot:Class;
		private var botBit:Bitmap;
		
		private var photo:Sprite;
		
		private var zhize:TextField;
		
		public static var baseURL:String="../files/";
		
		public function CLDZBPhotoInfo(parent:DisplayObjectContainer=null, xpos:Number=0, ypos:Number=0, autoLoad:Boolean=false, timeInteval:int=0)
		{
			super(parent, xpos, ypos, autoLoad, timeInteval);
		}
		override protected function addChildren():void
		{
			
			photo=new Sprite;
			upBit=new up as Bitmap;
			photo.addChild(upBit);
			cenBit=new cen as Bitmap;
			photo.addChild(cenBit);
			botBit=new bot as Bitmap;
			photo.addChild(botBit);
			this.addChild(photo);
			
			cenBit.y=20;
			cenBit.height=400;
			botBit.y=420;
			
			photo.x=54;
			photo.y=74;
			
			
			if(!photoLoader)
			{
				photoLoader=new Loader();
				photoLoader.contentLoaderInfo.addEventListener(Event.COMPLETE,complete);
				photoLoader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR,ioError0);
				//photoLoader.load(new URLRequest("a.png"));
			}
			if(!txt)
			{
				txt=new TextField();
				txt.multiline=false;
				//txt.embedFonts=true;
				txt.wordWrap=false;
				txt.selectable=false;
				txt.defaultTextFormat=new TextFormat("msyh",30,0x01314d)
				this.addChild(txt);
			}
			
			if(!zhize)
			{
				zhize=new TextField();
				zhize.multiline=true;
				//zhize.embedFonts=true;
				zhize.wordWrap=true;
				zhize.selectable=false;
				zhize.defaultTextFormat=new TextFormat("msyh",30,0x01314d)
				this.addChild(zhize);
			}
			
		}
		private function complete(e:Event):void
		{
			photoLoader.contentLoaderInfo.addEventListener(Event.COMPLETE,complete);
			photoLoader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR,ioError0);
			photoLoader.contentLoaderInfo.addEventListener(SecurityErrorEvent.SECURITY_ERROR,securityError);
			addPhoto(e.target.content);
		}
		private function addPhoto(bitdata:Bitmap)
		{
			if(bit)
			{
				try  
				{
					this.removeChild(bit);
					bit.bitmapData.dispose();
					bit=null;
				}catch(e:Error)
				{
					
				}
			}
			bit=bitdata;
			bit.x=8;
			bit.y=8;
			bit.width=350-16;
			bit.height=420;
			photo.addChild(bit);
		}
		private function loadPhoto(url:String)
		{
			if(url!="")
			{
				 var args:Array= url.split(".");
				 if(args.length>1)
				 {
					  if(String(args[1]).toLowerCase()=="bmp")
					  {
						    loadBmp(baseURL+url);
					  }else
					  {
						  photoLoader.load(new URLRequest(baseURL+url));
					  }
				 }
			}
		}
		private var urlLoader:URLLoader;
		private function loadBmp(url):void
		{
			 urlLoader=new URLLoader();
			 urlLoader.dataFormat=flash.net.URLLoaderDataFormat.BINARY;
			 urlLoader.addEventListener(Event.COMPLETE,bmpComplete);
			 urlLoader.addEventListener(IOErrorEvent.IO_ERROR,ioError1);
			 urlLoader.addEventListener(SecurityErrorEvent.SECURITY_ERROR,securityError);
			 urlLoader.load(new URLRequest(url));
		}
		private function bmpComplete(e:Event):void
		{
			urlLoader.removeEventListener(Event.COMPLETE,bmpComplete);
			urlLoader.removeEventListener(IOErrorEvent.IO_ERROR,ioError1);
			var bytes:ByteArray=urlLoader.data;
			var bmp:BMPDecoder=new BMPDecoder();
			
			var bit:BitmapData=bmp.decode(bytes);
			this.addPhoto(new Bitmap(bit));
		}
		private function ioError0(e:IOErrorEvent):void
		{
			photoLoader.contentLoaderInfo.removeEventListener(Event.COMPLETE,complete);
			photoLoader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR,ioError0);
			if(flash.external.ExternalInterface.available)
			{
				flash.external.ExternalInterface.call("flashError",e,e.text);
			}
		}
		private function ioError1(e:IOErrorEvent):void
		{
			urlLoader.removeEventListener(Event.COMPLETE,complete);
			urlLoader.removeEventListener(IOErrorEvent.IO_ERROR,ioError1);
			if(flash.external.ExternalInterface.available)
			{
				flash.external.ExternalInterface.call("flashError",e,e.text);
			}
		}
		private function securityError(e:SecurityError):void
		{
			
			if(flash.external.ExternalInterface.available)
			{
				flash.external.ExternalInterface.call("flashSError",e,e.message);
			}
		}
		
		
		public var gwop:Object;
		
		override public function draw():void
		{
			
			 if(data&&this.dataChange)
			 {
				 txt.text=data.gw+":"+data.name;
				 
				 //zhize.text="岗位职责:"+data.gwzz;
				 txt.width=txt.textWidth+5;
				 this.photoLoader.unload();
				// photoLoader.load(new URLRequest(baseURL+data.url));
				 
				 loadPhoto(data.url);
			 }
			 if(txt)
			 {
				txt.y=36;
				txt.x=(this.width-txt.textWidth)/2;
			 }
			 if(zhize)
			 {
				 zhize.x=5;
				 zhize.y=530;
				 zhize.width=this.width-10;
			 }
			
		}
	}
}