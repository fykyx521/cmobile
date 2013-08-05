package com.careland
{
	import flash.display.Graphics;
	import flash.display.Sprite;
	import flash.events.Event;
	
	public class CLDBase extends Sprite
	{
		public function CLDBase()
		{
			super();
			
			addChildren();
		}
		
		
		
		public function addChildren():void
		{
			this.invalidate();
		}
		protected var _width:Number = 500;
		protected var _height:Number = 300;
		override public function set width(w:Number):void
		{
			_width = w;
			invalidate();
			dispatchEvent(new Event(Event.RESIZE));
		}
		override public function get width():Number
		{
			return _width;
		}
		
		/**
		 * Sets/gets the height of the component.
		 */
		override public function set height(h:Number):void
		{
			_height = h;
			invalidate();
			dispatchEvent(new Event(Event.RESIZE));
			
		}
		override public function get height():Number
		{
			return _height;
		}
		
		protected function invalidate():void
		{
			this.addEventListener(Event.ENTER_FRAME, onInvalidate);
		}
		
		protected function onInvalidate(event:Event):void
		{
			this.removeEventListener(Event.ENTER_FRAME, onInvalidate);
			draw();
		}
		
		public function draw():void
		{
			
			
			
		}
	}
}