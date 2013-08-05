package com.careland.command
{
	import flash.events.Event;
	public dynamic class Message
	{
		private var _type;//命令类型 
		private var _data:*;
		public function Message(type:String="")
		{
			super();
			this._type=type;
		}

		public function get type()
		{
			return _type;
		}

		public function set type(value):void
		{
			_type = value;
		}

		public function get data():*
		{
			return _data;
		}

		public function set data(value:*):void
		{
			_data = value;
		}
		public function toJSON():String
		{
			return 	"";
		}
		public static function buildMsg(type:String):Message
		{
			var mes:Message=new Message(type);
			return mes;
			
		}
			


	}
}