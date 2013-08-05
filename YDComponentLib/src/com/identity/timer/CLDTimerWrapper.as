package com.identity.timer
{
	import __AS3__.vec.Vector;
	
	import com.careland.component.CLDBaseComponent;
	import com.careland.component.util.Style;
	import com.careland.event.TimerEvent;
	
	import flash.display.DisplayObjectContainer;
	import flash.display.Graphics;
	import flash.geom.Point;
	import flash.text.TextField;

	public class CLDTimerWrapper extends CLDBaseComponent
	{
		private var cldTimer:CLDTimer;
		private var _points:Vector.<Point>=new Vector.<Point>();//2条线的坐标
		public var lineName:String;//线路名字
		private var txt:TextField;
		
		private var obj:Object;
		public var id:int;//线路的ID
		public function CLDTimerWrapper(parent:DisplayObjectContainer=null, xpos:Number=0, ypos:Number=0, autoLoad:Boolean=false, timeInteval:int=0)
		{
			super(parent, xpos, ypos, autoLoad, timeInteval);
		}
		
		override protected function addChildren():void
		{
			cldTimer=new CLDTimer();
			this.addChild(cldTimer);
			
			txt=new TextField;
			txt.selectable=false;
			txt.wordWrap=true;
			txt.embedFonts=true;
			this.addChild(txt);
			cldTimer.addEventListener(TimerEvent.timerEvent,onTimeMoveEnd);
		}
		
		protected function onTimeMoveEnd(e:TimerEvent):void
		{
			if(this._points&&this._points.length>0){
				var ratio:int=this._points.length*Math.round(e.ratio)/100;
				if(ratio>this._points.length){
					return;
				}
				var te:TimerEvent=e.clone() as TimerEvent;
				te.ratio=ratio;
				te.id=this.id;
				te.point=this._points[ratio];
			//te.points=this._points;
				this.dispatchEvent(te);	
			}
			
		}
		//设置100%比
		public function set radio(v:int):void
		{
			this.cldTimer.setLogoValue(v);
		}
		
		
		public function get points():Vector.<Point>
		{
			return this._points;
		}
		override public function get width():Number
		{
			return super.width<100?100:super.width;
		}
		override public function get height():Number
		{
			return super.height<60?60:super.height;
		}
		
		public function setLineOption(value:CLDTimerModel):void
		{
			obj=value;
			this.lineName=value.lineName;
			this._points=value.points;
			this.id=value.id;
			trace(this._points);
			this.invalidate();
		}
		
		override public function draw():void
		{
			var g:Graphics=this.graphics;
			g.clear()
			g.lineStyle(1,0x3322ff,.1);
			g.beginFill(0x992255,.1);
			g.drawRoundRect(0,0,this.width,this.height,5);
			g.endFill();
			
			
			txt.text=this.lineName;
			txt.setTextFormat(Style.getTFTXT());
			txt.width=200;
			if(this.cldTimer){
				cldTimer.setSize(this.width-200,20);
				cldTimer.x=200;
				cldTimer.y=15;
			}
			
		}
		override public function dispose():void
		{
			
			if(this.cldTimer){
				cldTimer.removeEventListener(TimerEvent.timerEvent,onTimeMoveEnd);
			}
			super.dispose();
			this.cldTimer=null;
			txt=null;
			this._points=null;
			
		}
		
		
	}
}