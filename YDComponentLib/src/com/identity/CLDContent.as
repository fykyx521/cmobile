package com.identity
{
    import com.careland.component.CLDBaseComponent;
    import com.careland.component.util.CLDLoding;
    import com.careland.component.util.ComponentFactory;
    
    import flash.display.*;
    import flash.events.*;
    import flash.ui.*;
	public class CLDContent extends CLDBaseComponent
	{
		private var loading:CLDLoding;
		public function CLDContent(parent:DisplayObjectContainer=null, xpos:Number=0, ypos:Number=0, autoLoad:Boolean=false, timeInteval:int=0)
		{
			super(parent, xpos, ypos, autoLoad, timeInteval);
		}
	 	
		private var content:CLDBaseComponent;
		private var isinit:Boolean=false;
		 override protected function addChildren():void
		{	
			loading=new CLDLoding();
			this.addChild(loading);
			this.addEventListener(Event.RESIZE, resize);
		}
		override public function draw():void
		{ 
			if(content){
				content.width=width;
				content.height=height;
			}
			if(this.loading){
				loading.setSize(this.width,this.height);
//				this.loading.x=(this.width-32)/2;
//				this.loading.y=(this.height-32)/2;
			}
		}
		private function resize(e:Event):void{
		  if(this.content){
		  	 this.content.setSize(this.width,this.height);
		  }	  
		}
		override public function dispose():void
		{
			if(content){
			//	content.removeEventListener("ComponentInit",ComponentInit);
			}
			super.dispose();
			content=null;
			this.loading=null;
		}
//		override public function get width():Number
//		{
//			return this.content.width;
//		}
//		  override public function get height():Number
//		{
//			return this.content.height;
//		}
		override protected function loadComponentData(id:String, data:*):void
		{ 
			if(this.loading){
				this.removeChild(loading);
				this.loading.dispose();
				loading=null;
			}
			super.loadComponentData(id,data);
			var xml:XML=XML(data);
			if(!xml){
				return;
			}
			var config:XML=xml.config[0];
			var type:String=config.@["内容类型"];
			var timeInterval:Number=Number(config.@["刷新频率"]);
			content=ComponentFactory.getComponent(type, id, timeInterval, false);
	//		content.addEventListener("ComponentInit",ComponentInit);
			content.setSize(this.width, this.height);
			content.data=data;
			content.contentIDParam=this.contentIDParam;
			content.autoLoad=true;
		    this.addChild(content);
			this.invalidate();
			isinit=true;
			
			//this.dispatchEvent(new Event("ComponentInit"));
		}

//		private function ComponentInit(e:Event):void
//		{
//			content.removeEventListener("ComponentInit",ComponentInit);
//			this.dispatchEvent(e);
//		}
	}
}