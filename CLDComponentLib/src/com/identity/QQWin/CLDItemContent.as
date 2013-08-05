package com.identity.QQWin
{
	import com.careland.component.CLDContent;
	import com.careland.component.CLDWindow;
	import com.identity.tab.CLDTabContent;
	
	import flash.display.DisplayObjectContainer;
	import flash.events.Event;
	import flash.net.URLLoader;

	public class CLDItemContent extends CLDWindow
	{
		public var id:int;
		public function CLDItemContent(parent:DisplayObjectContainer=null, xpos:Number=0, ypos:Number=0)
		{
			super(parent, xpos, ypos);
		}
		
		public function initUI():void
		{
 			this.loadTxt(produceurl + "?SpName=" + encodeURI("P_查询QQ窗体与窗体的关联组件") + "&paramsString=" + encodeURI("@id=" + id) + "", null, loadDatasComplete);
		}
		
 
		override public function dispose():void
		{
			super.dispose();
			this.id=null;
		}
 

		private function loadDatasComplete(e:Event):void
		{
			var url:URLLoader=e.target as URLLoader;
			var xml:XML=XML(url.data); 
			
			for (var i:int; i < xml.data.length(); i++)
			{
				var ct:CLDContent=new CLDContent();
				//ct.width=xml.data[i].attributes()[2];
				//ct.height=xml.data[i].attributes()[1];
				ct.contentID=String(xml.data[i].attributes()[0]);
				ct.autoLoad=true;
				this.content.addChild(ct);
			}
			
		}
		
	}
}