package com.careland.component
{
	import com.careland.component.layout.*;
	import com.careland.gesevents.CLDTwoFingerEvent;
	import com.careland.gesture.CLDDoubleFingerTab;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.events.Event;
	
	import fr.mazerte.controls.openflow.itemRenderer.IItemRenderer;
	
	import org.gestouch.events.GestureEvent;
	import org.gestouch.gestures.PanGesture;
	import org.gestouch.gestures.ZoomGesture;

	public class LayoutItemRenderer extends CLDDoubleFingerTab implements IItemRenderer
	{
		private var _data:*;
		private var _index:int;  
		public var bitdata:BitmapData;
		public var viewID:Number;
		
		private var zoomGesture:ZoomGesture;
//		public var currentWin:CLDLayoutUI;
		public function LayoutItemRenderer()
		{
			super();
			//ipad 上的放大手势 
			zoomGesture=new ZoomGesture(this);
			zoomGesture.addEventListener(GestureEvent.GESTURE_BEGAN,gesture);
			zoomGesture.addEventListener(GestureEvent.GESTURE_CHANGED,gesture);
			
		}
		private function gesture(e:Event):void
		{
			 if(zoomGesture&&zoomGesture.scaleX>1)
			 {
				  this.dispatchEvent(new CLDTwoFingerEvent(CLDTwoFingerEvent.CLD_TWO_FINGER_TAB));
			 }
		}
		
		override public function get width():Number{
			return 524;
		}
		override public function get height():Number{
			return 444;
		}
		
		public function setData(data:*):void
		{
			_data = data;
			bitdata=this._data.view;
			this.viewID=this._data.viewID;
//			this.currentWin=this._data.currentWin;
			var bit:Bitmap=new Bitmap(bitdata);
			bit.width=this.width;
			bit.height=this.height;
			this.addChild(bit);
			//addView();
			
		}
		
		public function get xmlData():XML
		{
			return _data.data;
		}
		
		public function get param():String{
			return _data.viewParam;
		}
		
		
		
		public function addView():void
		{
			
			
		}
		
		public function get index():int
		{
			return _index;
		}
		
		public function set index(i:int):void
		{
			_index = i;
		}
		
		public function focusIn():void 
		{
			//trace('focusIn: ' + _index);
		}
		
		public function focusOut():void 
		{
			//trace('focusOut: ' + _index);
		}
		
		public function rollOver():void
		{
			trace('rollOver: ' + _index);
		}
		
		public function rollOut():void
		{
			trace('rollOut: ' + _index);
		}
		
		
		override public function dispose():void
		{
			super.dispose();
			if(this.bitdata){
				bitdata.dispose();
				bitdata=null;
			}
		}
		override public function clone():Sprite
		{
			var sp:Sprite=new Sprite();
			var bit:Bitmap= new Bitmap(this.bitdata);
			sp.addChild(bit);
			return sp;
		}
		
		
		
		
		
	}
}