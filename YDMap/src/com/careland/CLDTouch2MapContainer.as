package com.careland
{
	import com.careland.util.CLDConfig;
	import com.touchlib.TUIO;
	import com.touchlib.TUIOEvent;
	import com.touchlib.TUIOObject;
	
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.TouchEvent;
	import flash.events.TransformGestureEvent;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.ui.Multitouch;
	import flash.ui.MultitouchInputMode;

	public class CLDTouch2MapContainer extends CLDMapContainer
	{
		
		private var GRAD_PI:Number=180.0 / 3.14159;
		
		private var blobs:Array=[];
		private var state:String="none";
		private var blob1:Object;
		private var blob2:Object;
		private var curScale:Number;
		private var curPosition:Point=new Point(0,0);
		
		private var isScale:Boolean=false;
		
		private var zoomSprite:Sprite;
		   
		private var zoomCenter:Point;
		
		private var touchPoints:Array=[];
		
		public function CLDTouch2MapContainer(config:CLDConfig, center:Point, vzoom:int)
		{
			super(config, center, vzoom);
			zoomSprite=new Sprite;
			this.addChild(zoomSprite);
		}
		override protected function addChildren():void
		{
			super.addChildren();
			this.contentEnabled=false;
			
			flash.ui.Multitouch.inputMode=flash.ui.MultitouchInputMode.TOUCH_POINT;
			this.addEventListener(TouchEvent.TOUCH_BEGIN,touchBegin);
//			this.addEventListener(TransformGestureEvent.GESTURE_PAN, panEvent);
			this.addEventListener(TransformGestureEvent.GESTURE_ZOOM, zoomEvent);
			
		}
		private function touchBegin(e:TouchEvent):void
		{
			for(var i:int=0;i<this.touchPoints.length;i++)
			{
				if(this.touchPoints[i]==e.touchPointID)
				{
					return;
				}
			}
			touchPoints.push(e.touchPointID);
			if(touchPoints.length>1)
			{
				flash.ui.Multitouch.inputMode=flash.ui.MultitouchInputMode.GESTURE;
				this.removeEventListener(TouchEvent.TOUCH_BEGIN,touchBegin);
				this.removeEventListener(TouchEvent.TOUCH_MOVE,touchMove);
				this.removeEventListener(TouchEvent.TOUCH_END,touchEnd);
				
			}
			if(touchPoints.length==1)
			{
				flash.ui.Multitouch.inputMode=flash.ui.MultitouchInputMode.TOUCH_POINT;
				
				
				
				//删除截图
				this.deletebitmapSprite(this.zoomClass);
				
				this.prePoint=new Point(e.stageX,e.stageY);
				firstPoint=new Point(content.x,content.y);
				this.addEventListener(TouchEvent.TOUCH_MOVE,touchMove);
				this.addEventListener(TouchEvent.TOUCH_END,touchEnd);
			}
			if(touchPoints.length==0)
			{
				this.content.visible=true;
			}
		}
		private function touchMove(e:TouchEvent):void
		{
			var newPoint:Point=new Point(e.stageX,e.stageY);
			var disPoint:Point=newPoint.subtract(prePoint);
			this.content.x+=disPoint.x;
			this.content.y+=disPoint.y;
			this.prePoint=newPoint;	
		}
		private function touchEnd(e:TouchEvent):void
		{
			for(var i:int=0;i<this.touchPoints.length;i++)
			{
				if(this.touchPoints[i]==e.touchPointID)
				{
					this.touchPoints.splice(i,1);
				}
			}
			this.removeEventListener(TouchEvent.TOUCH_MOVE,touchMove);
			this.removeEventListener(TouchEvent.TOUCH_END,touchEnd);
			this.moveEnd();
		}
		
		private function panEvent(e:TransformGestureEvent):void
		{
			this.deletebitmapSprite(this.zoomClass);
			if(e.phase==flash.events.GesturePhase.BEGIN)
			{
				this.firstPoint=new Point(content.x,content.y);//i
			}
			
			this.content.x+=e.offsetX;
			this.content.y+=e.offsetY;
			if(e.phase==flash.events.GesturePhase.END)
			{
				this.moveEnd(null);
			}
			
		}
		private function moveEnd(e:Event=null):void
		{
			this.upHandler(null);
		}
		
		
		private var oldTransform:Matrix;
		
		private function zoomEvent(e:TransformGestureEvent):void
		{
			var bitwidth:Number=0;
			var bitheight:Number=0;
			
			if(e.phase==flash.events.GesturePhase.BEGIN)
			{
				this.deletebitmapSprite(this.zoomClass);
				
				if(this.oldTransform)
				{
					zoomClass.transform.matrix=this.oldTransform;
				}
				
				var bit:Bitmap=this.drawCurrent();
				this.zoomClass.addChild(bit);
				oldTransform=this.zoomClass.transform.matrix.clone();
				bitwidth=bit.width;
				bitheight=bit.height;
				this.setChildIndex(this.zoomClass,this.numChildren-1);
				this.content.visible=false;
			}
			
			var m:Matrix = zoomSprite.transform.matrix;
			var lp:Point=this.globalToLocal(new Point(e.stageX, e.stageY));
			var p:Point = m.transformPoint(lp);
			m.translate(-p.x, -p.y);
			m.scale(e.scaleX, e.scaleY);
			m.translate(p.x, p.y);
			zoomSprite.transform.matrix = m;
			if(e.phase==flash.events.GesturePhase.END)
			{
				
				this.setChildIndex(this.zoomClass,0);
				this.scaleMap(m.a,lp);
				flash.ui.Multitouch.inputMode=flash.ui.MultitouchInputMode.TOUCH_POINT;
				this.addEventListener(TouchEvent.TOUCH_BEGIN,touchBegin);
				this.touchPoints=[];
				this.content.visible=true;
			}
		}
		
		override public function dispose():void
		{
			this.removeEventListener(TouchEvent.TOUCH_BEGIN,touchBegin);
			this.removeEventListener(TouchEvent.TOUCH_MOVE,touchMove);
			this.removeEventListener(TouchEvent.TOUCH_END,touchEnd);
			this.removeEventListener(TransformGestureEvent.GESTURE_ZOOM, zoomEvent);
			super.dispose();
		}
		
		override public function set tuioEnabled(value:Boolean):void
		{
			if(value){
				flash.ui.Multitouch.inputMode=flash.ui.MultitouchInputMode.TOUCH_POINT;
			}else
			{
				flash.ui.Multitouch.inputMode=flash.ui.MultitouchInputMode.NONE;
			}
			
		}
	
		private function scaleMap(scale:Number,center:Point):void
		{
			
			
			var disScale:Number=scale-1;
			var booleanLoadMap:Boolean=false;
			var temp:Number=this.zoom;
			if(disScale>.5)
			{
				temp++; 
				booleanLoadMap=true;
			}else if(disScale<-0.5)
			{
				temp--;
				booleanLoadMap=true;
			}
			if(booleanLoadMap)
			{
				var newCenter:Point=this.getCenterByPoint(center,temp);
//				this.zoom=temp;
//				this.center=newCenter;
//				this.loadMapPic(newCenter);
				this.setCenterAndZoom(newCenter,temp);
			}
			
			//
			
			
		}
		private function  deletebitmapSprite(sp:Sprite):void
		{
			
			if(!sp)return;
			while (sp.numChildren > 0)
			{
				var dis:DisplayObject=sp.removeChildAt(0);
				if(dis is Bitmap){
					(dis as Bitmap).bitmapData.dispose();
				}
			}
			//doClearance();
		}
		private function get zoomClass():Sprite
		{
			return this.zoomSprite;
			
		}
		
	}
}