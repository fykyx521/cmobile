package com.cglib
{
	import com.cglib.Events.CmmEvent;
	import com.cglib.Events.MssEvent;
	import com.cglib.controls.CommandStack;
	import com.touchlib.TUIO;
	
	import flash.display.DisplayObjectContainer;
	import flash.display.Stage;
	import flash.events.DataEvent;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.net.XMLSocket;
	import flash.system.fscommand;
	import flash.text.TextField;
	
	public class MultiTouchSocket extends EventDispatcher
	{
		private var deskXML:XMLSocket;
		private var s:Stage;
		private static var instance:MultiTouchSocket;
		private var cmdstack:CommandStack;
		
		private var debugText:TextField;
		
		public static function init(root:DisplayObjectContainer,debugMode:Boolean=false):void{
			if(instance==null){
				instance=new MultiTouchSocket(new singletonForce(),root,debugMode);
			}else{
				throw new Error("出现错误，重复创建　Socket对象！initMySocets.as init方法");
			}
		}
		public static function getInstance():MultiTouchSocket{
			if(instance==null){
				throw new Error("Socket未建立，InitMySockets.as,getInstance");
			}else{
				return instance;
			}
		}
		
		
		public static function deskXMLsendCmd(cmd:String):void{			
			try{
				instance.deskXML.send(cmd);
				//deskXML.send("COPY \"C:\\TEST.txt\" \"C:\\temp\\TEST.txt\"");
			}catch(e:Error){
				throw(e);
			}
		}
		
		public static function closeDeskXMLSocket():void{
			try{
				instance.deskXML.close();
			}catch(e:Error){
				trace("MultiTouchSocket.as closeDeskXMLSocket method:",e);
			}			
		}
		public function MultiTouchSocket(force:singletonForce,root:DisplayObjectContainer,debugMode:Boolean)
		{			
			TUIO.init( root, '127.0.0.1', 3030, '', debugMode );			
			startDeskSockets();
			cmdstack=CommandStack.getInstance();
			s=root.stage;
			
		}
		
		
		private function startDeskSockets():void{
			try{
				
				deskXML=new XMLSocket();
				deskXML.connect("127.0.0.1",3013);
				deskXML.addEventListener(Event.CONNECT,onDeskSocketConnected);
				deskXML.addEventListener(DataEvent.DATA,onDeskSocketHandler);
				deskXML.addEventListener(IOErrorEvent.IO_ERROR,onDeskSocketIoErrorHandler);
			}catch(e:Error){
				
			}
		}
		
		private function onDeskSocketHandler(evt:DataEvent):void{
			var cmddata:XML=XML(evt.data);
			//debugText.text=evt.data.toString();
			var cmdname:String;	
			
			var localname:String=cmddata.localName().toString().toLowerCase();			
			if(localname=="command"){
				cmdname=cmdstack.getCommand(cmddata.id).split(" ")[0];				
				if(cmddata.result!="success"){
					cmdname+="_FALSE";
				}else{
					cmdname+="_SUCCESS";
					cmdstack.removeCommand(cmddata.id);
				}
				
				var event:CmmEvent=new CmmEvent(CmmEvent[cmdname]);
				event.id=cmddata.id;
				event.cmddata=cmddata;
				event.dispatchEvent();
			}else if(localname=="message"){
				/*
			 	<message>
	  				<action>DiskRemoved</action>
					<Upan volume="I:" ID="44" X="700" Y="200"/>
				</message> 
			 
			 	*/
				try{
					var event2:MssEvent=new MssEvent(MssEvent[cmddata.action]);
					event2.ID=cmddata.Upan.@ID;
					event2.X=Number(cmddata.Upan.@X);
					event2.Y=Number(cmddata.Upan.@Y);
					event2.volume=cmddata.Upan.@volume;
					if(String(event2.volume).length<2){
						event2.volume=cmddata.volume;
					}
					event2.cmddata=cmddata;
					event2.dispatchEvent();
				}catch(e:Error){
					trace(e,"In MultiTouchSocket.as onDeskSocketHandler");
				}
			}
			
			
		}
		private function onDeskSocketConnected(evt:Event):void{
			
			var event:CmmEvent=new CmmEvent(CmmEvent.SocketInitlized);
			event.dispatchEvent();
			
		}
		private function onDeskSocketIoErrorHandler(evt:IOErrorEvent):void{
			var event:CmmEvent=new CmmEvent(CmmEvent.SocketIoErrorHandler);
			event.dispatchEvent();
		}
		private function onSocketIoErrorHandler(evt:IOErrorEvent):void{
			trace("IoErrorEventHandler:",evt);
		}
		
		public function quit():void{
			fscommand("quit");
		}
	}
}
class singletonForce{
	public function singletonForce(){}
}