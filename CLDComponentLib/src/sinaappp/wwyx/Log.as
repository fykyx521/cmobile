package sinaappp.wwyx
{
	import flash.events.Event;
	import flash.events.StatusEvent;
	import flash.net.LocalConnection;
	
	//import nl.demonsters.debugger.MonsterDebugger;

	public class Log
	{
		private static var logcc:LocalConnection;
		public function Log()
		{
			
		}
		public static function init():void
		{
			logcc=new LocalConnection();
			//logcc.client=this;    
			logcc.addEventListener(StatusEvent.STATUS,StatusHandler);
		}
		private static function StatusHandler(e:StatusEvent):void
		{
			switch (e.level) {
				case "status" :
					//trace("LocalConnection.send() succeeded");
					break;
				case "error" :
					//trace("LocalConnection.send() failed");
					break;
			}
		}
		public static function log(msg:String):void
		{
			logcc.send("app#AFLog:_fyk_wwyx","log",msg);	
			
		}
		public static function d(msg:Object):void
		{
			//MonsterDebugger.trace(msg,msg);
		}
	}
}