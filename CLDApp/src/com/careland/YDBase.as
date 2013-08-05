package com.careland
{
	import com.careland.command.CLDCommandHandler;
	import com.careland.command.ICommand;
	import com.careland.command.Message;
	import com.careland.remote.CLDRemoteEvent;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.external.ExternalInterface;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	
	public class YDBase extends Sprite implements ICommand
	{
		
		protected var sw:Number=1920;
		protected var sh:Number=1080;
		private var remoteEvent:CLDCommandHandler=CLDCommandHandler.instance();
		public function YDBase()
		{
			this.register();
			this.addEventListener(CLDRemoteEvent.READ_COMMAND,remoteHandler);
		}
		protected var load:Loader;
		
		private var urlLoader:URLLoader;
		public var blobContainerEnabled:Boolean=false;
		
		public var cldConfig:YDConfig=YDConfig.instance();
		protected function loadSwf(url:String):void
		{
			loadContent(url,loadComplete);
			
		}
		protected function loadImage(url:String):void
		{
			loadContent(url,loadComplete);
			
		}
		public function getBitmap(key:String,clone:Boolean=true)
		{
			var bitdata:Bitmap=this.cldConfig.getBitmap(key);
			if(clone)
			{
				var bit:Bitmap=new Bitmap(bitdata.bitmapData.clone());
				return bit;
			}
			return bitdata;
			
			
		}
		protected function loadContent(url:String,func:Function):void
		{
			if(!load){
				load=new Loader();
			}
			load.contentLoaderInfo.addEventListener(Event.COMPLETE,func);
			load.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR,ioerror);
			load.load(new URLRequest(url));
			
		}
		protected function ioerror(e:IOErrorEvent):void
		{
			trace("ioError"+e.text);
		}
		protected function loadTxt(url:String,data:Object,func:Function):void
		{
			if(!urlLoader){
				urlLoader=new URLLoader();
				
			}
			urlLoader.addEventListener(Event.COMPLETE,func);
			var urlRequest:URLRequest=new URLRequest(url);
			if(data){
				urlRequest.method="post";
				urlRequest.data=data;
			}
			urlLoader.load(urlRequest);
			
		}
		protected function disposeXML(xml:XML):void
		{
			this.cldConfig.disposeXML(xml);
		}
		
		protected function loadXML(url:String,data:Object=null):void
		{
			loadTxt(url,data,loadXMLComplete);
		}
		
		public function loadProduce(resultFunction:Function,procedure:String,params:String="",isWeburl:Boolean=false):void
		{
			var pstr:String=encodeURI(procedure);
			var pparam:String=encodeURI(params);
			var url:String=cldConfig.produceurl;
			if(isWeburl){
				url=cldConfig.produceweburl;
			}
			var purl:String=url+"?SpName="+pstr+"&paramsString="+pparam+"&"+Math.random();
			var postRequest:URLRequest=new URLRequest(purl);
			postRequest.method="post";
			//postRequest.data="<params><param name='"+procedure+"' args='"+params+"'></param></params>";
			if(!this.urlLoader){
				urlLoader=new URLLoader();
			}
			urlLoader.addEventListener(IOErrorEvent.IO_ERROR,ioError);
			urlLoader.addEventListener(Event.COMPLETE,resultFunction);
			urlLoader.load(postRequest);
			if(flash.external.ExternalInterface.available)
			{
				//flash.external.ExternalInterface.call("test","存储过程"+procedure);
			}
			//this.cldConfig.loadProduce(resultFunction,procedure,params);
		}
		
		protected function ioError(e:IOErrorEvent):void
		{
			e.target.removeEventListener(IOErrorEvent,ioError);
		}
		
		protected function loadComplete(e:Event):void
		{
			if(this.load){
				load.contentLoaderInfo.removeEventListener(Event.COMPLETE,loadComplete);
			}
		}
		protected function loadXMLComplete(e:Event):void
		{
			if(this.load){
				load.contentLoaderInfo.removeEventListener(Event.COMPLETE,loadComplete);
			}
		}
		
		
		protected function createUI():void{
			
		}
		protected function updateUI():void
		{
			
		}
		protected function layoutUI():void
		{
			
		}
		public function removeAllChild():Array
		{
			var arr:Array;
			while(this.numChildren>0){
				arr.push(this.removeChildAt(0));
			}
			return arr;
		}
		public function registerCommand(...types:Array):void
		{
			 for each(var type:String in types)
			 {
				 this.remoteEvent.registerCommand(type,this);
			 }
			
		}
		public function register():void
		{
			
		}
		
		public function remoteHandler(e:CLDRemoteEvent):void
		{
			 this.handlerRemote(e.message);
		}
		protected function handlerRemote(obj:Message):void
		{
			
		}
		
	}
}