package com.identity.jk
{
	import caurina.transitions.Tweener;
	
	import com.careland.component.CLDBaseComponent;
	import com.careland.component.render.CLDScrollBar;
	import com.careland.component.scrollbar.classes.CLDScrollEvent;
	
	import flash.display.DisplayObjectContainer;
	import flash.display.Graphics;
	import flash.display.Shape;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import flash.utils.clearInterval;
	import flash.utils.setInterval;
	
	public class CLDYJList extends CLDBaseComponent
	{
		public function CLDYJList(parent:DisplayObjectContainer=null, xpos:Number=0, ypos:Number=0, autoLoad:Boolean=false, timeInteval:int=0)
		{
			super(parent, xpos, ypos, autoLoad, timeInteval);
		}
		
		
		public var gap:Number=3;
		
		public var lineHeight:Number=38;
		
        public var infoGap:int=50;
		
		private var rect:Rectangle;
		private var pre:CLDYJItem;
		
		public var truncateIndex:int=3;
		
		private var index:int;
		
		public var titles:Array;
		
		public var columnRealPoint:Array=[];
		
		public var columnRealWidth:Array=[];
		
		private var content:CLDBaseComponent;
		
		private var scrollBar:CLDScrollBar;
		
		private var contentMask:Shape;
		override protected function addChildren():void
		{
			super.addChildren();
			content=new CLDBaseComponent();
			this.addChild(content);
			content.x=gap;
			content.y=gap;
			
			scrollBar=new CLDScrollBar();
			this.addChild(scrollBar);
			
			contentMask=new Shape();
			this.addChild(contentMask);
			content.mask=contentMask;
			contentMask.x=gap;
			contentMask.y=gap;
			
			scrollBar.addEventListener(CLDScrollEvent.SCROLL,scroll);
		}
		private function scroll(e:CLDScrollEvent):void
		{
				content.y=e.value+this.gap;
		}
		
		private var moveID:uint;
		override public function draw():void
		{
			if(data)
			{
				
				Tweener.removeTweens(this.content);
//				var position:Array=[];
//				if(columnRealPoint.length>2)
//				{
//					for(var z:int=0;z<columnRealPoint.length;z++)
//					{
//						position.push(columnRealPoint[z]-columnRealWidth[0]);
//					}
//				}
				
				var ypos:Number=10;
				index=3;
				var xml:XML=XML(data);
				var maxnum:int=xml.data.length();
				for(var i:int=0;i<maxnum;i++)
				{
					var yjItem:CLDYJItem=new CLDYJItem();
					
					yjItem.truncateIndex=truncateIndex;
					yjItem.infoGap=infoGap;
					yjItem.columnRealWidth=columnRealWidth;
					yjItem.lineHeight=lineHeight;
					//	"08:00","服务岗","事件描述横向字符数控制为不换行，超出部分点击弹出框显示","已处理"
					var dataItems:Array=[];
					for(var j:int=0;j<titles.length;j++)
					{
						var item:XML=XML(xml.data[i]);
						dataItems.push(item.@[titles[j]]);
					}
					yjItem.data={items:dataItems,position:columnRealPoint};
					yjItem.y=ypos;
					content.addChild(yjItem); 
					yjItem.setSize(this.width,this.lineHeight);
					ypos+=lineHeight;
				}
				if(scrollBar)
				{
					scrollBar.y=5;
					scrollBar.height=this.height-5;
					scrollBar.x=this.width;
					scrollBar.maxValue=ypos;
					scrollBar.pageSize=this.height-gap*2;
				}
				if(maxnum<7&&this.scrollBar)
				{
					 this.scrollBar.visible=false;
				}
				
//				if(ypos>this.height-gap*2)
//				{
//					 flash.utils.clearInterval(this.moveID);
//					 this.moveID=flash.utils.setInterval(function(){
//						 var ny:Number=content.y-this.lineHeight;
//						 Tweener.addTween(this.content,{y:ny,time:1,onComplete:complete});
//					 },2000);
//				}
				function complete():void
				{
					 
				}
				
				
				
				if(this.contentMask)
				{
					 var g1:Graphics=this.contentMask.graphics;
					 g1.beginFill(0x000000,1);
					 g1.drawRect(0,0,this.width-gap*2,this.height-gap*2);
				}
//				var realHeight=this.height-this.gap*2;
//				rect=new Rectangle(0,0,this.width-gap*2,this.height-gap*2);
//				this.content.scrollRect=rect;
			}
				
		}
		
		
	}
}