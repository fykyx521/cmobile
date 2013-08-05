package com.careland.viewer
{
	import com.bit101.components.HScrollBar;
	import com.bit101.components.Style;
	import com.bit101.components.VScrollBar;
	
	import flash.display.DisplayObjectContainer;
	import flash.display.Shape;
	import flash.events.Event;
	import flash.events.MouseEvent;

	public class CLDScrollDocView extends CLDDocView
	{
		protected var _vScrollbar:VScrollBar;
		
		protected var _corner:Shape;
		protected var _dragContent:Boolean = true;
		public function CLDScrollDocView(parent:DisplayObjectContainer=null, xpos:Number=0, ypos:Number=0, autoLoad:Boolean=false, timeInteval:int=0)
		{
			super(parent, xpos, ypos, autoLoad, timeInteval);
		}
		
		override protected function init():void
		{
			super.init();
			addEventListener(Event.RESIZE, onResize);

			setSize(100, 100);
		}
		
		/**
		 * Creates and adds the child display objects of this component.
		 */
		override protected function addChildren():void
		{
			super.addChildren();
			_vScrollbar = new VScrollBar(this, width - 20, 0, onScroll);
			
//			_corner = new Shape();
//			
//			_corner.graphics.beginFill(Style.BUTTON_FACE);
//			_corner.graphics.drawRect(0, 0, 10, 10);
//			_corner.graphics.endFill();
//			addChild(_corner);
			this.content.addEventListener(MouseEvent.MOUSE_MOVE,contentMoveHander);
			
		}
		private function scrollUp(e:Event):void
		{
			
		}
		
		override protected function updateScroll():void
		{
			this._vScrollbar.value=-this.content.y;
		}
		
		///////////////////////////////////
		// public methods
		///////////////////////////////////
		
		/**
		 * Draws the visual ui of the component.
		 */
		override public function draw():void
		{
			super.draw();

		
			
			_vScrollbar.x = width - 20;
			_vScrollbar.height = height;
			_vScrollbar.width= 50;
			

			_vScrollbar.setThumbPercent((_height - 50) / content.height);
			_vScrollbar.maximum = Math.max(0, content.height - _height + 50);
			_vScrollbar.pageSize = this.loadManage.totalPage;
 	        
//			_corner.x = width - 50;
//			_corner.y = height - 50;
			
			//content.y = -_vScrollbar.value;
		}
		
		/**
		 * Updates the scrollbars when content is changed. Needs to be done manually.
		 */
		public function update():void
		{
			invalidate();
		}
		
		
		///////////////////////////////////
		// event handlers
		///////////////////////////////////
		
		/**
		 * Called when either scroll bar is scrolled.
		 */
		protected function onScroll(event:Event):void
		{
			//content.x = -_hScrollbar.value;
			content.y = -_vScrollbar.value;
			
			//this.updatePoint();	
		
		}
		
		protected function onResize(event:Event):void
		{
			invalidate();
		}
		
		override protected function downHandler(e:MouseEvent):void
		{
			super.downHandler(e);
			stage.addEventListener(MouseEvent.MOUSE_UP,upHandler);
		}
		override protected function moveHandler(e:MouseEvent):void
		{
			super.moveHandler(e);
			// _vScrollbar.value = -content.y;
			//content.y=- _vScrollbar.value;
		}
		private function contentMoveHander(e:MouseEvent):void{
		        _vScrollbar.value = -content.y;
		}
		override protected function upHandler(e:MouseEvent):void
		{
			super.upHandler(e);
			content.y=- _vScrollbar.value;
			stage.removeEventListener(MouseEvent.MOUSE_UP,upHandler);
			this.updatePoint();
		}
		
		


		public function set dragContent(value:Boolean):void
		{
//			_dragContent = value;
//			if(_dragContent)
//			{
//				_background.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
//				_background.useHandCursor = true;
//				_background.buttonMode = true;
//			}
//			else
//			{
//				_background.removeEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
//				_background.useHandCursor = false;
//				_background.buttonMode = false;
//			}
		}
		public function get dragContent():Boolean
		{
			return _dragContent;
		}

		
	}
}