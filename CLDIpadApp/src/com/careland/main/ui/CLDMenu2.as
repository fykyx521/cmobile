package com.careland.main.ui
{
	import caurina.transitions.Tweener;
	
	import com.careland.command.CMD;
	import com.careland.command.Message;
	import com.careland.main.events.CLDMenuEvent;
	import com.careland.main.ui.item.CLDMenuItem;
	
	import flash.display.Bitmap;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.text.TextField;
	import flash.text.TextFormat;

	public class CLDMenu2 extends CLDBaseUI
	{
		
		[Embed(source="assets/menu2Border.png")]
		private var cls:Class;
		private var back:Bitmap;
		protected var menu:CLDMenu;
		protected var txt:TextField;
		protected var isShow:Boolean=true;
		
		public var stageWidth:Number;
		public var stageHeight:Number;
		
		public function CLDMenu2()
		{
			super();
			
		}
		override protected function addChildren():void
		{
			 back=new cls as Bitmap;
			 this.addChild(back);
			 menu=new CLDMenu();
			 this.addChild(menu);
			 menu.type=2;
			 menu.y=55;
			 menu.direction=true;
			 
			 txt=new TextField();
			 txt.defaultTextFormat=new TextFormat("msyh",24,0xffffff);
			 txt.embedFonts=false;
			 txt.selectable=false;
			 this.addChild(txt);
			 
			 cldConfig.addEventListener(CLDMenuEvent.MENUCLICK,menuClick);
			 
			 this.addEventListener(MouseEvent.MOUSE_DOWN,downHandler);
			 
			 //this.dataChange();
		}
		protected var prePoint:Point;
		private function downHandler(e:MouseEvent):void
		{
			  prePoint=new Point(this.mouseX,this.mouseY);
			  this.addEventListener(MouseEvent.MOUSE_MOVE,moveHandler);
			  this.addEventListener(MouseEvent.MOUSE_UP,upHandler);
		}
		private function moveHandler(e:MouseEvent):void
		{
			var np:Point=new Point(this.mouseX,this.mouseY);
			if(np.x-prePoint.x>100)
			{
				this.hide();
				this.removeEventListener(MouseEvent.MOUSE_MOVE,moveHandler);
				this.removeEventListener(MouseEvent.MOUSE_UP,upHandler);
			}
		}
		private function upHandler(e:MouseEvent):void
		{
			this.removeEventListener(MouseEvent.MOUSE_MOVE,moveHandler);
			this.removeEventListener(MouseEvent.MOUSE_UP,upHandler);
		}
		public function show():void
		{
			isShow=true;
			Tweener.addTween(this,{x:this.stageWidth-260,time:0.5});
			var mes:Message=new Message(CMD.SHOWMENU2);
			this.sendCommand(mes);
			stage.removeEventListener(MouseEvent.MOUSE_DOWN,stageDown);
			stage.removeEventListener(MouseEvent.MOUSE_MOVE,stageMove);
			stage.removeEventListener(MouseEvent.MOUSE_UP,stageUp);
		}
		public function hide():void
		{
			isShow=false;
			Tweener.addTween(this,{x:this.stageWidth,time:.5});
			if(stage)
			{
					stage.addEventListener(MouseEvent.MOUSE_DOWN,stageDown);
			}
			var mes:Message=new Message(CMD.HIDEMENU2);
			this.sendCommand(mes);
		}
	    
		protected var preStagePoint:Point;
		protected var isRight:Boolean=false;
		protected function stageDown(e:MouseEvent):void
		{
			preStagePoint=new Point(e.stageX,e.stageY);
			stage.addEventListener(MouseEvent.MOUSE_MOVE,stageMove);
			stage.addEventListener(MouseEvent.MOUSE_UP,stageUp);
			if(e.stageX>this.stageWidth-100)
			{
				 this.isRight=true;
			}
			
		}
		protected function stageMove(e:MouseEvent):void
		{
			if(this.isRight)
			{
				var np:Point=new Point(e.stageX,e.stageY);
				if(this.preStagePoint.x-np.x>200&&this.preStagePoint.x-np.x<300)
				{
					stage.addEventListener(MouseEvent.MOUSE_DOWN,stageDown);
					stage.removeEventListener(MouseEvent.MOUSE_MOVE,stageMove);
					stage.removeEventListener(MouseEvent.MOUSE_UP,stageUp);
					this.show();
				}
			}
			
		}
		protected function stageUp(e:MouseEvent):void
		{
			this.isRight=false;
			stage.removeEventListener(MouseEvent.MOUSE_MOVE,stageMove);
			stage.removeEventListener(MouseEvent.MOUSE_UP,stageUp);
		}
		protected function menuClick(e:CLDMenuEvent):void
		{
			 if(e.menuModel.menuType==1)
			 {
				 var mes:Message=new Message();
				 mes.type=CMD.OPENMENU2;
				 mes.data=e.menuModel;
				 this.sendCommand(mes); //发送打开2级菜单事件
				 txt.text=e.menuModel.menuName;
				 txt.x=(width-txt.textWidth)/2;
				 txt.y=10;
				 this.loadProduce(resultLoadMenu,this.cldConfig.getProcedure("menuconfig"),"userid:"+this.cldConfig.userID+"$@pid:"+e.menuModel.menuID);
			 }
		}
		
		protected function resultLoadMenu(e:Event):void
		{
			e.target.removeEventListener(Event.COMPLETE,resultLoadMenu);
			e.target.removeEventListener(IOErrorEvent.IO_ERROR,ioError);
			
			var xml:XML=XML(e.target.data);
			this.menu.deleteAll();
			this.data=xml.data;
			this.disposeXML(xml);
			
		}
		
		override protected function dataChange():void
		{
			menu.data=data;
			this.invalidate();
		}
		override public function draw():void
		{
			 if(menu)
			 {
				 menu.x=8;
				 menu.setSize(this.width,this.height-100);
			 }
			 if(back)
			 {
				 back.height=this.height;
			 }
			 if(txt)
			 {
				 txt.width=this.width;
				 txt.height=50;
			 }
		}
		
		
	}
}