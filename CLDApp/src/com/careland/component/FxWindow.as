package com.careland.component
{
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.display.Graphics;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.filters.DropShadowFilter;
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	

	public class FxWindow extends YDComponentBase
	{
		public var vwidth:Number=490;
		public var vheight:Number=280;
		
		private var content:Sprite;
		
		public var titleH:Number=15;
		
		public var borderW:Number=2;
		public var borderH:Number=2;
		public var title:String="窗口";
		
		public var text:TextField;
		
		public var touchDown:Boolean=false;
		public function FxWindow()
		{
			super();
			this.blobContainerEnabled=false;
			init();
			initSprite();
			initText();
			update();
			applyFilter();
			initEvent();
		}
		private function init():void
		{
			var g:Graphics=this.graphics;
			g.clear();
			g.beginFill(0xffffff,.3);
			g.drawRoundRect(0,0,this.vwidth,this.vheight,4,4);
			g.endFill();
		}
		private function initSprite():void
		{
			content=new Sprite();
			this.addChild(content);
			
			drawRect(content,0,0,this.vwidth-this.borderW*2,this.vheight-this.borderH-this.titleH);
		}
		private function initText():void
		{
			text=new TextField();
			text.text=this.title;
			text.defaultTextFormat=new TextFormat(null,12,0x000fff);
			text.selectable=false;
			text.cacheAsBitmap=true;
			text.textColor=0xfff000;
			this.addChild(text);
			
		}
		private function drawRect(dis:Object,vx:Number,vy:Number,vw:Number,vh:Number):void
		{
			var g:Graphics=dis.graphics;
			g.clear();
			g.beginFill(0xffffff,1);
			g.drawRect(vx,vy,vw,vh);
			g.endFill();
		}
		public function update(e:Event=null):void
		{
			
			content.x=this.borderW;
			content.y=this.titleH;
			
			text.x=2;
			text.y=1;
			init();
			content.width=this.vwidth-this.borderW*2;
			content.height=this.vheight-this.borderH-this.titleH;
			drawRect(content,0,0,this.vwidth-this.borderW*2,this.vheight-this.borderH-this.titleH);
			
		}
		public function initEvent():void
		{
			this.addEventListener("change",update);
//			this.addEventListener(gl.events.GestureEvent.GESTURE_SCALE,scaleHandler);
//			this.addEventListener(gl.events.GestureEvent.GESTURE_ROTATE,rotateHandler);
//			this.addEventListener(gl.events.GestureEvent.GESTURE_FLICK,flickHandler);
//			this.addEventListener(gl.events.TouchEvent.TOUCH_DOWN,downHandler);
//			this.addEventListener(gl.events.TouchEvent.TOUCH_UP,upHandler);
		}
//		protected function  scaleHandler(e:GestureEvent):void
//		{
//			this.scaleX+=e.value;
//			this.scaleY+=e.value;
//		}
//		protected function  rotateHandler(e:GestureEvent):void
//		{
//			this.rotation+=e.value;
//			
//		}
		protected function flickHandler(e:Event):void
		{
			
		}
//		protected function downHandler(e:TouchEvent):void
//		{
//			if(touchDown)
//				this.startTouchDrag(-1);
//		}
//		protected function upHandler(e:TouchEvent):void
//		{
//			if(touchDown)
//				this.stopTouchDrag(-1);
//		
//		}
		public function applyFilter():void
		{
			var filter:DropShadowFilter=new DropShadowFilter();
			this.filters=[filter];
		}
		override public function set width(e:Number):void
		{
			super.width=e;
			this.vwidth=e;	
			this.update();
		}
		override public function set height(e:Number):void
		{
			super.height=e;
			this.vheight=e;
			this.update();	
		}
		
		
		override public function set scaleX(arg0:Number):void
		{
			super.scaleX=arg0;
			update();	
		}
		override public function set scaleY(arg0:Number):void
		{
			super.scaleY=arg0;
			update();	
		}
		public function addElement(child:DisplayObject):void
		{
			
				content.addChild(child);
				child.width=this.vwidth-this.borderW*2;
				child.height=this.vheight-this.borderH-this.titleH;
				
		}
		public function set  url(v:String):void
		{
			super.loadImage(v);
		}
		override protected function loadComplete(e:Event):void{
			var bmp:Bitmap=e.target.content as Bitmap;
			this.addElement(bmp);
		}
		
		
		
		
		
	}
}