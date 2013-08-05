package com.identity
{
	import com.careland.component.CLDBaseComponent;
	
	import flash.display.AVM1Movie;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.net.URLRequest;
	import flash.utils.ByteArray;
	
	import sban.flexStudy.avm1to2.AVM1MvoieProxy;
    /**
     * FLASH组件
     * author:chengbb
     * 
     **/
	public class CLDFlash extends CLDBaseComponent
	{
 
		protected var url:String;		
		public var flashObject:Sprite;
		private var loader:Loader;		 
		private var isLoad:Boolean=false;
		public var id:int;
		public var mouseOverData:String;
		private var content:DisplayObject;
		
		private var avm1:AVM1MvoieProxy;
		public function CLDFlash(parent:DisplayObjectContainer = null, xpos:Number = 0, ypos:Number =  0,
			autoLoad:Boolean=false,timeInteval:int=0)
		{
			
		}
		override public function dispose():void{
		  super.dispose();
		  try{
		  	 this.loader.removeChild(content);
		  }catch(e:Error)
		  {
		  	
		  }
		  if(loader)loader.unloadAndStop(true);
		  this.url=null;
		  this.flashObject=null;
		  this.loader=null;
		  this.isLoad=null;
		  this.id=null;
		  this.mouseOverData=null;
		  this.content=null;
    	}
		
		override protected function addChildren():void{
			 if(!flashObject){
			 	flashObject=new Sprite;
			 	this.addChild(flashObject);
			 }			
		}
		public function initLoad(url:String):void
		{
			
			this.url=url;
			
			this.load();
		}
		public function initLoadByte(bt:ByteArray):void
		{
			loader=new Loader;
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, completeHandler);
			loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, flashLoadError);						
	    	loader.loadBytes(bt);
		}
		
		
		//重写图片的宽，高
		override public function draw():void
		{
			
			if(data&&!this.isLoad&&this.dataChange){
				this.url=XML(data).data.@url;
				//this.url="CLDFlexTest.swf";
				this.load();
				this.dataChange=false;
			}
			
			
//			
			if(content){
				content.width=this.width;
				content.height=this.height;
				//Object(content).gotoAndPlay(2);
				
			}
		}
		public function load():void
		{
			if(this.content!=null) return;
			loader=new Loader;
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, completeHandler);
			loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, flashLoadError);						
	    	
	    	  	
	    	var request:URLRequest = new URLRequest(url);
        	loader.load(request);    
        	
            //loader.visible=false;  	
		}
		private function flashLoadError(e:IOErrorEvent):void{
			//throw new  IOError(e.text);
			e.target.removeEventListener(Event.COMPLETE, completeHandler);
			e.target.removeEventListener(IOErrorEvent.IO_ERROR, flashLoadError);
		}
		
		
		//加载完成
		public function completeHandler(e:Event):void
		{
			e.target.removeEventListener(Event.COMPLETE, completeHandler);
			e.target.removeEventListener(IOErrorEvent.IO_ERROR, flashLoadError);	    	    
		    var obj:Object=e.target.content;
		 	content=obj as  DisplayObject;		
		 	if(content is AVM1Movie){

		 		this.addChild(loader);
		 	}else{

				 if(content&&this.flashObject.contains(content)){
				 	flashObject.removeChild(content);
				 	
				 }
		 		 this.flashObject.addChild(content);		
		 	}
            isLoad=true;
            this.invalidate();	
            
		}
		
	
	}
}