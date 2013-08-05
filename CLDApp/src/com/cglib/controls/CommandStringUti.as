package com.cglib.controls
{
	public class CommandStringUti
	{
		public function CommandStringUti()
		{
		}
		//1、去除触摸点干扰：RemoveBackGround
		//1、去除触摸点干扰：RemoveBackGround
		public static function RemoveBackGround(value:String=""):String{
			return "RemoveBackGround";
		}
		//2、停止发送多点触摸信号 	StopSendOscMessage 
		public static function StopSendOscMessage():String{
			return "StopSendOscMessage";
		}
		//3、开始发送多点触摸信号		BeginSendOscMessage 
		public static function BeginSendOscMessage():String{
			return "BeginSendOscMessage";
		}
		//4、停止模拟鼠标			StopMouseEvent		
		public static function StopMouseEvent():String{
			return "StopMouseEvent";
		}
		//5、开始模拟鼠标			BeginMouseEvent		
		public static function BeginMouseEvent():String{
			return "BeginMouseEvent";
		}
		//	6、删除文件：DEL “FILENAME”    会收到15
		public static function DEL(fileName:String):String{
			return "DEL \""+fileName+"\"";
		}
		//	7、拷贝文件：COPY  “SOURCEFILENAME”  “AIMFILENAME” 会收到16
		public static function COPY(source:String,aim:String):String{
			return "COPY \""+source+"\" \""+aim+"\"";
		}
		//8、打开文件夹：OPENFOLDER  “FOLDER” 会收到23
		public static function OPENFOLDER(folderName:String):String{
			return "OPENFOLDER \""+folderName+"\"";
		}
		
		//9、播放文件： PLAYPPT “FILENAME” 会收到18 ，19
		public static function PLAYPPT(fileName:String):String{
			return "PLAYPPT \""+fileName+"\"";
		}
		//10、查询所有u盘设备：SHOWALLFLASHDISK 会收到22
		public static function SHOWALLFLASHDISK():String{
			return "SHOWALLFLASHDISK";
		}
		//11、打开u盘里所与文件：OPENALLFILE “volume”会收到23
		public static function OPENALLFILE(volume:String):String{
			return "OPENALLFILE \""+volume+"\"";
		}
		//13、打开网页
		public static function OPENURL(URL:String):String{
			return "OPENURL \""+URL+"\"";
		}
		//14、打开文件
		public static function OPENFILE(fileName:String):String{
			return "OPENFILE \""+fileName+"\"";
		}
		//15、执行程序 EXEC “EXEFILEPATH”
		public static function EXEC(exepath:String):String{
			return "EXEC \""+exepath+"\"";
		}
		//16、程序初始化完毕：INITCOMPLETE
		public static function INITCOMPLETE():String{
			return "INITCOMPLETE";
		}
		//17、程序退出：PROGRAMEXIT  TRUE/FALSE 
		public static function PROGRAMEXIT(bl:Boolean):String{
			var c:String;
			if(bl){
				c="TRUE";
			}else{
				c="FALSE";
			}
			return "PROGRAMEXIT "+c;			
		}
		//	18、拷贝文件夹：COPY  “SOURCEFILENAME”  “AIMFILENAME” 会收到16
		public static function COPYFOLDER(source:String,aim:String):String{
			return "COPYFOLDER \""+source+"\" \""+aim+"\"";
		}
	}
}