package com.identity.timer
{
	import com.careland.component.CLDBaseComponent;
	import com.careland.component.util.Style;
	import com.careland.event.TimerEvent;
	import com.touchlib.TUIOEvent;
	
	import flash.display.Bitmap;
	import flash.display.DisplayObjectContainer;
	import flash.display.Graphics;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import flash.text.TextField;

	public class CLDSlider extends CLDBaseComponent
	{
		private var logo:Bitmap;
		private var line:Bitmap;
		private var txt:TextField;
		
		private var logoSprite:Sprite
		public function CLDSlider(parent:DisplayObjectContainer=null, xpos:Number=0, ypos:Number=0, autoLoad:Boolean=false, timeInteval:int=0)
		{
			super(parent, xpos, ypos, autoLoad, timeInteval);
		}
		
		override protected function addChildren():void
		{
			logo=new Bitmap();
			line=new Bitmap();
			logo.bitmapData=this.config.getBitmap("timerLogo").bitmapData.clone();
			line.bitmapData=this.config.getBitmap("timerLine").bitmapData.clone();
			
//			logo.width=45;
//			logo.height=50;
			
				txt=new TextField;
			txt.selectable=false;
			txt.wordWrap=true;
			txt.embedFonts=true;
			this.addChild(txt);
			
			this.addChild(line);
			logoSprite=new Sprite;
			logoSprite.addChild(logo);
			
			this.logoSprite.x=100;
			this.addChild(logoSprite);
			
		
		
			this.addEventListener(TUIOEvent.TUIO_DOWN,downHandler);
			this.lineName="比例:100%";
			
			logoSprite.addEventListener(MouseEvent.MOUSE_DOWN,mouseDown);
		}
		private function mouseDown(e:MouseEvent):void
		{
			
			this.addEventListener(MouseEvent.MOUSE_UP,mouseUp);
			this.addEventListener(MouseEvent.MOUSE_OUT,mouseUp);
			logoSprite.startDrag(false,new Rectangle(100,0,this.width-100-logo.width,0));
			this.addEventListener(Event.ENTER_FRAME,enter);
		}
		private function mouseUp(e:MouseEvent):void
		{
			logoSprite.stopDrag();
			this.removeEventListener(MouseEvent.MOUSE_UP,mouseUp);
			this.removeEventListener(MouseEvent.MOUSE_OUT,mouseUp);
		     var timeEvent:TimerEvent=new TimerEvent(TimerEvent.timerEvent);
		    
		     timeEvent.ratio=(this.logoSprite.x-100)/(this.width-100-logo.width)*100*5;	 
		     this.removeEventListener(Event.ENTER_FRAME,enter);
		     this.dispatchEvent(timeEvent); 
		     this.lineName="比例:"+Math.round(timeEvent.ratio).toFixed(2)+"%";
			 this.invalidate();
			
		}
		private function enter(e:Event):void
		{
			 var ratio:Number=(this.logoSprite.x-100)/(this.width-100-logo.width)*100*5;
			 this.lineName="比例:"+Math.round(ratio).toFixed(2)+"%";
			 this.invalidate();
		}
		private function downHandler(e:TUIOEvent):void
		{
			e.stopPropagation();
			
			
		}
		
		protected function onTimeMoveEnd(e:TimerEvent):void
		{
			
			this.dispatchEvent(e.clone()); 
			e.stopPropagation();
			
		}
		
		public var lineName:String="";
		
		
		override public function get width():Number
		{
			return super.width<100?100:super.width;
		}
		override public function get height():Number
		{
			return super.height<60?60:super.height;
		}
		
		
		
		override public function draw():void
		{
			var g:Graphics=this.graphics;
			g.clear()
			g.lineStyle(1,0x3322ff,0);
			g.beginFill(0x992255,0);
			g.drawRect(0,0,this.width,this.height);
			g.endFill();
			
			if(txt){
				txt.text=this.lineName;
				txt.width=100;
				txt.height=this.height;
				txt.setTextFormat(Style.getTFTXT());
				txt.width=200;
			}
			if(line){
				this.line.x=100;
				this.line.y=20;
				this.line.width=this.width-100;
			}
			
			
			
			
			
		}
		override public function dispose():void
		{
			
		
			super.dispose();
			
			txt=null;
			
			
		}
		
		
	}
}