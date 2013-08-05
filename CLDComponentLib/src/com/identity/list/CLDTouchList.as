package com.identity.list
{
	import com.careland.Base;
	import com.careland.command.CMD;
	import com.careland.command.Message;
	import com.careland.component.CLDBaseComponent;
	import com.careland.event.ImgEvent;
	import com.identity.list.classes.CLDListUI;
	
	import flash.display.DisplayObjectContainer;
	import flash.display.Graphics;
	import flash.display.Shape;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import mx.utils.object_proxy;
	
	import org.gestouch.events.GestureEvent;
	import org.gestouch.gestures.PanGesture;
	import org.gestouch.gestures.PanGestureDirection;

	public class CLDTouchList extends CLDBaseComponent
	{
		private var list:CLDBaseComponent;
		private var contentMask:Shape;
		private var listUI:CLDListUI;
		public var listHeight:Number=387;
		public var rowHeight:Number=54;
		private var minY:Number;
		private var maxY:Number;
		private var panGesture:PanGesture;
		public function CLDTouchList(parent:DisplayObjectContainer=null, xpos:Number=0, ypos:Number=0, autoLoad:Boolean=false, timeInteval:int=0)
		{
			super(parent, xpos, ypos, autoLoad, timeInteval);
		}
		override protected function addChildren():void
		{
			listUI=new CLDListUI();
			this.addChild(listUI);
			list=new CLDBaseComponent();
			this.addChild(list);
			contentMask=new Shape();
			this.addChild(contentMask);
			list.mask=this.contentMask;
			panGesture=new PanGesture(this);
			panGesture.direction=PanGestureDirection.VERTICAL;
			//panGesture.addEventListener(GestureEvent.GESTURE_BEGAN,pan);
			panGesture.addEventListener(GestureEvent.GESTURE_CHANGED,pan);
			
		}
		
		private function pan(e:GestureEvent):void
		{
			 if(panGesture&&e.type==GestureEvent.GESTURE_CHANGED)
			 {
				 list.y+=panGesture.offsetY;
			 }
		}
		
		private function itemClick(e:Event):void
		{
			if(e.target is CLDListItem)
			{
				var item=e.target.object;
				var imgevent:ImgEvent=new ImgEvent(ImgEvent.mouseClick);	 
				imgevent.id=item.id;
				imgevent.object=item; 
				this.dispatchEvent(imgevent);   
				//ImgEvent.mouseClick 和 layout12的 事件冲突  所以抛两个事件 来区分
				var imgevent0:ImgEvent=new ImgEvent(ImgEvent.listItemClick);
				imgevent0.id=item.id;
				imgevent0.object=item.object; 
				this.dispatchEvent(imgevent0);   
				
				//因为 ipad和 大屏幕用的不通的 列表组件(皮肤一样 )所以解析在CLDListWrapper中解析 
				var mes:Message=Message.buildMsg(CMD.LISTITEMCLICK);
				mes.data=new Object;
				mes.data.id=item.id;
				mes.data.object=item.object;
				mes.data.contentID=this.contentID;
				mes.data.contentIDParam=this.contentIDParam;
				this.sendCommand(mes);
				
				
				
			}
			
			
		}
		override public function dispose():void
		{
			for(var i=0;i<list.numChildren;i++)
			{
				var row:CLDListItem=list.getChildAt(i) as CLDListItem;
				if(row)
				{
					row.removeEventListener(MouseEvent.CLICK,this.itemClick);
				}
			}
			if(panGesture)
			{
				panGesture.dispose();
				panGesture=null;
			}
			super.dispose();	
			list=null;
			this.listUI=null;
			this.contentMask=null;
		}
		override public function draw():void
		{
			if(this.listUI)
			{
				listUI.setSize(this.width,this.listHeight);
			}
			if(list)
			{
				list.setSize(this.width,this.listHeight);
			}
			if(this.contentMask)
			{
				var g:Graphics=this.contentMask.graphics;
				g.clear();
				g.beginFill(0x000000,0);
				g.drawRect(5,5,this.width-20,this.listHeight-20);
				g.endFill();
			}
			if(data&&this.dataChange)
			{
				
				var ypos:Number=0;
				var xml:XML=XML(data);
				for(var i:int=0;i<xml.data.length();i++){
					var row:CLDListItem=new CLDListItem();
					row.imgPath=xml.data[i].@图片路径;
					row.content=xml.data[i].@content;
					row.contentID=xml.data[i].@内容ID;
					row.param=xml.data[i].@参数;
					row.data=xml.data[i];
					row.object=new Object();
					row.object.content=String(xml.data[i].@content);
					row.object.contentID=String(xml.data[i].@内容ID);
					row.object.winID=String(xml.data[i].@窗体编号);
					row.object.eventChart=String(xml.data[i].@点击事件类型);
					row.object.width=String(xml.data[i].@窗体宽度);
					row.object.height=String(xml.data[i].@窗体高度);
					row.object.imagePath=String(xml.data[i].@图片路径);
					row.object.mapProp=String(xml.data[i].@地图属性);
					row.object.param=String(xml.data[i].@参数);
					row.object.winState=String(xml.data[i].@固定窗体);
					row.object.winPoint=String(xml.data[i].@窗体位置);
					row.object.clearLayer=String(xml.data[i].@清除图层);
					row.setSize(this.width,rowHeight);
					row.autoLoad=true;		    	  	     
					row.doubleClickEnabled=true;
					row.addEventListener(MouseEvent.DOUBLE_CLICK, itemClick); 	  	   
					row.y=ypos;
					ypos+=rowHeight;
					this.list.addChild(row);		    	  	      
				}	
				this.dataChange=false;
			}
			
		}
		
	}
	
}