package com.careland.main.ui
{
	import com.careland.YDConfig;
	import com.careland.event.ResouceEvent;
	import com.careland.ui.LoadShow;
	import com.demonsters.debugger.MonsterDebugger;
	
	import fl.controls.Button;
	
	import flash.display.Graphics;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filters.DropShadowFilter;
	import flash.text.TextField;
	import flash.text.TextFieldType;
	import flash.text.TextFormat;
	
	public class CLDSetting extends CLDBaseUI
	{
		private var txt:TextField;
		private var sure:Button;
		private var load:LoadShow;
		public function CLDSetting()
		{
			super();
		}
		override protected function addChildren():void
		{
			this.filters=[new DropShadowFilter()];
			txt=new TextField();
			txt.alwaysShowSelection=true;
			txt.type=TextFieldType.INPUT;
			var tf:TextFormat=new TextFormat("msyh",48,0x000000);
			txt.defaultTextFormat=tf;
			txt.text="http://192.168.68.167/dyh/flash/assets/config.xml";
			txt.multiline=false;
			txt.wordWrap=false;
			txt.selectable=true;
			txt.width=760;
			txt.height=100;
			txt.border=true;
			txt.borderColor=0xffffff;
 
			this.addChild(txt);
			var tf1:TextFormat=new TextFormat("msyh",36,0x000000);
			sure=new Button();
			this.addChild(sure);
			sure.label="确定";
			sure.setStyle("textFormat", tf1);
			sure.setSize(200,60);
			sure.addEventListener(MouseEvent.CLICK,startLoad);
			
		}
		private function startLoad(e:Event):void
		{
			txt.border=false;
			YDConfig.instance().addEventListener(ResouceEvent.PROGRESS,progress);
			YDConfig.instance().loadConfig(txt.text,log);
		}
		private function progress(e:ResouceEvent):void
		{
			txt.text="加载中:"+e.itemLoaded+"/"+e.totalItems;
		}  
		
		override public function draw():void
		{
			var g:Graphics=this.graphics;
			g.clear();
			g.beginFill(0xffffff,.5);
			g.drawRoundRect(0,0,this.width,this.height,20,20);
			g.endFill();
			if(txt)
			{
				txt.x=(this.width-txt.width)/2;
				txt.y=20;
			}
			if(sure)
			{
				sure.move((this.width-sure.width)/2,200);
				
			}
		}
	}
}