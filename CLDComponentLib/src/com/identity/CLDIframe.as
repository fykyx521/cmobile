package com.identity
{
	import com.careland.component.CLDBaseComponent;
	import com.careland.component.util.GUID;
	
	import flash.display.DisplayObjectContainer;
	import flash.external.ExternalInterface;
	import flash.geom.Point;
		
	/**
	 * 浏览器IFrame
	 * 
	 * @author flashyiyi
	 * 
	 */
	public class CLDIframe extends CLDBaseComponent
	{
		[Embed(source = "IFrame.js",mimeType="application/octet-stream")]
		private static var jsCode:Class;
		ExternalInterface.available && ExternalInterface.call("eval",new jsCode().toString());
		
		
		private var _url: String;
		private var _id:String="cld_iframe"+GUID.create();
		
		public function CLDIframe(parent:DisplayObjectContainer = null, xpos:Number = 0, ypos:Number =  0,
			autoLoad:Boolean=false,timeInteval:int=0)
		{
			super();

			
			//this._id = "cld_iframe";		
			
		//	moveIFrame(width,height);
		}
		override protected function addChildren():void
		{
			ExternalInterface.call("IFrameManager.createIFrame", id,this.width,this.height);
			
		}
		override public function draw():void
		{
			if(data&&this.dataChange){
				this.url=XML(data).data.@url;
				dataChange=false;
			}
			createIFrame(this.width,this.height);
		}
 
		
		public function createIFrame(w:int,h:int): void
        {
        	if (!_url)
        		return;
            var localPt:Point = new Point(0, 0);
            var globalPt:Point = this.localToGlobal(localPt);
            ExternalInterface.call("IFrameManager.moveIFrame", id ,globalPt.x, globalPt.y, w, h);
            
        }
        
        override protected function loadComponentData(id:String,data:*):void
		{
			//dataLoader.removeEventListener(Event.COMPLETE,loadComponentData);
			this.data=data;
		}
		
		
        
        /**
         * IFrame的唯一标识
         * @return 
         * 
         */
        public function get id():String
        {
        	return _id;
        }

        /**
         * 网页URL
         * @param source
         * 
         */
        public function set url(v: String): void
        {
            if (v)
            {
                _url = v;
                
                ExternalInterface.call("IFrameManager.loadIFrame", id ,_url);
               // moveIFrame();
                
                this.visible = visible;
            }
        }

        public function get url(): String
        {
            return _url;
        }
		/** @inheritDoc*/
        override public function set visible(v: Boolean): void
        {
            super.visible = v;
			
            ExternalInterface.call(v ? "IFrameManager.showIFrame":"IFrameManager.hideIFrame" , id);            
        }
        /** @inheritDoc*/
        override public function dispose() : void
        {
       // 	super.destory();
        	super.dispose();
        	try{
        		ExternalInterface.call("IFrameManager.removeIFrame", id);
        		this.config.clear(uuid);
        	}catch(e:Error){
        		
        	}
        	
        }
	}
}
