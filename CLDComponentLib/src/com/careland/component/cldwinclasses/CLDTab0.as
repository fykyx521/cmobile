package com.careland.component.cldwinclasses
{
	import com.careland.component.CLDBaseComponent;
	import com.careland.component.CLDWindow;
	import com.careland.component.util.Style;
	
	import flash.display.Bitmap;
	import flash.display.DisplayObjectContainer;
	import flash.display.Graphics;
	import flash.display.Loader;
	import flash.text.TextField;

	public class CLDTab0 extends CLDBaseComponent
	{
		
		private var left:Bitmap;
		private var right:Bitmap;
		private var center:Bitmap;
		
		private var loader:Loader;
		
		private var uiLoad:Boolean=false;
		
		private var txt:TextField;
		
		private var minWidth:Number=100;
		
//		private var lrW:Number=18;//左右两个标记的宽度
//		private var lrH:Number=40;//左右两个标记的高度
		
		private var lrW:Number=9;//左右两个标记的宽度
		private var lrH:Number=55;//左右两个标记的高度
		
		private var centerWidth:Number=20;
		public function CLDTab0(parent:DisplayObjectContainer=null, xpos:Number=0, ypos:Number=0, autoLoad:Boolean=false, timeInteval:int=0)
		{
			super(parent, xpos, ypos, autoLoad, timeInteval);
		}
		
		override protected function addChildren():void
		{
			txt=new TextField();
			txt.embedFonts=true;
			this.addChild(txt);
			
			left=this.config.getBitmap("win_left");
			center=this.config.getBitmap("win_center");
			right=this.config.getBitmap("win_right");
//			
			
//			this.addChild(left);
//			this.addChild(center);
//			this.addChild(right);
		}
		
		
		
		
		override public function dispose():void
		{
			super.dispose();
			this.graphics.clear();
//			this.left=null;
//			this.right=null;
//			this.center=null;
//			this.txt=null;
		}
		
		
		override public function get width():Number
		{
			if(center){
				return this.lrW*2+this.centerWidth;
			}
			return 100;
			
		}
		
		override public function get height():Number
		{
			return this.lrH;
		}
		
		override public function draw():void
		{
			if(this.dataChange){
				
				var g:Graphics=this.graphics;
				g.clear();
				g.beginBitmapFill(this.left.bitmapData,null,false);
				g.drawRect(0,0,lrW,lrH);

				this.txt.text=String(data);
				txt.setTextFormat(Style.getTFF());
				var txtW:Number=txt.textWidth;
				
				var nw:Number=Math.max(txtW,this.minWidth);
				
//				var txtX:Number=(nw-txtW)/2;
//				txt.x=txtX+this.lrW;
				
				var txtY:Number=(this.lrH-txt.textHeight)/2;
				txt.y=txtY;
//				txt.textWidth

				g.beginBitmapFill(this.right.bitmapData,null,true,true);
				g.moveTo(nw+this.lrW,0);
				
				g.drawRect(nw+this.lrW,0,lrW,lrH);
				
				
				txt.width=nw+this.lrW*2;
				
				
				
				var txtH:Number=txt.textHeight;
				g.beginBitmapFill(this.center.bitmapData,null,true,true);
				g.moveTo(this.lrW,0);
				g.drawRect(lrW,0,nw,lrH);
				g.endFill();
				//this.center.width=nw;
				this.centerWidth=nw;
				//center.x=9;
				//right.x=center.width+9;
				
				
				if(parent&&parent is CLDWindow){
				
					CLDWindow(parent).drawTab();
				}
				dataChange=false;
				
			}
		}
		
	}
}