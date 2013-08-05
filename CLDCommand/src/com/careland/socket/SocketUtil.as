package com.careland.socket
{
	import com.careland.command.CLDCommandHandler;
	import com.careland.command.Message;
	import com.careland.remote.CLDRemoteEvent;
	import com.wf.CLDLog;
	
	import flash.events.DataEvent;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.events.SecurityErrorEvent;
	import flash.events.TimerEvent;
	import flash.net.ObjectEncoding;
	import flash.net.Socket;
	import flash.net.registerClassAlias;
	import flash.utils.ByteArray;
	import flash.utils.Timer;

	public class SocketUtil
	{
		
		private static var socket:CLDSocket;
		private static var debug:Boolean=false;
		private static var Host:String;                        
		private static var Port:Number;      
		private static var socketTimer:Timer;
		private static var command:CLDCommandHandler=CLDCommandHandler.instance();
		public function SocketUtil()
		{
			 
		}
		public static function init(ip:String,port:int,db:Boolean):void
		{
			 registerClassAlias("com.careland.command.Message",Message);
			 debug=db;
			 Host=ip;
			 Port=port;
			 if(!socket)
			 {
				 socket=new CLDSocket(ip,port);
				 socket.addEventListener(Event.CLOSE, closeHandler);
				 socket.addEventListener(Event.CONNECT, connectHandler);
				 socket.addEventListener(DataEvent.DATA, dataHandler);
				 socket.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
				 socket.addEventListener(ProgressEvent.SOCKET_DATA, progressHandler);
				 socket.addEventListener(SecurityErrorEvent.SECURITY_ERROR, securityErrorHandler);  
				 socket.connect(ip, port);                        
			 }
			 if(!socket.connected)
			 {
				 socket.connect(ip,port);
			 }
			 socketTimer=new Timer(1000);
			 socketTimer.addEventListener(TimerEvent.TIMER,timerHandler);
			 command.addEventListener(CLDRemoteEvent.SEND_COMMAND,send);

		}
		private static function send(e:CLDRemoteEvent):void
		{
			if(socket&&socket.connected)
			{
//				var bytes:ByteArray=new ByteArray();
//				bytes.writeObject(e.message);
//				socket.writeBytes(bytes,0,bytes.length);
				socket.writeObject(e.message);
				socket.flush();
			}
		}
		public static function log(value:String)
		{
			CLDLog.log(value);
		}
		
		private static function connectHandler(e:Event):void
		{
			socketTimer.stop();  //
		}
		private static function closeHandler(e:Event):void
		{
			socketTimer.start();//一直重连 
		}
		private static function dataHandler(e:DataEvent):void
		{
			 if(socket&&socket.connected)
			 {
				 var obj:Object=socket.readObject();
				 log("datahandler:"+obj.type);
				 trace(obj);
			 }
		}
		private static function ioErrorHandler(e:IOErrorEvent):void
		{
			
		}
		private static function progressHandler(e:ProgressEvent):void
		{
			var socket:Socket=e.target as Socket;
			if(socket)
			{
				var bytes:ByteArray =new ByteArray();
				while (socket.bytesAvailable) {
					socket.readBytes(bytes,0,socket.bytesAvailable);
				}
				try {
					var obj:Object=bytes.readObject();
					var mes:Message=objectToInstance(obj,Message);
					command.parseCommand(mes);
					log("datahandler1:"+mes.type);
					trace(mes);
				} catch (event:Error) {
					log("读取数据失败");
				}
			
			}
			
		}
		public static function objectToInstance( object:Object, clazz:Class ):*
		{
			var bytes:ByteArray = new ByteArray();
			bytes.objectEncoding = ObjectEncoding.AMF0;
			
			// Find the objects and byetArray.writeObject them, adding in the
			// class configuration variable name -- essentially, we're constructing
			// and AMF packet here that contains the class information so that
			// we can simplly byteArray.readObject the sucker for the translation
			
			// Write out the bytes of the original object
			var objBytes:ByteArray = new ByteArray();
			objBytes.objectEncoding = ObjectEncoding.AMF0;
			objBytes.writeObject( object );
			
			// Register all of the classes so they can be decoded via AMF
			var typeInfo:XML = flash.utils.describeType( clazz );
			var fullyQualifiedName:String = ( /::/, "." );
			registerClassAlias( fullyQualifiedName, clazz );
			
			// Write the new object information starting with the class information
			var len:int = fullyQualifiedName.length;
			bytes.writeByte( 0x10 );  // 0x10 is AMF0 for "typed object (class instance)"
			bytes.writeUTF( fullyQualifiedName );
			// After the class name is set up, write the rest of the object
			bytes.writeBytes( objBytes, 1 );
			
			// Read in the object with the class property added and return that
			bytes.position = 0;
			
			// This generates some ReferenceErrors of the object being passed in
			// has properties that aren't in the class instance, and generates TypeErrors
			// when property values cannot be converted to correct values (such as false
			// being the value, when it needs to be a Date instead).  However, these
			// errors are not thrown at runtime (and only appear in trace ouput when
			// debugging), so a try/catch block isn't necessary.  I'm not sure if this
			// classifies as a bug or not... but I wanted to explain why if you debug
			// you might seem some TypeError or ReferenceError items appear.
			var result:* = bytes.readObject();
			return result;
		}
		


		private static function securityErrorHandler(e:SecurityErrorEvent):void
		{
			 if(debug)
			 {
				  
			 }
		}
		private static function timerHandler(e:TimerEvent):void
		{
			  if(!socket.connected)
			  {
				  socket.connect(Host,Port);
			  }
		}
	}
}