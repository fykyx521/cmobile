package com.careland.component.util
{
	import flash.text.TextFormat;
	
	public class Style
	{
		public function Style()
		{
		}
		//列表
		public static function getTFList():TextFormat{
			var tf:TextFormat=new TextFormat("msyh","12",0x000000);
			return tf;
		}
		
		//黑色
		public static function getTF():TextFormat{
			var tf:TextFormat=new TextFormat("msyh","20",0x000000);
			return tf;
		}
		//黑色
		public static function getTFTXT():TextFormat{
			var tf:TextFormat=new TextFormat("msyh","16",0x000000);		
				   
			return tf;
		}
		public static function getTFTXTButton():TextFormat{
			var tf:TextFormat=new TextFormat("msyh","16",0x000000);		
			tf.align="center";		   
			return tf;
		}
		
		public static function getTFTXT2():TextFormat{
			var tf:TextFormat=new TextFormat("msyh","16",0x000000);
			tf.align="center";
			return tf;
		}
		//白色
		public static function getTab():TextFormat{
			var tf:TextFormat=new TextFormat("msyh","14",0xffffff);		 
			return tf;
		}
		//白色
		public static function getWF():TextFormat{
			var tf:TextFormat=new TextFormat("msyh","16",0xffffff);		 
			return tf;
		}
		//白色
		public static function getWF2():TextFormat{
			var tf:TextFormat=new TextFormat("msyh","18",0xffffff);	
			    tf.bold=true;	 
			return tf;
		}
		//白色
		public static function getTFF():TextFormat{
			var tf:TextFormat=new TextFormat("msyh","20",0xffffff);
			tf.bold=true;
			tf.align="center";
			return tf;
		}
		//白色
		public static function getHead():TextFormat{
			var tf:TextFormat=new TextFormat("msyh","16",0xffffff);
			tf.bold=true;
			tf.align="center";
			return tf;
		}
		//菜单字体
		public static function getTFMenu():TextFormat{
			var tf:TextFormat=new TextFormat("msyh","18",0xffffff);
			tf.bold=true;
			tf.align="center";
			return tf;
		}
		//logo天气时间等信息
		public static function getTFLogo(fontSize:Number):TextFormat{
			var tf:TextFormat=new TextFormat("msyh",fontSize,0xffffff);
			return tf;
		}
		
		//地图提示框字体
		public static function getTFMapOver():TextFormat{
			var tf:TextFormat=new TextFormat("msyh","12",0xffffff);
			
			tf.bold=true;
			tf.align="center";
			return tf;
		}
		//地图切换字体
		public static function getTFMapType():TextFormat{
			var tf:TextFormat=new TextFormat("msyh","18",0x000000);
			
			tf.bold=true;
			tf.align="center";
			return tf;
		}
	}
}