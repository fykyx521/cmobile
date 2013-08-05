package com.careland.socket
{
	import flash.events.Event;
	import flash.net.Socket;
	import flash.utils.Timer;
	
	public class CLDSocket extends Socket
	{
		private var sokectTimer:Timer;
		public function CLDSocket(host:String=null, port:int=0)
		{
			super(host, port);
			
//			this.addEventListener(Event.CLOSE, closeHandler);
//			this.addEventListener(Event.CONNECT, connectHandler);
//			this.addEventListener(DataEvent.DATA, dataHandler);
//			this.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
//			this.addEventListener(ProgressEvent.PROGRESS, progressHandler);
//			this.addEventListener(SecurityErrorEvent.SECURITY_ERROR, securityErrorHandler);
//			
//			sokectTimer=new Timer(1000);
//			sokectTimer.addEventListener(TimerEvent.TIMER,timerHandler);
			
			
		}
		
	}
}