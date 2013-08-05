package com.cglib.controls
{
	import com.cglib.MultiTouchSocket;
	
	import flash.utils.Dictionary;
	
	public class CommandStack
	{
		private var dic:Dictionary;
		private static var instance:CommandStack
		
		public function CommandStack(single:singletonForcer)
		{
			dic=new Dictionary();
		}
		
		public static function getInstance():CommandStack{
			if(instance==null){
				instance=new CommandStack(new singletonForcer());
			}
			return instance;
		}
		//返回标识符，唯一值，
		public function addCommand(value:String):String{
			var id:String=NumberUtilities.getUnique().toString();
			if(dic[id]==null){
				dic[id]=value;
				//value::OPENFOLDER "I:\"
				try{
					MultiTouchSocket.deskXMLsendCmd(id.toString()+":"+value);
				}
				catch(e:Error){
					throw e;
				}
				return id;
			}else{
				throw new Error("命令重复,CommandStack.as");
			}
		}
		
		public function execCommand(id:String):void{			
			var cmd:String=getCommand(id);
			MultiTouchSocket.deskXMLsendCmd(cmd);
		}
		
		//如果　返回的结果是成功的，那么将立刻删除该命令
		public function removeCommand(id:String):void{
			//value::OPENFOLDER "I:\"
		    delete dic[id];			
		}
		
		public function getCommand(id:String):String{
			if(dic[id]!=null){
				return dic[id];
			}else{
				throw new Error("找不到相应的命令！！");
			}
		}
		public function closeSocket():void{
			MultiTouchSocket.closeDeskXMLSocket();
		}
	}
}
class singletonForcer{
	public function singletonForcer(){}
}