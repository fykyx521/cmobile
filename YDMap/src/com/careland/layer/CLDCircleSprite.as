package com.careland.layer
{
	import com.careland.Base;
	import com.careland.events.DynamicEvent;
	import com.careland.util.StyleDraw;
	import com.foxaweb.ui.gesture.GestureEvent;
	import com.foxaweb.ui.gesture.MouseGesture;
	import com.touchlib.TUIO;
	import com.touchlib.TUIOEvent;
	import com.touchlib.TUIOObject;
	
	import flash.display.Graphics;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;

	public class CLDCircleSprite extends Base
	{
		private var circle:Sprite;
		protected var blobs:Array=[];
		
		private var mg:MouseGesture;
		
		
		public function CLDCircleSprite()
		{
			super();
		}
		override protected function addChildren():void
		{
			initGraphicsSprite();
			initGesture();
		}
		protected function initGraphicsSprite():void
		{
			circle=new Sprite;
			this.addChild(circle);
			
			this.addEventListener(TUIOEvent.TUIO_DOWN,downEvent);
			this.addEventListener(TUIOEvent.TUIO_UP,upEvent);
			
		}
		public function set IsIpad(value:Boolean):void
		{
			if(value)
			{
				this.addEventListener(MouseEvent.MOUSE_DOWN,downHandler);
			}
		}
		protected function downHandler(e:MouseEvent):void
		{
			this.addEventListener(MouseEvent.MOUSE_MOVE,moveHandler);
			this.addEventListener(MouseEvent.MOUSE_UP,upHandler);
			var g:Graphics=this.circle.graphics;
			g.clear();
			g.lineStyle(10,0x333fff,1);
			//var globel:Point=img.localToGlobal(new Point(origX,origY));
			g.moveTo(this.mouseX,this.mouseY);
		}
		private function moveHandler(e:MouseEvent):void
		{
			var g:Graphics=this.circle.graphics;
			g.lineTo(this.mouseX,this.mouseY);
		}
		private function upHandler(e:MouseEvent):void
		{
			this.removeEventListener(MouseEvent.MOUSE_MOVE,moveHandler);
			this.removeEventListener(MouseEvent.MOUSE_UP,upHandler);
			var g:Graphics=circle.graphics;
			g.endFill();		
		}
		
		
		
		protected function initGesture():void
		{
			mg=new MouseGesture(this);
			mg.addGesture("o","432107654");
			mg.addGesture("S","432101234");
			mg.addGesture("8","4321234567654");
			mg.addGesture("U","21076");
			mg.addGesture("c","43210");//必须加个c8s 因为只有一个o的话，很容易匹配到
			mg.addEventListener(GestureEvent.GESTURE_MATCH,matchHandler);
			mg.addEventListener(GestureEvent.NO_MATCH,nomatchHandler);
		}
		private function matchHandler(e:GestureEvent):void
		{
//			var dy:DynamicEvent=new DynamicEvent("circleDrawend");
//			if(e.datas=="o"){
//				
//				
////				circle.addEventListener(MouseEvent.CLICK,clickHandler);
//				dy.infos=e.infos;
//				dy.match=true;
//				this.dispatchEvent(dy); 
//			}else{
//				
//				dy.match=false;
//				this.dispatchEvent(dy); 
//			}
			if(e.datas=="o"){
				var infos:Object=e.infos;
				var rect:Rectangle=e.infos.rect;
				var centerPoint:Point=new Point(rect.x+rect.width/2,rect.y+rect.height/2);
				var g:Graphics=this.circle.graphics;
				g.clear();
				
				g.moveTo(centerPoint.x,centerPoint.y);
				g.lineStyle(2,StyleDraw.lineStyle,.3);
				g.beginFill(StyleDraw.drawStyle,.2);
				g.drawCircle(centerPoint.x,centerPoint.y,rect.width/2);
				g.endFill();
				
				
				this.mg.pause();
				this.circle.addEventListener(MouseEvent.MOUSE_DOWN,clickHandler);
				this.addEventListener(MouseEvent.MOUSE_DOWN,clickHandler);
			}else{
				var dy:DynamicEvent=new DynamicEvent("circleDrawend");
				dy.match=false;
				this.dispatchEvent(dy); 
			}
		     function clickHandler(e1:Event):void
			 {
			 	e1.target.removeEventListener(MouseEvent.CLICK,clickHandler);
			 	e1.stopPropagation();
			 	var dy:DynamicEvent=new DynamicEvent("circleDrawend");
			 	if(e1.target===this){
			 		
					dy.match=false;
					dispatchEvent(dy);
			 		return;
			 	}
				
				dy.match=true;
				dy.infos=infos;
				dispatchEvent(dy);
			 }
		
		}
		
		
		private function cancelDraw(e:Event):void
		{
			
			if(e.target!=this){
				return;
			}
			e.stopPropagation();
			e.target.removeEventListener(MouseEvent.CLICK,cancelDraw);
			var dy:DynamicEvent=new DynamicEvent("circleDrawend");
			dy.match=false;
			this.dispatchEvent(dy);
		}
		
		private function nomatchHandler(e:GestureEvent):void
		{
			var dy:DynamicEvent=new DynamicEvent("circleDrawend");
			dy.match=false;
			this.dispatchEvent(dy);
		}
		protected function addBlob(id:Number, origX:Number, origY:Number):void
		{
			//防止重复添加
			for(var i:int=0; i<blobs.length; i++)
			{
				if(blobs[i].id == id)
					return;
			}	
			//添加一个触点到队列		
			blobs.push( {id: id, origX: origX, origY: origY, myOrigX: x, myOrigY:y} );
			
		}
		protected function removeBlob(id:Number):void
		{
			for(var i:Number=0; i<blobs.length; i++)
			{
				if(blobs[i].id == id) 
				{
					blobs.splice(i, 1);					
				}
			}
		}
		public function downEvent(e:TUIOEvent):void
		{		
			if(e.stageX == 0 && e.stageY == 0)
				return;	
				
			var curPt:Point = parent.globalToLocal(new Point(e.stageX, e.stageY));									
			addBlob(e.ID, curPt.x, curPt.y);	
				
			e.stopPropagation();
			var g:Graphics=this.circle.graphics;
			g.clear();
			
			g.lineStyle(10,0x333fff,1);
			//var globel:Point=img.localToGlobal(new Point(origX,origY));
			g.moveTo(curPt.x, curPt.y);

			//g.endFill();
			this.addEventListener(Event.ENTER_FRAME,update);
			
		}
		public function upEvent(e:TUIOEvent):void
		{		
			removeBlob(e.ID);				
			e.stopPropagation();	
			this.removeEventListener(Event.ENTER_FRAME,update);	
			var g:Graphics=circle.graphics;
			g.endFill();		
			
		
			
		}	
		
		override public function draw():void
		{
			var g:Graphics=this.graphics;
			g.clear();
			g.beginFill(0xffffff,.1);
			g.lineStyle(1,0x000000,1);
			g.drawRect(0,0,this.width,this.height);
			g.endFill();
		}
		override public function dispose():void
		{
			this.removeEventListener(Event.ENTER_FRAME,update);
			this.removeEventListener(TUIOEvent.TUIO_DOWN,downEvent);
			this.removeEventListener(TUIOEvent.TUIO_UP,upEvent);
			this.removeEventListener(MouseEvent.MOUSE_DOWN,downHandler);
			if(mg){
				
				mg=null;
			}
		}
		
		public function update(e:Event):void
		{
				if(blobs.length>0){
					
					var g:Graphics=this.circle.graphics;
					var tuioobj:TUIOObject=TUIO.getObjectById(blobs[0].id);
					if(tuioobj){
						//var curPt:Point = new Point(tuioobj.oldX, tuioobj.oldY);
						
						var curPt:Point=new Point(tuioobj.x,tuioobj.y);
						curPt = parent.globalToLocal(new Point(curPt.x, curPt.y));				
						g.lineTo(curPt.x,curPt.y);
					//g.moveTo(curPt.x,curPt.y);
					}
				
					
				}
		}
		
	}
}