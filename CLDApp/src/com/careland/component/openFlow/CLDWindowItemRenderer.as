package com.careland.component.openFlow
{
	import com.careland.component.CLDWindow;
	import com.careland.gesture.CLDDoubleFingerTab;
	import com.identity.CLDTextArea;
	
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	
	import fr.mazerte.controls.openflow.itemRenderer.IItemRenderer;

	public class CLDWindowItemRenderer extends CLDDoubleFingerTab implements IItemRenderer
	{
		
		private var _data:*;
		private var _index:int;
		private var cld:CLDWindow;
		
		private var load:Loader;
		
		private var bit:Bitmap;
		
		private var txt:CLDTextArea;
		public function CLDWindowItemRenderer()
		{
			cld=new CLDWindow();
			//cld.addTab();
			cld.width=524;
			cld.height=444;
			
			this.addChild(cld);
			this.mouseEnabled=true;
			
		}
		
		override public function get width():Number{
			return 524;
		}
		override public function get height():Number{
			return 444;
		}
		
		private function init():void
		{
			
		}
		public function get index():int
		{
			return _index;
		}
		
		public function set index(i:int):void
		{
			_index = i;
		}
		
		public function setData(data:*):void
		{
			this._data=data;
			if(String(_data).indexOf("http:")!=-1){
//				var htmlLoader:HTMLLoader=new HTMLLoader();
//				
//				htmlLoader.load(new URLRequest(_data));
//				htmlLoader.width=524;
//				htmlLoader.height=444;
//				cld.addChild(htmlLoader);
			}else{
				//loadContent(String("assets/test/ceshitu/"+this._data));
				initData();
				loadtxt();
			}
			
			
		}
		private function initData():void
		{
			txt=new CLDTextArea();
			
			txt.setSize(524,444);
			this.cld.addChild(txt);



		}
		private var url:URLLoader;
		protected function loadtxt():void
		{
			 url=new URLLoader();
			 url.addEventListener(Event.COMPLETE,loadComplete);
			 url.load(new URLRequest("as.txt"));
		}
		protected function loadContent(url:String):void
		{
			if(!load){
				load=new Loader();
			}
			load.contentLoaderInfo.addEventListener(Event.COMPLETE,loadComplete);
			load.load(new URLRequest(url));
			
		}
		
	    protected function loadComplete(e:Event):void{
			//bit=e.target.content as Bitmap;
			txt.value=String(e.target.data);
			
			
			
			
		
			
			//cld.addChild(txt);
		}
		
		public function focusIn():void
		{
		}
		
		public function focusOut():void
		{
		}
		
		public function rollOver():void
		{
		}
		
		public function rollOut():void
		{
		}
		
		public function getDisobj():DisplayObject{
			return this.cld;
		}
		
		
		public function dispose():void
		{
			this.removeChild(_data as DisplayObject);
		}
		override public function clone():Sprite{
			
			var cldw:CLDWindow=new CLDWindow();
			cldw.setSize(524,444);
			cldw.addChild(this.txt);
//			var cldw:CLDTouchWindow=new CLDTouchWindow();
//			//cldw.addTab();
//			cldw.width=524;
//			cldw.height=444;
//			
//			
//			if(bit){
//				cldw.addChild(new Bitmap(bit.bitmapData.clone()));
//			}
			return cldw;
		}
		
		
		
		
		
	}
}