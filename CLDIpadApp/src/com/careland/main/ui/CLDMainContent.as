package com.careland.main.ui
{
	import com.careland.command.CMD;
	import com.careland.command.Message;
	import com.careland.component.CLDViewContent;
	import com.careland.event.CLDEvent;
	import com.careland.main.events.CLDMainEvent;
	import com.careland.main.events.CLDMenuEvent;
	import com.careland.main.ui.item.CLDMenuModel;
	
	import flash.events.Event;
	import flash.events.IOErrorEvent;

	public class CLDMainContent extends CLDBaseUI
	{ 
		private var content:CLDViewContent;
		public function CLDMainContent()
		{
			super();
		}
		override protected function addChildren():void
		{
			content=new CLDViewContent();
			this.addChild(content);
			cldConfig.addEventListener(CLDMenuEvent.MENUCLICK,menuClick);
			cldConfig.addEventListener(CLDMainEvent.SHOWDESK,deskEvent);
		}
		private function deskEvent(e:CLDMainEvent):void
		{
			this.visible=!this.visible;
			var mes:Message=new Message(CMD.SHOWDESK);
			mes.data.visible=this.visible;
			this.sendCommand(mes);
		}
		public function addView(data:XML,viewParam:String=""):void
		{
			this.content.addView(data,viewParam);
		}
		public function menuClick(e:CLDMenuEvent):void
		{
			if(e.menuModel.menuType>1)
			{
				 var mes:Message=new Message(CMD.OPENCONTENT);
				 mes.type=CMD.OPENCONTENT;
				 mes.data=e.menuModel;
				 this.sendCommand(mes);
				 this.initByMenuID(e.menuModel.menuID,e.menuModel.menuName,"",false);
			}
		}
		public function initByMenuID(menuID:int,menuName:String,param:String="",isMenu1:Boolean=false):void
		{
			this.loadProduce(resultLoadMenu,this.cldConfig.getProcedure("menuconfig"),"userid:"+this.cldConfig.userID+"$@pid:"+menuID);
			
			function resultLoadMenu(e:Event):void
			{
				e.target.removeEventListener(Event.COMPLETE,resultLoadMenu);
				e.target.removeEventListener(IOErrorEvent.IO_ERROR,ioError);
				var xml:XML=XML(e.target.data);
				var menus:XMLList=xml.data;
				if(isMenu1)
				{
					return;
				}
				
				if(menus.length()>0)
				{   
					var ne:CLDMenuEvent=new CLDMenuEvent(CLDMenuEvent.Menu3Show);
					var menuModel:CLDMenuModel=new CLDMenuModel();
					menuModel.menuName=menuName;
					menuModel.data=xml;
					cldConfig.dispatchEvent(ne);// 注意不能加this 因为是方法内部
					return;
				}else
				{
					var ne2:CLDMenuEvent=new CLDMenuEvent(CLDMenuEvent.Menu3Hide);
					ne2.data=xml;
					cldConfig.dispatchEvent(ne2);
					var procedure:String=cldConfig.getProcedure("viewconfig");
					loadProduce(loadResult,procedure,"ID="+menuID);
					
				}
			}
			
			function loadResult(e:Event):void
			{
				//this.cldConfig.removeLoadedListener(loadResult);
				e.target.removeEventListener(IOErrorEvent.IO_ERROR,ioError);
				e.target.removeEventListener(Event.COMPLETE,loadResult);
				var data:XML=XML(e.target.data);
				content.addView(data,param);
			}
			//this.dispatchEvent(new Event("showMenu3"));
		}
		
		override public function draw():void
		{
			 if(content)
			 {
				 content.setSize(this.width,this.height);
			 }
		}
	}
}