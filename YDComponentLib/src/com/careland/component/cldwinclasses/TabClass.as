package com.careland.component.cldwinclasses
{
	import flash.display.Bitmap;
	import flash.display.GradientType;
	import flash.display.Graphics;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.geom.Matrix;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;

	public class TabClass extends Sprite
	{
		
		[Embed(source='assets/tab/center.png')]
		private var center:Class;
		
		[Embed(source='assets/tab/left.png')]
		private var left:Class;
		
		[Embed(source='assets/tab/right.png')]
		private var right:Class;
		
		
		[Embed(source='assets/tab/default.png')]
		private var default_:Class;
		
		public var minW:int=100;//标签最小宽度
		
		public var minH:int=58;
		
		private var title:String;
		private var _type:String;
		
		private var txt:TextField;
		//type: left/right/center
		public function TabClass(txt:String,type:String="center")
		{
			super();
			title=txt;
			_type=type;
			initTab(txt,type);
		}
		public function initTab(str:String,type:String,update:Boolean=false):void
		{
			
			this.initTxt(str);
			this.layoutUI(type);
			
		}
		public function initTxt(txtstr:String):void
		{
			txt=new TextField();
			txt.text=txtstr;
			txt.textColor=0xffffff;
			txt.multiline=false;
			txt.wordWrap=false;
			txt.background=false;
			txt.selectable=false;
			//txt.embedFonts=true;
			
			var tf:TextFormat=new TextFormat();
			tf.align=TextFormatAlign.CENTER;
			tf.font="msyh";
			tf.size=12;
			tf.color=0xffffff;
			tf.align=TextFormatAlign.CENTER;
			
			txt.setTextFormat(tf);
			this.addChild(txt);
		}
		public function layoutUI(type:String):void
		{
			var txtw:Number=txt.textWidth;
			var txth:Number=txt.textHeight;
			
			
			txt.height=txth;
			txt.width=txtw+20; 
			
			var g:Graphics=this.graphics;
			g.clear();
			var tw:int=0;//字体宽度
			var th:int=minH;
			
			switch(type){
				case "left":tw=getWidth(txtw);txt.width=txtw+48;drawLeft(g,tw,th);break;
				case "center":tw=getWidth(txtw); drawCenter(g,tw,th);break;
				case "right":tw=getWidth(txtw); drawRight(g,tw,th);break;
				case "first":tw=getWidth(txtw); txt.width=txtw+56;drawFirst(g,tw,th);break;//只有一个的情况
			}
			
			txt.y=(this.minH-txth)/2;
			
		}
		
		
		public function getWidth(txtW:Number):int
		{
			if(txtW<minW){
				return minW;
			}
			return txtW+20;
		}
		public function updateTo(type:String="center"):void
		{
			if(this._type!=type){
				this._type=type;
				this.updateTo(type);
				trace("type:"+type);
			}
			
		}
		private function drawLeft(g:Graphics,tw:Number,txth:Number):void
		{
//			var matr:Matrix = new Matrix();
//  			matr.createGradientBox(20, 20, 0, 0, 0);
//
//			g.beginGradientFill(GradientType.LINEAR,[0x0000FF,0x0000FF],[1,.5],[0xff,0x00],matr);
//			g.drawRoundRect(0,0,40,20,10,10);
//			g.endFill();
			this.width=tw;
			
		}
		private function drawRight(g:Graphics,tw:Number,txth:Number):void
		{
			
			drawLeft(g,tw,txth);
		}
		private function drawCenter(g:Graphics,tw:Number,txth:Number):void
		{
			
			drawLeft(g,tw,txth);
		}
		private function drawFirst(g:Graphics,tw:Number,txth:Number):void
		{
			drawLeft(g,tw,txth);
		}
		
		
		
		private function drawLeft0(g:Graphics,tw:Number,txth:Number):void
		{
			drawLeft(g,tw,txth);
			
		}
		
		private function drawRight0(g:Graphics,tw:Number,txth:Number):void
		{
			
			
			
			
			g.beginBitmapFill((new default_ as Bitmap).bitmapData);
			g.drawRect(0,0,tw,minH);
			g.endFill();
			
			var shape:Shape=new Shape;
			var sg:Graphics=shape.graphics;
			sg.beginBitmapFill((new right as Bitmap).bitmapData,null,false,false);
			sg.drawRect(0,0,28,minH);
			sg.endFill();
			this.addChild(shape);
			shape.x=tw;
			
			this.width=tw+28;
		}
		private function drawCenter0(g:Graphics,tw:Number,txth:Number):void
		{
			
			
			g.beginBitmapFill((new center as Bitmap).bitmapData);
			g.drawRect(0,0,tw,minH);
			g.endFill();
			this.width=tw;
		}
		
		private function drawFirst0(g:Graphics,tw:Number,txth:Number):void
		{
			g.beginBitmapFill((new left as Bitmap).bitmapData,null,false);
			g.drawRect(0,0,28,minH);
			g.endFill();
			
			g.beginBitmapFill((new default_ as Bitmap).bitmapData);
			g.drawRect(28,0,tw,minH);
			g.endFill();
			
			var shape:Shape=new Shape;
			var sg:Graphics=shape.graphics;
			sg.beginBitmapFill((new right as Bitmap).bitmapData,null,false,false);
			sg.drawRect(0,0,28,minH);
			sg.endFill();
			this.addChild(shape);
			shape.x=tw+28;
			
			this.width=tw+56;
			
			
			
			
		}
		
		
		
		
	}
}