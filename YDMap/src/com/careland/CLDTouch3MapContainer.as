package com.careland
{
	import com.careland.util.CLDConfig;
	
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Transform;
	
	import org.gestouch.events.GestureEvent;
	import org.gestouch.gestures.PanGesture;
	import org.gestouch.gestures.ZoomGesture;
	
	public class CLDTouch3MapContainer extends CLDMapContainer
	{
		private var  zoomSprite:Sprite;
		private var panGesture:PanGesture;
		private var zoomGesture:ZoomGesture;
		private var oldTransform:Matrix;
		private var offset:Point;
		public function CLDTouch3MapContainer(config:CLDConfig, center:Point, vzoom:int)
		{
			super(config, center, vzoom);
			zoomSprite=new Sprite;
			this.addChild(zoomSprite);
		}
		
		override protected function addChildren():void
		{
			super.addChildren();
			this.contentEnabled=false;
			panGesture=new PanGesture(this);
			panGesture.maxNumTouchesRequired=1;
			panGesture.minNumTouchesRequired=1;
			panGesture.addEventListener(GestureEvent.GESTURE_BEGAN,pan);
			panGesture.addEventListener(GestureEvent.GESTURE_CHANGED,pan);
			panGesture.addEventListener(GestureEvent.GESTURE_ENDED,pan);
			
			zoomGesture=new ZoomGesture(this);
			zoomGesture.addEventListener(GestureEvent.GESTURE_BEGAN,zoomHandler);
			zoomGesture.addEventListener(GestureEvent.GESTURE_CHANGED,zoomHandler);
			zoomGesture.addEventListener(GestureEvent.GESTURE_ENDED,zoomHandler);
		    
			
			
		}
		private function pan(e:GestureEvent):void
		{
			  var gesture:PanGesture=e.target as PanGesture;
			 switch(e.type)
			 {
				 case GestureEvent.GESTURE_BEGAN:
					 firstPoint=new Point(content.x,content.y);
					 offset=new Point(0,0);
				  break;
				 case GestureEvent.GESTURE_CHANGED:
					 this.content.x=content.x+gesture.offsetX-offset.x;
					 this.content.y=content.y+gesture.offsetY-offset.y;
					 offset=new Point(gesture.offsetX,gesture.offsetY);
					 break;
				 case GestureEvent.GESTURE_ENDED:
					 this.upHandler();
					 this.deletebitmapSprite(this.zoomSprite);
					 break;
				 
					 
			 }
		}
		private function zoomHandler(e:GestureEvent):void
		{
			 var gesture:ZoomGesture=e.target as ZoomGesture;
			var m:Matrix = zoomSprite.transform.matrix;
			var lp:Point=zoomGesture.location;
			
			switch(e.type)
			{
				case GestureEvent.GESTURE_BEGAN:
					this.deletebitmapSprite(this.zoomSprite);
					if(this.oldTransform)
					{
						zoomSprite.transform.matrix=this.oldTransform;
					}
					var bit:Bitmap=this.drawCurrent();
					this.zoomSprite.addChild(bit);
					oldTransform=this.zoomSprite.transform.matrix.clone();
					
					this.setChildIndex(this.zoomSprite,this.numChildren-1);
					this.content.visible=false;
					break;
				case GestureEvent.GESTURE_CHANGED:
					var p:Point = m.transformPoint(this.globalToLocal(lp));
					m.translate(-p.x, -p.y);
					m.scale(gesture.scaleX, gesture.scaleY);
					m.translate(p.x, p.y);
					zoomSprite.transform.matrix = m;
					break;
				case GestureEvent.GESTURE_ENDED:
					this.setChildIndex(this.zoomSprite,0);
					this.scaleMap(m.a,lp);
					this.content.visible=true;  
					break;
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
				this.deletebitmapSprite(zoomSprite);
			}
		}
		override public function dispose():void
		{
			
			this.deletebitmapSprite(this.zoomSprite);
			if(panGesture)
			{
				panGesture.removeEventListener(GestureEvent.GESTURE_BEGAN,pan);
				panGesture.removeEventListener(GestureEvent.GESTURE_CHANGED,pan);
				panGesture.removeEventListener(GestureEvent.GESTURE_ENDED,pan);
				panGesture.dispose();
				panGesture=null;
			}
			if(zoomGesture)
			{
				zoomGesture.removeEventListener(GestureEvent.GESTURE_BEGAN,zoomHandler);
				zoomGesture.removeEventListener(GestureEvent.GESTURE_CHANGED,zoomHandler);
				zoomGesture.removeEventListener(GestureEvent.GESTURE_ENDED,zoomHandler);
				zoomGesture.dispose();
				zoomGesture=null;
				
			}
			super.dispose();
		}
		private function deletebitmapSprite(sp:Sprite):void
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
		
	}
}