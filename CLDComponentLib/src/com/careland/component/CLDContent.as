package com.careland.component
{
	import com.careland.component.util.CLDLoding;
	import com.careland.component.util.ComponentFactory;
	import com.careland.component.util.Style;
	import com.careland.event.CLDEvent;
	import com.identity.CLDIframe;
	import com.identity.CLDMap;
	
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.text.TextField;

	public class CLDContent extends CLDBaseComponent
	{
		private var loading:CLDLoding;
		private var noData:TextField;
		public function CLDContent(parent:DisplayObjectContainer=null, xpos:Number=0, ypos:Number=0, autoLoad:Boolean=false, timeInteval:int=0)
		{
			super(parent, xpos, ypos, autoLoad, timeInteval);
		}
		
		override protected function addChildren():void
		{
			loading=new CLDLoding();
			this.addChild(loading);
			
			noData=new TextField();
			noData.selectable=false;
			noData.wordWrap=false;
		//	var txt:String=config.getProperties("noData");
			noData.text="没有数据返回";
			//if(txt&&txt!="")
			//{
			//	noData.text=txt;
			//}
			
			noData.defaultTextFormat=Style.getTF();
			this.addChild(noData);
			noData.visible=false;
		}
		
		
		override public function draw():void
		{ 
			
			for(var i:int=0;i<this.numChildren;i++){
				var displayer:DisplayObject=this.getChildAt(i);
				displayer.width=this.width;
				displayer.height=this.height;
			}
			if(this.loading){
				loading.setSize(this.width,this.height);
//				this.loading.x=(this.width-32)/2;
//				this.loading.y=(this.height-32)/2;
			}
			
		}
		
		override public function dispose():void
		{
			super.dispose();
			this.disposeXML(XML(this.data));
			this.loading=null;
		}
		
	
		override protected function loadComponentData(id:String, data:*):void
		{
			if(this.loading){
				this.removeChild(loading);
				this.loading.dispose();
				loading=null;
			}
			var xml:XML=XML(data);
			var hasData:Boolean=false;
			var list:XMLList=xml..data;
			if(list&&list.length()>0)
			{
				hasData=true;
			}
			if(xml.table)
			{
				if(xml.table.data&&xml.table.data.length()>0)
				{
					hasData=true;
				}
			}
			
			if(!hasData)
			{
				noData.visible=true;
				return;
			}
			
			super.loadComponentData(id,data);
			
			var xml:XML=XML(this.dataLoader.data);
			if(!xml){
				return;
			}
			var config:XML=xml.config[0];
			if(!config)
			{
				return;
			}
			var type:String=config.@["内容类型"];

			var timeInterval:Number=Number(config.@["刷新频率"]);

			var ct:CLDBaseComponent=ComponentFactory.getComponent(type, id, timeInterval, false);
			
			ct.contentIDParam=this.contentIDParam;
			ct.autoLoad=true;
			ct.uuid=this.uuid;
			ct.data=data;
			if(ct is CLDMap){
				this.dispatchEvent(new CLDEvent(CLDEvent.IS_MAP_WIN));
			}
			if(ct is CLDIframe){
				this.config.register(this.uuid,ct);
			}
			this.addChild(ct);

			this.invalidate();
		}
		
		
		
	}
}