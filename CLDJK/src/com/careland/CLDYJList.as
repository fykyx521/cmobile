package com.careland
{
	import caurina.transitions.Tweener;
	
	import com.careland.component.CLDBaseComponent;
	import com.careland.component.render.CLDScrollBar;
	import com.careland.component.render.CLDYJItem;
	
	import flash.display.DisplayObjectContainer;
	import flash.geom.Rectangle;
	import flash.utils.setInterval;
	
	import org.hamcrest.mxml.object.Null;
	
	public class CLDYJList extends CLDBaseComponent
	{
		
		
		public function CLDYJList(parent:DisplayObjectContainer=null,
								  xpos:Number=0, ypos:Number=0,
								  autoLoad:Boolean=false, timeInteval:int=0)
		{
			super(parent, xpos, ypos, autoLoad, timeInteval);
		}
		
		public var columnRealPoint:Array=[];
		
		public var columnRealWidth:Array=[];
		
		private var content:CLDBaseComponent;
		
		private var scrollBar:CLDScrollBar;
		override protected function addChildren():void
		{
			super.addChildren();
			content=new CLDBaseComponent();
			this.addChild(content);
			content.x=gap;
			content.y=gap;
			
			scrollBar=new CLDScrollBar();
			this.addChild(scrollBar);
			
			
		
		}
		override public function dispose():void
		{
			super.dispose();
			while(this.numChildren>0)
			{
				this.removeChildAt(0);
			}
			
		}
		
		public var gap:Number=5;
		
		public var lineHeight:Number=20;
		private var rect:Rectangle;
		private var pre:CLDYJItem;
		
		public var truncateIndex:int=3;
		
		private var index:int;
		
		public var titles:Array;
		override public function draw():void
		{
			
			if(data)
			{
				
				var position:Array=[];
//				if(columnRealPoint.length>2)
//				{
//					for(var z:int=1;z<columnRealPoint.length;z++)
//					{
//						position.push(columnRealPoint[z]-columnRealWidth[0]);
//					}
//				}
				
				var ypos:Number=0;
				index=3;
				var xml:XML=XML(data);
				for(var i:int=0;i<xml.data.length();i++)
				{
					var yjItem:CLDYJItem=new CLDYJItem();
					
					yjItem.truncateIndex=truncateIndex;
					
					yjItem.columnRealWidth=columnRealWidth;
				//	"08:00","服务岗","事件描述横向字符数控制为不换行，超出部分点击弹出框显示","已处理"
					var dataItems:Array=[];
					for(var j:int=0;j<titles.length;j++)
					{
						var item:XML=XML(xml.data[i]);
						dataItems.push(item.@[titles[j]]);
					}
					
					yjItem.data={items:dataItems,position:position};
					yjItem.y=ypos;
					content.addChild(yjItem);
					ypos+=lineHeight;
					if(index==i)
					{
						yjItem.setSelected(true);
						pre=yjItem;
					}
				}
				
				
				var realHeight=this.height-this.gap*2;
				rect=new Rectangle(0,0,this.width-gap*2,this.height-gap*2);
				this.content.scrollRect=rect;
				
				
				if(scrollBar)
				{
					scrollBar.height=this.height;
					scrollBar.x=this.width;
				}
				
				
				
				flash.utils.setInterval(function(){
					
					var ny:Number=rect.y+lineHeight;
					if(ny>lineHeight*data.length)
					{
						ny=0;
					}
					//Tweener.addTween(rect,{y:ny,time:2,onUpdate:update,onComplete:complete});
				
				},3000);
			}
		}
		
		function update():void
		{
			content.scrollRect=rect;
		}
		
		function complete():void
		{
			index++;
			if(index>this.content.numChildren)
			{
				index=0
			}
			if(pre)
			{  
				pre.setSelected(false);
			}
			var yjitem:CLDYJItem=(content.getChildAt(index) as CLDYJItem);
			yjitem.setSelected(true);
			pre=yjitem;
			
		}
		
		
		
		
		
		
		
		
	}
}