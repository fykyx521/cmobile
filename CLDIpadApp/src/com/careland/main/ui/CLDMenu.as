package com.careland.main.ui
{
	import com.careland.command.CMD;
	import com.careland.command.Message;
	import com.careland.main.ui.item.CLDMenuItem;
	
	import flash.display.DisplayObject;
	import flash.display.Graphics;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Point;

	public class CLDMenu extends CLDBaseUI
	{
		
		private var content:CLDBaseUI;
		private var contentMask:Shape;
		public var type:int;
		private var _zong:Boolean=false;//是否是纵向 
		
		private var prePoint:Point;
		private var hengWidth:Number=145;
		private var zongHeight:Number=150;
		public function CLDMenu()
		{
			super();
		}
		
		public function set  direction(value:Boolean):void
		{
			_zong=value;
			this.invalidate();
		}
		public function get direction():Boolean
		{
			return this._zong;
		}
		
		override protected function addChildren():void
		{
			content=new CLDBaseUI;
			this.addChild(content);
			contentMask=new Shape();
			this.addChild(contentMask);
			this.content.mask=contentMask;
			this.addEventListener(MouseEvent.MOUSE_DOWN,downHandler);
		}
		private function downHandler(e:MouseEvent):void
		{
			 prePoint=new Point(this.mouseX,this.mouseY);
			 this.addEventListener(MouseEvent.MOUSE_MOVE,moveHandler);
			 this.addEventListener(MouseEvent.MOUSE_UP,upHandler);
			 if(stage)
			 {
				 stage.addEventListener(MouseEvent.MOUSE_UP,upHandler);
			 }
			// this.addEventListener(MouseEvent.MOUSE_OUT,upHandler);
			 
		}
		private function moveHandler(e:MouseEvent):void
		{
			 var np:Point=new Point(this.mouseX,this.mouseY);
			 var sub:Point=new Point(np.x-prePoint.x,np.y-prePoint.y);
			// var sub:Point=np.subtract(prePoint);
			 if(direction)
			 {
				 content.y+=sub.y;
			 }else
			 {
				 content.x+=sub.x;
			 }
			 prePoint=np;
		}
		private function upHandler(e:MouseEvent):void
		{
			prePoint=new Point(this.mouseX,this.mouseY);
			this.removeEventListener(MouseEvent.MOUSE_MOVE,moveHandler);
			this.removeEventListener(MouseEvent.MOUSE_UP,upHandler);
			stage.removeEventListener(MouseEvent.MOUSE_UP,upHandler);
			//this.removeEventListener(MouseEvent.MOUSE_OUT,upHandler);
//			if(_zong)
//			{
//				var nh:Number=this.zongHeight*content.numChildren-this.height;
//				if(content.y<-nh)
//				{
//					content.y=-nh;  
//				}
//			}else
//			{
//				var nw:Number=hengWidth*content.numChildren-this.width;
//				if(content.x<-nw)
//				{
//					content.x=-nw;
//				}
//			}
			if(content.x>=0)
			{
				content.x=0;
			}
			if(content.y>=0)
			{
				content.y=0;
			}
			var mes:Message=new Message(CMD.MENUMOVE);
			mes.data={type:this.type,x:content.x,y:content.y};
			this.sendCommand(mes); 
		}
		
		override protected function dataChange():void
		{
			var datas:XMLList=XMLList(data);
			var xpos=0;
			for(var i:int=0;i<datas.length();i++){
				var menuItem:CLDMenuItem=new CLDMenuItem()
				menuItem.type=this.type;
				menuItem.data=datas[i];
				content.addChild(menuItem);
			}
			this.invalidate();
		}
		override public function set data(value:*):void
		{
			this.content.x=this.content.y=0;
			super.data=value;
		}
		
		public function deleteAll()
		{
			while(this.content.numChildren>0)
			{
				var menu:CLDMenuItem=this.content.getChildAt(0) as CLDMenuItem;
				menu.disponse();
				content.removeChild(menu);
				menu=null;
			}
		}
		
		override public function draw():void
		{
			
			if(contentMask)
			{
				var g:Graphics=this.contentMask.graphics;
				g.clear();
				g.beginFill(0x000000,1);
				g.drawRect(0,0,this.width,this.height);
				g.endFill();
			}
			if(content)
			{
				content.setSize(this.width,this.height);
				var g1:Graphics=this.content.graphics;
				g1.clear();
				g1.beginFill(0x000000,0);
				g1.drawRect(0,0,this.width,this.height);
				g1.endFill();
			}
			var xpos=0;
			var ypos=0;
			for(var i=0;i<this.content.numChildren;i++)
			{
				 var dis:CLDMenuItem=content.getChildAt(i) as CLDMenuItem;
				 dis.move(xpos,ypos);
				 dis.direction=this.direction;
				 if(direction)
				 {
					 ypos+=this.zongHeight;
				 }else
				 {
					 xpos+=hengWidth;
				 }
			}
		}
		
	}
}