package com.careland.viewer.util
{
	import com.careland.viewer.CLDDocLoader;
	
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	
	public class LoaderManager extends EventDispatcher
	{
		public var loaded:Array=[];
		private var numLoad:int=0;//总共加载的swf
		public var loadedLength:int=0;
		public var loadList:Array=[];
		
		public var totalPage:int;
		
		public var width:Number;
		public var height:Number;
		public function LoaderManager()
		{
			
		}
		
		public function loadSwfs(data:Array):void
		{
			numLoad=data.length;
			for(var i:int=0;i<data.length;i++)
			{
				this.load(data[i].url,i);
			}
		}
		
		private function load(url:String,index:int):void
		{
			var docLoader:CLDDocLoader=new CLDDocLoader();
			docLoader.url=url;
			docLoader.index=index;
			docLoader.addEventListener("swfLoaded",swfComplete);
			docLoader.loadswf();
			loadList.push(docLoader);
			
		}
		private function swfComplete(e:Event):void
		{
			e.target.addEventListener("swfLoaded",swfComplete);
			var mc:MovieClip=e.target.content;
			mc.cacheAsBitmap=true;
			mc.opaqueBackground=0xFFFFFF;
			mc.stop();
			this.loaded.push({index:e.target.index,mc:mc,totalPage:e.target.totalPage});
			
			this.dispatchEvent(e);
			loadedLength++;
			totalPage+=e.target.totalPage;
			this.width=mc.width;
			this.height=mc.height;
			
			
			
			if(numLoad==loadedLength)
			{
				this.loaded=loaded.sort(sortOnPrice);
				for(var i:int=0;i<loaded.length;i++){
					trace(loaded[i].index);
				}
				this.dispatchEvent(new Event("allSwfLoaded"));
			}
		}
		public function dispose():void
		{
			for each(var ld:CLDDocLoader in this.loadList)
			{
				ld.dispose();
			}	
		}
		
		
		
		function sortOnPrice(a:Object, b:Object):Number {
    		 var aPrice:Number = a.index;
   		 	 var bPrice:Number = b.index;

    		if(aPrice > bPrice) {
        		return 1;
   		 	} else if(aPrice < bPrice) {
       	 		return -1;
   			 } else  {
       
     	   		return 0;
     	 	}
    	}
//}



	}
}