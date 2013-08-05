package com.careland.remote
{
	import com.careland.command.Message;
	
	import flash.events.Event;
	
	public class CLDRemoteEvent extends Event
	{
		public static var SEND_COMMAND="send_command";
		public static var READ_COMMAND="read_command";
		
		private var _message:Message;
		public function CLDRemoteEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}

		public function get message():Message
		{
			return _message;
		}

		public function set message(value:Message):void
		{
			_message = value;
		}

	}
}