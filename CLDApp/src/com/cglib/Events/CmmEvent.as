package com.cglib.Events
{
	import flash.events.MouseEvent;
	
	public class CmmEvent extends myEvent
	{
		public static var SocketInitlized:String="com.InitMySockets.SocketInitlized";
		public static var CmmData:String="com.InitMySockets.SocketData";
		
		public static var DEL_SUCCESS:String="com.InitMySockets.DEL_SUCCESS";
		public static var DEL_FALSE:String="com.InitMySockets.DEL_FALSE";
		
		public static var COPY_SUCCESS:String="com.InitMySockets.COPY_SUCCESS";
		public static var COPY_FALSE:String="com.InitMySockets.COPY_FALSE";
		
		public static var OPENFOLDER_SUCCESS:String="com.InitMySockets.OPENFOLDER_SUCCESS";
		public static var OPENFOLDER_FALSE:String="com.InitMySockets.OPENFOLDER_FALSE";
		
		public static var PLAYPPT_SUCCESS:String="com.InitMySockets.PLAYPPT_SUCCESS";
		public static var PLAYPPT_FALSE:String="com.InitMySockets.PLAYPPT_FALSE";
		
		public static var SHOWALLFLASHDISK_SUCCESS:String="com.InitMySockets.SHOWALLFLASHDISK_SUCCESS";
		public static var SHOWALLFLASHDISK_FALSE:String="com.InitMySockets.SHOWALLFLASHDISK_FALSE";
		
		public static var OPENALLFILE_SUCCESS:String="com.InitMySockets.OPENALLFILE_SUCCESS";
		public static var OPENALLFILE_FALSE:String="com.InitMySockets.OPENALLFILE_FALSE";
		
		public static var OPENURL_SUCCESS:String="com.InitMySockets.OPENURL_SUCCESS";
		public static var OPENURL_FALSE:String="com.InitMySockets.OPENURL_FALSE";
		
		public static var OPENFILE_SUCCESS:String="com.InitMySockets.OPENFILE_SUCCESS";
		public static var OPENFILE_FALSE:String="com.InitMySockets.OPENFILE_FALSE";
		
		public static var EXEC_SUCCESS:String="com.InitMySockets.EXEC_SUCCESS";
		public static var EXEC_FALSE:String="com.InitMySockets.EXEC_FALSE";
		
		public static var INITCOMPLETE_SUCCESS:String="com.InitMySockets.INITCOMPLETE_SUCCESS";
		public static var INITCOMPLETE_FALSE:String="com.InitMySockets.INITCOMPLETE_FALSE";
		
		public static var PROGRAMEXIT_SUCCESS:String="com.InitMySockets.PROGRAMEXIT_SUCCESS";
		public static var PROGRAMEXIT_FALSE:String="com.InitMySockets.PROGRAMEXIT_FALSE";
		
		public static var SocketIoErrorHandler:String="SocketInit.ERROR";
		
		public var cmddata:XML;
		public function CmmEvent(type:String, bubbles:Boolean=true, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
			trace(type);
			
		}		
	}
}