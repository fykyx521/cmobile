package com.identity.tab
{
	import caurina.transitions.Tweener;
	
	import com.careland.component.CLDBaseComponent;
	import com.careland.component.CLDContent;
	import com.careland.component.util.CLDLoding;
	import com.careland.component.util.ComponentFactory;
	
	import flash.display.*;
	import flash.events.*;
	import flash.ui.*;
	public class CLDTabContent extends CLDContent
	{
		private var conID:String;
		
		private var content:CLDBaseComponent;
		private var isinit:Boolean=false;
		private var xml:XML;
		private var type:String;
		private var timeInterval:Number;
	//	private var factHeight:Number;
		private var loading:CLDLoding;
		public function CLDTabContent(parent:DisplayObjectContainer = null, xpos:Number = 0, ypos:Number =  0,
			autoLoad:Boolean=false,timeInteval:int=0)
		{
		 
		}
		 
         override protected function addChildren():void
		{	 
			loading=new CLDLoding();
			this.addChild(loading);
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
		
		public function show():void
		{			
		  this.visible=true;
		  this.y=this.height;
		  Tweener.addTween(this,{y:37 , time: 0.3});
		}
		private function complete(e:Event):void{
		   this.visible=false;
		}
		public function hide():void
		{
		  this.y=55;
		  this.visible=false;
         // Tweener.addTween(this,{y:this.height, time: 0.3, onComplete: complete});

		}
		
 
		override public function dispose():void
		{
			if(content){
				content.removeEventListener("ComponentInit",ComponentInit);
			}
			super.dispose();
			content=null;
			this.isinit=null;
			this.xml=null;
			this.type=null;
			this.timeInterval=null;
		}
		override protected function loadComponentData(id:String, data:*):void
		{ 
			if(this.loading){
				this.removeChild(loading);
				this.loading.dispose();
				loading=null;
			}
			super.loadComponentData(id,data);
			 xml=XML(data);
			if(!xml)return;
			var config:XML=xml.config[0];
			if(!config)
			{
				return;
			}
			 type=config.@["内容类型"];
			 timeInterval=Number(config.@["刷新频率"]);
			 
			 content=ComponentFactory.getComponent(type, id, timeInterval, false);
			 content.addEventListener("ComponentInit",ComponentInit);
			//content.height=this.height;
			
			content.contentIDParam=this.contentIDParam;
			content.setSize(this.width, this.height);
			content.data=data;
			content.autoLoad=true;
		    this.addChild(content);
			this.invalidate();
			isinit=true;
		}

		private function ComponentInit(e:Event):void
		{
			content.removeEventListener("ComponentInit",ComponentInit);
			this.dispatchEvent(e);
		}
		 
		 
		  
	}
}