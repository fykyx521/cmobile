package com.careland.main.ui
{
	import caurina.transitions.Tweener;
	
	import com.careland.command.CMD;
	import com.careland.command.Message;
	import com.careland.main.events.CLDMenuEvent;
	
	import fl.transitions.Tween;
	
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.MouseEvent;
	import flash.geom.Point;

	public class CLDMenu3 extends CLDMenu2
	{
		public function CLDMenu3()
		{
			super();
		}
		override protected function addChildren():void
		{
			super.addChildren();
			menu.type=3;
			this.cldConfig.addEventListener(CLDMenuEvent.Menu3Show,showMenu);
			this.cldConfig.addEventListener(CLDMenuEvent.Menu3Show,hideMenu);
		}
		private function showMenu(e:CLDMenuEvent):void
		{
			this.data=e.menuModel.data;
			txt.text=e.menuModel.menuName;
			txt.x=(width-txt.textWidth)/2;
			txt.y=10;
		}
		
		private function hideMenu(e:CLDMenuEvent):void
		{
			//this.data=e.menuModel.data;
			
		}
		
		override protected function menuClick(e:CLDMenuEvent):void
		{
			if(e.menuModel.menuType==3)
			{
				
     			//this.loadProduce(resultLoadMenu,this.cldConfig.getProcedure("menuconfig"),"userid:"+this.cldConfig.userID+"$@pid:"+e.menuModel.menuID);
			}
		}
		override public function show():void
		{
			Tweener.addTween(this,{x:stageWidth-500,time:0.5});
			isShow=true;
			var mes:Message=new Message(CMD.SHOWMENU3);
			this.sendCommand(mes);
			
		}
		override public function hide():void
		{
			var mes:Message=new Message(CMD.HIDEMENU3);
			this.sendCommand(mes);
			isShow=false;
			Tweener.addTween(this,{x:this.stageWidth,time:.5});
			if(stage)
			{
				stage.addEventListener(MouseEvent.MOUSE_DOWN,stageDown);
			}
		}
		override protected function stageMove(e:MouseEvent):void
		{
			
			if(this.isRight)
			{
				var np:Point=new Point(e.stageX,e.stageY);
				if(this.preStagePoint.x-np.x>300)
				{
					stage.addEventListener(MouseEvent.MOUSE_DOWN,stageDown);
					stage.removeEventListener(MouseEvent.MOUSE_MOVE,stageMove);
					stage.removeEventListener(MouseEvent.MOUSE_UP,stageUp);
					this.show();
				}
			}
		}
		
		override protected function resultLoadMenu(e:Event):void
		{
			e.target.removeEventListener(Event.COMPLETE,resultLoadMenu);
			e.target.removeEventListener(IOErrorEvent.IO_ERROR,ioError);
			var xml:XML=XML(e.target.data);
			this.menu.deleteAll();
			this.data=xml;
			this.disposeXML(xml);
		}
	}
}