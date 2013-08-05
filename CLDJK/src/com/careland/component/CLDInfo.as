package com.careland.component
{
	import flash.display.DisplayObjectContainer;
	import flash.display.Graphics;
	import flash.filters.DropShadowFilter;
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	public class CLDInfo extends CLDBaseComponent
	{
		
		public function CLDInfo(parent:DisplayObjectContainer=null, xpos:Number=0, ypos:Number=0, autoLoad:Boolean=false, timeInteval:int=0)
		{
			super(parent, xpos, ypos, autoLoad, timeInteval);
		}
		private var txt:TextField;
		override protected function addChildren():void
		{
			txt=new TextField();
			txt.selectable=false;
			txt.multiline=true;
			txt.wordWrap=true;
			txt.defaultTextFormat=new TextFormat("msyh",30,0x01314d);
			//txt.embedFonts=true;
			this.addChild(txt);
			this.filters=[this.getShadow(5)];
		}
	
		override public function draw():void
		{
			if(txt&&this.dataChange)
			{
				txt.text=this.data;
				txt.width=this.width;
				txt.height=txt.textHeight+5;
				var g:Graphics=this.graphics;
				g.clear();
				g.lineStyle(2,0xabbcca,0.9);
				g.beginFill(0xffffff,1);
				g.drawRoundRect(4,4,this.width-8,txt.height-8,8,8);
				g.endFill();
				
			}
		}
	}
}