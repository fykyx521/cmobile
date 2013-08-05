package com.careland
{
	import com.careland.component.CLDBaseComponent;
	
	import flash.display.DisplayObjectContainer;
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	public class CLDWeather extends CLDBaseComponent
	{
		public function CLDWeather(parent:DisplayObjectContainer=null, xpos:Number=0, ypos:Number=0, autoLoad:Boolean=false, timeInteval:int=0)
		{
			super(parent, xpos, ypos, autoLoad, timeInteval);
		}
		
		private var txt:TextField;
		override protected function addChildren():void
		{
			txt=new TextField();
			txt.selectable=false;
			txt.multiline=false;
			txt.wordWrap=false;
			txt.defaultTextFormat=new TextFormat("msyh",30,0x01314d);
			//txt.embedFonts=true;
			this.addChild(txt);
		}
		override public function draw():void
		{
			if(data)
			{
				var txtstr:String="天气情况:"+XML(data).data.@天气情况;
				txt.text=txtstr;
				txt.width=txt.textWidth+5;
				txt.height=txt.textHeight+5;
				txt.x=(this.width-txt.width)/2;
			}
		}
	}
}