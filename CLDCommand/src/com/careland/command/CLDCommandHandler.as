package com.careland.command
{
	import com.careland.remote.CLDRemoteEvent;
	
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.utils.Dictionary;

	public class CLDCommandHandler extends EventDispatcher
	{
		private static var _instance:CLDCommandHandler;
		private var dic:Dictionary=new Dictionary;
		public function CLDCommandHandler(){
			super();
			if (this != _instance){
				_instance = this;
			};
		}
		public static function instance():CLDCommandHandler{
			if (!(_instance)){
				_instance = new (CLDCommandHandler)();
			};
			return (_instance);
		}
		public function registerCommand(type:String,eventHandler:IEventDispatcher):void
		{
			var item:Object=dic[type]; //如果key 相同 重置为数组
			if(item is EventDispatcher)
			{
				dic[type]=[item,eventHandler];
			}else 
			if(item is Array)
			{
				item.push(eventHandler);
			}else
			{
				dic[type]=eventHandler;	
			}
			
		}
		public function unregisterCommand(type:String,eventHandler:IEventDispatcher):void
		{
			var item:Object=dic[type]; //如果key 相同 重置为数组
			if(item is EventDispatcher)
			{
				if(item===eventHandler)
				{
					delete dic[type];
				}
			}else if(item is Array) //如果是数组 则删除数组中的元素
			{
					var arr:Array=item as Array;
					var index:int=-1;
					for(var i=0;i<arr.length;i++)
					{
						if(arr[i]===eventHandler)
						{
							index=i;
						}
					}
					if(index!=-1)
					{
						arr.splice(index,1);
					}
			}else
			{
					delete dic[type];
			}
		}
		
		public function parseCommand(mes:Message):void
		{
			var eh:Object=dic[mes.type];
			if(eh)
			{
				if(eh is Array)
				{
					for each(var item in eh)//判断是否是数组
					{
						var evt:CLDRemoteEvent=new CLDRemoteEvent(CLDRemoteEvent.READ_COMMAND);
						evt.message=mes;
						item.dispatchEvent(evt);
					}
				}else if(eh is EventDispatcher)
				{
					var evt:CLDRemoteEvent=new CLDRemoteEvent(CLDRemoteEvent.READ_COMMAND);
					evt.message=mes;
					eh.dispatchEvent(evt);
				}
				
			}
		}
	}
}