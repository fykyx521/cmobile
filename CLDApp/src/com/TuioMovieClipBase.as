package com
{
	import com.cglib.Events.CmmEvent;
	import com.cglib.Events.myEventDispatcher;
	import com.cglib.MultiTouchSocket;
	import com.cglib.controls.CommandStack;
	import com.cglib.controls.CommandStringUti;
	
	import flash.display.Sprite;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.net.*;
	import flash.system.fscommand;

	public class TuioMovieClipBase extends MovieClip
	{
		public var dispatcher:myEventDispatcher;
		public var cmdstack:CommandStack;
		public var CmdIsReady:Boolean=true;
		public var debugMode:Boolean;
		public var ScreenX:Number=1024;
		public var ScreenY:Number=768;
		public function TuioMovieClipBase(debug:Boolean=false)
		{
			super();			
			this.addEventListener(Event.ADDED_TO_STAGE,onAdded);
			debugMode=debug;
		}
		private function onAdded(evt:Event):void{
						
			//初始化多点触控消息，初始化后台文件操作接口
			//this.width=2400;
			//this.height=600;
			MultiTouchSocket.init(this,debugMode);
				
			//得到文件操作接口的实例
			cmdstack=CommandStack.getInstance();
			
			//初始化文件操作事件“收听器”
			dispatcher=myEventDispatcher.getInstance();
			
			//添加事件
			dispatcher.addEventListener(CmmEvent.SocketIoErrorHandler,onSocketIoErrorHandler);	
			dispatcher.addEventListener(CmmEvent.SocketInitlized,onSocketInitialized);			
		}
		private function configxmlload(e:Event)
		{
			try
			{
				var xml:XML = new XML(e.target.data);
				
				ScreenX=xml.resolution.width;
				ScreenY=xml.resolution.height;
				trace(ScreenX);
				trace(ScreenY);
				if (xml.closebutton=="true")
				{

				//----------------------------------------------------------创建关闭按钮
				 	var CloseApp1:closeapp=new closeapp();
				 	addChild(CloseApp1);
				 	CloseApp1.x=ScreenX-10;
				 	CloseApp1.y=ScreenY-10;
				 	this.setChildIndex(CloseApp1,this.numChildren-1); 
					CloseApp1.addEventListener(MouseEvent.CLICK ,onPgExit);
					CloseApp1.name="closeapp";
					//trace("addcloseapp");
					//CloseApp1.addEventListener(TUIOEvent.TUIO_DOWN ,quitapp);
				//--------------------------------------------------------------
				}	
				this.dispatchEvent(new Event("SocketFinished"));	
				//this.dispatchEvent(new Event("aaa"));
			}
			catch (e:TypeError)
			{
			}

			
		}	
		private function onSocketIoErrorHandler(evt:CmmEvent):void{
			 CmdIsReady=false;
			 //this.dispatchEvent(new Event("SocketFinished"));
			 var xmlLoader:URLLoader=new URLLoader();
			xmlLoader.addEventListener(Event.COMPLETE, configxmlload, false, 0, true); 			
			xmlLoader.load(new URLRequest("config.xml"));
		}		
		private function onSocketInitialized(e:Event)
		{
			dispatcher.removeEventListener(CmmEvent.SocketInitlized,onSocketInitialized);
			cmdstack.addCommand(CommandStringUti.INITCOMPLETE());
			CmdIsReady=true;
			//加载程序配置文件（配置该程序是否有关闭按钮，以及该程序的多媒体资源的路径从哪里来）	
			
			var xmlLoader:URLLoader=new URLLoader();
			xmlLoader.addEventListener(Event.COMPLETE, configxmlload, false, 0, true); 			
			xmlLoader.load(new URLRequest("config.xml"));

		}
		//--------------------------------------------退出程序--------------------------
		private function onPgExit(e:MouseEvent):void{
			if (!CmdIsReady) 
			{
				fscommand("quit");
			}
			else
			{
			try{
					
					dispatcher.addEventListener(CmmEvent.PROGRAMEXIT_SUCCESS,onExitSuccessed);
					dispatcher.addEventListener(CmmEvent.PROGRAMEXIT_FALSE,onExitFailed);
					cmdstack.addCommand(CommandStringUti.PROGRAMEXIT(true));	
					//
				}
				catch(e:TypeError)
				{
					fscommand("quit");
				}
			}
			
		}
		private function onExitSuccessed(evt:CmmEvent):void{
				fscommand("quit");
				MultiTouchSocket.closeDeskXMLSocket();
		}
		private function onExitFailed(evt:CmmEvent):void{
				fscommand("quit");
				MultiTouchSocket.closeDeskXMLSocket();
		}
        //------------------------------------------------------------------------------
	}
}