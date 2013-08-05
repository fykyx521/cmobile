package com.identity.timer
{
	import __AS3__.vec.Vector;
	
	import com.careland.component.CLDBaseComponent;
	import com.careland.event.TimerEvent;
	
	import flash.display.DisplayObjectContainer;
	//时间轴组件
	public class CLDTimerGroup extends CLDBaseComponent
	{
		private var _points:Vector.<CLDTimerModel>;
		
		private var posy:Number=0;
		
		private var timerArray:Array=[];
		public function CLDTimerGroup(parent:DisplayObjectContainer=null, xpos:Number=0, ypos:Number=0, autoLoad:Boolean=false, timeInteval:int=0)
		{
			super(parent, xpos, ypos, autoLoad, timeInteval);
		}
		
		public function set points(value:Vector.<CLDTimerModel>):void
		{
			_points=value;
			initTimer();
		}
		public function set timerModel(tm:CLDTimerModel):void
		{
			var timer:CLDTimerWrapper=new CLDTimerWrapper();
			timer.setLineOption(tm);
			timer.setSize(this.width,this.height/2);
			timer.y=posy;
			posy+=this.height/2;
			this.addChild(timer);
			timer.addEventListener(TimerEvent.timerEvent,onUpHandler);
			timerArray.push(timer);
		}
		
		public function setRadio(id:int,radio:int):void
		{
			if(!this.timerArray)return;
			for(var i:int=0;i<this.timerArray.length;i++)
			{
				if(timerArray[i].id==id){
					timerArray[i].radio=radio;
				}
			}
		}
		
		private function initTimer():void
		{
			var timerLenth:int=this._points.length;
			var posy:Number=0;
			for(var i:int=0;i<timerLenth;i++){
				var timer:CLDTimerWrapper=new CLDTimerWrapper();
				
				timer.setLineOption(_points[i] as CLDTimerModel);
				timer.setSize(this.width,this.height/2);
				timer.y=posy;
				posy+=this.height/2;
				this.addChild(timer);
				
				timer.addEventListener(TimerEvent.timerEvent,onUpHandler);
			}
			
			
		}
		private function onUpHandler(e:TimerEvent):void
		{
				var e:TimerEvent=e.clone() as TimerEvent;
				this.dispatchEvent(e);
			
			
		}
		override public function dispose():void
		{
			super.dispose();
			posy=undefined;
			timerArray=null;
		}
		
		
	}
}