package com.identity.list
{
	
	import com.careland.component.CLDBaseComponent;
	import com.careland.event.ImgEvent;
	
	import fl.controls.List;
	import fl.data.DataProvider;
	import fl.events.ListEvent;
	
	import flash.display.DisplayObjectContainer;
	
	public class CLDMouseList extends CLDBaseComponent
	{
		private var list:List;
		private var listHeight=387;
		public function CLDMouseList(parent:DisplayObjectContainer=null, xpos:Number=0, ypos:Number=0, autoLoad:Boolean=false, timeInteval:int=0)
		{
			super(parent, xpos, ypos, autoLoad, timeInteval);
		}
		override protected function addChildren():void
		{
			list=new List();
			list.labelField="content";
			list.addEventListener(ListEvent.ITEM_CLICK,itemClick);
			this.addChild(list);
			
		}
		private function itemClick(e:ListEvent):void
		{
			var item=e.item;
			var imgevent:ImgEvent=new ImgEvent(ImgEvent.mouseClick);	 
			//imgevent.id=item.id;
			imgevent.object=item; 
			this.dispatchEvent(imgevent);   
			//ImgEvent.mouseClick 和 layout12的 事件冲突  所以抛两个事件 来区分
			var imgevent0:ImgEvent=new ImgEvent(ImgEvent.listItemClick);
			imgevent0.id=item.id;
			imgevent0.object=item.object; 
			this.dispatchEvent(imgevent0);   
			
		}
		override public function draw():void
		{
			super.draw();
			if(data&&this.dataChange)
			{
				var ypos:Number=0;
				var xml:XML=XML(data);
				var items:Array=[];
				for(var i:int=0;i<xml.data.length();i++){
					var row:Object=new Object;
					row.content=String(xml.data[i].@content);
					row.contentID=String(xml.data[i].@内容ID);
					row.winID=String(xml.data[i].@窗体编号);
					row.eventChart=String(xml.data[i].@点击事件类型);
					row.width=String(xml.data[i].@窗体宽度);
					row.height=String(xml.data[i].@窗体高度);
					row.imagePath=String(xml.data[i].@图片路径);
					row.mapProp=String(xml.data[i].@地图属性);
					row.param=String(xml.data[i].@参数);
					row.winState=String(xml.data[i].@固定窗体);
					row.winPoint=String(xml.data[i].@窗体位置);
					row.clearLayer=String(xml.data[i].@清除图层);
					items.push(row);
				}	


				if(list)
				{
					list.setSize(this.width,this.listHeight);
					list.dataProvider=new fl.data.DataProvider(items);
				}
				
			
				this.dataChange=false;
				
				
			}
		}
	}
}