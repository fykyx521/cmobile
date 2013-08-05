package com.careland.component
{
	import com.careland.component.util.Style;
	
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.display.Graphics;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.utils.getTimer;

	public class YDDateWeather extends YDComponentBase
	{
		
		private var weatherTxt:TextField;//天气情况
		private var addrTxt:TextField;//地址
		private var timeTxt:TextField;//时间
		private var dateTxt:TextField;//时间
		private var wdTxt:TextField;//温度
		
		private var weather:Bitmap;
		public var ct:int=0;
		
		private var content:Sprite;
		private var contentMask:Sprite;
		
		public function YDDateWeather()
		{
			super();
			
			ct=flash.utils.getTimer();
			this.addEventListener(Event.ENTER_FRAME,update);
		}
		private function update(e:Event):void
		{
			var nt:int=flash.utils.getTimer();
			if(nt-ct>1000*60){
				var data:Date=new Date();
				timeTxt.text=data.getHours()+":"+convert(data.getMinutes());
				timeTxt.setTextFormat(Style.getTFLogo(40));
				
				dateTxt.text=data.getFullYear()+"年"+convert(data.getMonth()+1)+"月"+convert(data.getDate())+"日";
				dateTxt.setTextFormat(Style.getTFLogo(16));
				ct=nt;
			}
		}
		
		private function getTxt():TextField
		{
			var txt:TextField=new TextField();
			txt.selectable=false;
			txt.multiline=false;
			txt.wordWrap=false;
			txt.embedFonts=true;
			this.content.addChild(txt);
			return txt;
		}
		
		override protected function createUI():void
		{
			content=new Sprite;
			this.addChild(content);
			contentMask=new Sprite;
			this.addChild(contentMask);
			content.mask=contentMask;
			
			var data:Date=new Date();
			
			weatherTxt=getTxt();
			
			weatherTxt.x=1670;
			weatherTxt.y=18;
			
//			addrTxt=getTxt();
//			addrTxt.text="深圳";
//			addrTxt.setTextFormat(Style.getTFLogo(14));
//			addrTxt.x=1694;
//			addrTxt.y=45;
//			addrTxt.height=addrTxt.height;
			
			wdTxt=getTxt();
			
			wdTxt.x=1649;
			wdTxt.y=64;
			
			timeTxt=getTxt();
			
			//timeTxt.text="10:30";
			timeTxt.text=data.getHours()+":"+convert(data.getMinutes());
			timeTxt.setTextFormat(Style.getTFLogo(40));
			timeTxt.x=1775;
			timeTxt.y=18;
			timeTxt.width=200;
			timeTxt.height=50;
			
			
			dateTxt=getTxt();
			dateTxt.text=data.getFullYear()+"年"+convert(data.getMonth()+1)+"月"+convert(data.getDate())+"日";
			dateTxt.setTextFormat(Style.getTFLogo(16));
			dateTxt.width=200;
			dateTxt.x=1775;
			dateTxt.y=73;
			//dateTxt.height=addrTxt.height;
			
			
			//设置mask 否则这个组件 会把二级菜单 顶部挡住
			var g:Graphics=this.contentMask.graphics;
			g.beginFill(0x000fff,1);
			g.drawRect(1500,0,400,105);
			g.endFill();
			
			
//			drawRect(weatherTxt,0xff1122);
//			drawRect(addrTxt,0xaa1133);
//			drawRect(wdTxt,0xbb1144);
//			drawRect(timeTxt,0xcc1155);
//			drawRect(dateTxt,0xdd1166);
			
			
			
			
			
			this.loadProduce(result,this.cldConfig.getProcedure("weather"));
		}
		private function drawRect(dis:DisplayObject,color:uint):void
		{
			var g:Graphics=this.graphics;
			var rect:Rectangle=this.getBounds(dis);
			g.beginFill(color,1);
			g.drawRect(rect.x,rect.y,rect.width,rect.height);
			g.endFill();
		}
		
		private function result(e:Event):void
		{
			e.target.removeEventListener(IOErrorEvent.IO_ERROR,super.ioerror);
			e.target.removeEventListener(Event.COMPLETE,result);
			var resultXML:XML=XML(e.target.data);
			var config:XML=resultXML.data[0];
 			weatherTxt.text=config.@天气情况;
			weatherTxt.setTextFormat(Style.getTFLogo(20));
			
			wdTxt.text=config.@最低度数+"-"+config.@最高度数;
			wdTxt.setTextFormat(Style.getTFLogo(23));
			wdTxt.width=wdTxt.textWidth+10;
			
			var weatherURL:String=config.@图标;
			this.loadImage(weatherURL);
			
			
		}
		override protected function loadComplete(e:Event):void
		{
			super.loadComplete(e);
			var bit:Bitmap=e.target.content as Bitmap;
			
			this.weather=bit;
			this.addChildAt(weather,0);
			weather.y=-15;
//			weather.x=1550;
			
			weather.x=1500;
			
		}
		
		private function convert(num:Number):String
		{
			if(num<10){
				return "0"+num;
			}
			return num+"";
		}
		
	}
}